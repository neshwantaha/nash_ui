import 'dart:async';

/// Notification payload model.
class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.scheduledAt,
  });

  /// Unique notification ID.
  final int id;

  /// Notification title.
  final String title;

  /// Notification description or message body.
  final String body;

  /// Optional JSON payload string or data.
  final String? payload;

  /// Scheduled delivery timestamp.
  final DateTime? scheduledAt;
}

/// A unified service for scheduling and presenting notifications.
abstract final class AppNotifications {
  AppNotifications._();

  static final List<AppNotificationItem> _history = <AppNotificationItem>[];

  /// Pluggable notifier handler.
  static Future<void> Function(AppNotificationItem notification)?
      customNotifier;

  /// Pluggable notification tap callback.
  static void Function(String? payload)? onNotificationTapped;

  /// Shows an immediate notification.
  static Future<void> show({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final AppNotificationItem item = AppNotificationItem(
      id: id ?? DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
      payload: payload,
    );
    _history.add(item);

    if (customNotifier != null) {
      await customNotifier!(item);
    }
  }

  /// Schedules a notification to be presented at [at].
  static Future<void> schedule({
    int? id,
    required String title,
    required String body,
    required DateTime at,
    String? payload,
  }) async {
    final AppNotificationItem item = AppNotificationItem(
      id: id ?? DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
      payload: payload,
      scheduledAt: at,
    );
    _history.add(item);

    if (customNotifier != null) {
      await customNotifier!(item);
    }
  }

  /// Returns the notification history.
  static List<AppNotificationItem> get history =>
      List<AppNotificationItem>.unmodifiable(_history);

  /// Clears notification history.
  static void clearHistory() => _history.clear();
}
