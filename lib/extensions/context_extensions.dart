import 'package:flutter/material.dart';

import '../colors/brand_colors.dart';
import '../radius/app_radius.dart';

/// Convenience extensions on [BuildContext].
extension ContextX on BuildContext {
  /// Shortcut for `Theme.of(this)`.
  ThemeData get theme => Theme.of(this);

  /// Shortcut for `Theme.of(this).textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Shortcut for `Theme.of(this).colorScheme`.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Primary color shortcut.
  Color get primaryColor => colorScheme.primary;

  /// Surface color shortcut.
  Color get surfaceColor => colorScheme.surface;

  /// Whether the current theme is dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Whether the current theme is light.
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  /// Current `MediaQueryData`.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen size.
  Size get size => MediaQuery.sizeOf(this);

  /// Screen width.
  double get width => MediaQuery.sizeOf(this).width;

  /// Screen height.
  double get height => MediaQuery.sizeOf(this).height;

  /// Safe area padding.
  EdgeInsets get viewPadding => MediaQuery.paddingOf(this);

  /// Current `Navigator`.
  NavigatorState get navigator => Navigator.of(this);

  /// Current `ScaffoldMessenger` (asserts it exists).
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);

  /// Current overlay, if available.
  OverlayState? get overlay => Overlay.maybeOf(this);

  /// Current focus scope.
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Whether the widget mounted at this context is still active.
  bool get isMounted => mounted;

  /// Shows a standard [SnackBar] on the closest [ScaffoldMessenger].
  void showSnack(String message, {Duration? duration}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.info_outline_rounded,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
  }

  /// Shows a styled success [SnackBar].
  void showSuccessSnack(String message, {Duration? duration}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
  }

  /// Shows a styled error [SnackBar].
  void showErrorSnack(String message, {Duration? duration}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.error_outline_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
  }

  /// Shows a styled warning [SnackBar].
  void showWarningSnack(String message, {Duration? duration}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: AppColors.warning,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
  }

  /// Shows a styled informational [SnackBar].
  void showInfoSnack(String message, {Duration? duration}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.info_outline_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: AppColors.info,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
  }

  /// Pops all routes until the root route is reached.
  void popToRoot() =>
      navigator.popUntil((Route<dynamic> route) => route.isFirst);

  /// Retrieves the typed route arguments or `null`.
  T? arguments<T>() {
    final Object? args = ModalRoute.of(this)?.settings.arguments;
    return args is T ? args : null;
  }
}
