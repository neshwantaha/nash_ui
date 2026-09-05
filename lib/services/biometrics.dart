import 'dart:async';

/// Supported biometric authentication types.
enum BiometricType {
  fingerprint,
  face,
  iris,
  none,
}

/// A unified biometric authentication service (Face ID / Touch ID / Fingerprint).
abstract final class AppBiometrics {
  AppBiometrics._();

  /// Pluggable biometric authenticator implementation.
  static Future<bool> Function(
      {required String localizedReason,
      bool useErrorDialogs})? customAuthenticator;

  /// Pluggable biometric availability checker.
  static Future<bool> Function()? customAvailabilityChecker;

  /// Pluggable available types checker.
  static Future<List<BiometricType>> Function()? customTypesChecker;

  /// Whether biometric authentication hardware is available and enrolled.
  static Future<bool> get isAvailable async {
    if (customAvailabilityChecker != null) {
      return customAvailabilityChecker!();
    }
    return true;
  }

  /// Returns the list of enrolled biometric types on this device.
  static Future<List<BiometricType>> get availableBiometrics async {
    if (customTypesChecker != null) {
      return customTypesChecker!();
    }
    return <BiometricType>[BiometricType.fingerprint, BiometricType.face];
  }

  /// Prompts the user for biometric authentication with [localizedReason].
  static Future<bool> authenticate({
    required String localizedReason,
    bool useErrorDialogs = true,
  }) async {
    if (customAuthenticator != null) {
      return customAuthenticator!(
        localizedReason: localizedReason,
        useErrorDialogs: useErrorDialogs,
      );
    }
    // Default fallback: mock success
    return true;
  }
}
