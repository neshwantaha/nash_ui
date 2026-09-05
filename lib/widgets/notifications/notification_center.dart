import 'dart:async';

import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// In-app notification center with push-style UI.
///
/// ```dart
/// NotificationCenter.of(context).show(
///   Notification(
///     title: 'New message',
///     body: 'You have a new message from John',
///     type: NotificationType.info,
///   ),
/// )
/// ```
class NotificationCenter extends StatefulWidget {
  const NotificationCenter({
    super.key,
    required this.child,
    this.maxVisible = 5,
    this.position = NotificationPosition.topRight,
    this.autoDismissDuration = const Duration(seconds: 4),
    this.onNotificationTap,
  });

  /// The child widget tree.
  final Widget child;

  /// Maximum visible notifications.
  final int maxVisible;

  /// Position of the notification overlay.
  final NotificationPosition position;

  /// Auto-dismiss duration (null to disable).
  final Duration? autoDismissDuration;

  /// Callback when a notification is tapped.
  final void Function(Notification notification)? onNotificationTap;

  /// Access the nearest [NotificationCenter] state.
  static NotificationCenterState of(BuildContext context) {
    final NotificationCenterState? state =
        context.findAncestorStateOfType<NotificationCenterState>();
    assert(state != null, 'NotificationCenter not found in widget tree.');
    return state!;
  }

  @override
  State<NotificationCenter> createState() => NotificationCenterState();
}

class NotificationCenterState extends State<NotificationCenter>
    with SingleTickerProviderStateMixin {
  final List<_NotificationEntry> _entries = <_NotificationEntry>[];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    for (final _NotificationEntry entry in _entries) {
      entry.timer?.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  /// Show a notification.
  void show(Notification notification) {
    if (_entries.length >= widget.maxVisible) {
      _dismiss(_entries.first);
    }

    final _NotificationEntry entry = _NotificationEntry(
      notification: notification,
    );

    if (widget.autoDismissDuration != null) {
      entry.timer = Timer(widget.autoDismissDuration!, () {
        _dismiss(entry);
      });
    }

    setState(() => _entries.add(entry));
  }

  /// Dismiss a specific notification.
  void dismiss(Notification notification) {
    final _NotificationEntry? entry =
        _entries.where((e) => e.notification == notification).firstOrNull;
    if (entry != null) _dismiss(entry);
  }

  /// Dismiss all notifications.
  void dismissAll() {
    setState(() {
      for (final _NotificationEntry entry in _entries) {
        entry.timer?.cancel();
      }
      _entries.clear();
    });
  }

  void _dismiss(_NotificationEntry entry) {
    entry.timer?.cancel();
    setState(() => _entries.remove(entry));
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          widget.child,
          if (_entries.isNotEmpty)
            Positioned(
              top: _positionTop,
              right: _positionRight,
              bottom: _positionBottom,
              left: _positionLeft,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: _crossAxisAlignment,
                    children: <Widget>[
                      for (final _NotificationEntry entry in _entries)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _NotificationCard(
                            notification: entry.notification,
                            onDismiss: () => _dismiss(entry),
                            onTap: () {
                              widget.onNotificationTap
                                  ?.call(entry.notification);
                              _dismiss(entry);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );

  double? get _positionTop =>
      widget.position == NotificationPosition.bottomLeft ||
              widget.position == NotificationPosition.bottomRight
          ? null
          : MediaQuery.of(context).padding.top + 16;

  double? get _positionRight =>
      widget.position == NotificationPosition.topRight ||
              widget.position == NotificationPosition.bottomRight
          ? 16
          : null;

  double? get _positionBottom =>
      widget.position == NotificationPosition.topLeft ||
              widget.position == NotificationPosition.topRight
          ? null
          : MediaQuery.of(context).padding.bottom + 16;

  double? get _positionLeft =>
      widget.position == NotificationPosition.topLeft ||
              widget.position == NotificationPosition.bottomLeft
          ? 16
          : null;

  CrossAxisAlignment get _crossAxisAlignment =>
      widget.position == NotificationPosition.topLeft ||
              widget.position == NotificationPosition.bottomLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end;
}

/// Notification data model.
class Notification {
  const Notification({
    required this.title,
    this.body,
    this.type = NotificationType.info,
    this.icon,
    this.actions = const <NotificationAction>[],
    this.id,
  });

  final String title;
  final String? body;
  final NotificationType type;
  final IconData? icon;
  final List<NotificationAction> actions;
  final String? id;

  IconData get _defaultIcon {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
    }
  }
}

/// Notification type.
enum NotificationType { info, success, warning, error }

/// Notification position.
enum NotificationPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Notification action button.
class NotificationAction {
  const NotificationAction({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;
}

class _NotificationEntry {
  _NotificationEntry({required this.notification});
  final Notification notification;
  Timer? timer;
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onDismiss,
    this.onTap,
  });

  final Notification notification;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = _colorForType(notification.type);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        elevation: 6,
        child: Container(
          width: 340,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.icon ?? notification._defaultIcon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (notification.body != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        notification.body!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: onDismiss,
                borderRadius: BorderRadius.circular(16),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return AppColors.info;
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.error:
        return AppColors.error;
    }
  }
}

/// Quick-show extension for [BuildContext].
extension NotificationX on BuildContext {
  /// Show a notification via the nearest [NotificationCenter].
  NotificationCenterState get notifications => NotificationCenter.of(this);

  /// Quick info notification.
  void showInfo(String title, {String? body}) {
    notifications.show(Notification(
      title: title,
      body: body,
    ));
  }

  /// Quick success notification.
  void showSuccess(String title, {String? body}) {
    notifications.show(Notification(
      title: title,
      body: body,
      type: NotificationType.success,
    ));
  }

  /// Quick warning notification.
  void showWarning(String title, {String? body}) {
    notifications.show(Notification(
      title: title,
      body: body,
      type: NotificationType.warning,
    ));
  }

  /// Quick error notification.
  void showError(String title, {String? body}) {
    notifications.show(Notification(
      title: title,
      body: body,
      type: NotificationType.error,
    ));
  }
}
