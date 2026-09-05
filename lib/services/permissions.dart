import 'dart:async';

/// Common application permission types.
enum AppPermission {
  camera,
  microphone,
  photos,
  storage,
  location,
  locationAlways,
  notifications,
  bluetooth,
  contacts,
  calendar,
}

/// Permission status enumeration.
enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  provisional,
}

/// A standardized service for requesting and checking device permissions.
abstract final class AppPermissions {
  AppPermissions._();

  /// Pluggable permission handler callback.
  static Future<AppPermissionStatus> Function(AppPermission permission)?
      customHandler;

  /// Requests the given [permission].
  static Future<AppPermissionStatus> request(AppPermission permission) async {
    if (customHandler != null) {
      return customHandler!(permission);
    }
    // Default fallback: assume granted in development/desktop
    return AppPermissionStatus.granted;
  }

  /// Checks if [permission] is currently granted.
  static Future<bool> isGranted(AppPermission permission) async {
    final AppPermissionStatus status = await request(permission);
    return status == AppPermissionStatus.granted ||
        status == AppPermissionStatus.limited;
  }

  /// Requests multiple permissions at once.
  static Future<Map<AppPermission, AppPermissionStatus>> requestAll(
    List<AppPermission> permissions,
  ) async {
    final Map<AppPermission, AppPermissionStatus> results =
        <AppPermission, AppPermissionStatus>{};
    for (final AppPermission p in permissions) {
      results[p] = await request(p);
    }
    return results;
  }
}
