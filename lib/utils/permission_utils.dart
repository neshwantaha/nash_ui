/// Permission kinds the design system is aware of.
enum PermissionKind {
  /// Camera.
  camera,

  /// Microphone.
  microphone,

  /// Device location.
  location,

  /// Local notifications.
  notifications,

  /// Storage / photos access.
  storage,

  /// Contacts.
  contacts,

  /// Calendar.
  calendar,
}

/// The outcome of a permission request.
enum PermissionStatus {
  /// Permission is granted.
  granted,

  /// Permission is denied but can be requested again.
  denied,

  /// Permission is permanently denied; the user must enable it in settings.
  permanentlyDenied,

  /// Permission is restricted (e.g. parental controls / MDM).
  restricted,

  /// Requesting requires platform setup and is not yet wired up.
  notImplemented,
}

/// A pluggable permission handler.
///
/// Implement this with `permission_handler` or another plugin and assign it
/// to [PermissionUtils.handler] once at app startup:
///
/// ```dart
/// PermissionUtils.handler = MyPermissionHandler();
/// ```
abstract interface class PermissionHandler {
  /// Requests [kind] and returns its current status.
  Future<PermissionStatus> request(PermissionKind kind);

  /// Returns the current status of [kind] without requesting.
  Future<PermissionStatus> status(PermissionKind kind);

  /// Opens the system settings for the app.
  Future<bool> openSettings();
}

/// Permission helpers delegating to an injected [PermissionHandler].
abstract final class PermissionUtils {
  PermissionUtils._();

  /// The active handler. Defaults to a no-op that reports
  /// [PermissionStatus.notImplemented].
  static PermissionHandler handler = _NoopPermissionHandler();

  /// Requests [kind] via [handler].
  static Future<PermissionStatus> request(PermissionKind kind) =>
      handler.request(kind);

  /// Returns the current status of [kind] without requesting.
  static Future<PermissionStatus> status(PermissionKind kind) =>
      handler.status(kind);

  /// Opens the system settings for the app.
  static Future<bool> openSettings() => handler.openSettings();
}

class _NoopPermissionHandler implements PermissionHandler {
  @override
  Future<PermissionStatus> request(PermissionKind kind) async =>
      PermissionStatus.notImplemented;

  @override
  Future<PermissionStatus> status(PermissionKind kind) async =>
      PermissionStatus.notImplemented;

  @override
  Future<bool> openSettings() async => false;
}
