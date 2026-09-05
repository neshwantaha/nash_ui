import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Device and platform helpers that work on every target (including web).
abstract final class DeviceUtils {
  DeviceUtils._();

  /// Whether the app runs inside a web browser.
  static bool get isWeb => kIsWeb;

  /// The current target platform (best-effort on web).
  static TargetPlatform get platform => defaultTargetPlatform;

  /// Whether the current platform is Android.
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Whether the current platform is iOS.
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Whether the current platform is Windows.
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// Whether the current platform is macOS.
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// Whether the current platform is Linux.
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// Whether the current platform is a phone/tablet.
  static bool get isMobile => isAndroid || isIOS;

  /// Whether the current platform is a desktop OS.
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  /// Screen size in logical pixels.
  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  /// Device pixel ratio.
  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.devicePixelRatioOf(context);

  /// Safe-area top padding.
  static double safeTop(BuildContext context) =>
      MediaQuery.paddingOf(context).top;

  /// Safe-area bottom padding.
  static double safeBottom(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  /// Whether the screen is taller than it is wide.
  static bool isPortrait(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.portrait;

  /// Whether the screen is wider than it is tall.
  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// Approximate device class based on screen width:
  /// `'phone'`, `'tablet'` or `'desktop'`.
  static String deviceClass(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    if (w < 600) return 'phone';
    if (w < 1024) return 'tablet';
    return 'desktop';
  }
}
