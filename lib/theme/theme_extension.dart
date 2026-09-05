import 'package:flutter/material.dart' hide ThemeExtension;
import 'package:flutter/material.dart' as fl show ThemeExtension;

import '../colors/brand_colors.dart';
import '../gradients/brand_gradients.dart';

/// Theme extension carrying design-system specific tokens.
///
/// Register on a [ThemeData] via `extensions: [AppThemeExtension(...)]`. Use
/// `Theme.of(context).extension<AppThemeExtension>()` to read it back.
class AppThemeExtension extends fl.ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    this.primary,
    this.secondary,
    this.success,
    this.error,
    this.warning,
    this.info,
    this.brandGradient,
    this.surface,
    this.appBarStyle = AppBarStyle.solid,
  });

  /// Brand primary color override.
  final Color? primary;

  /// Brand secondary color override.
  final Color? secondary;

  /// Success color.
  final Color? success;

  /// Error color.
  final Color? error;

  /// Warning color.
  final Color? warning;

  /// Info color.
  final Color? info;

  /// Brand gradient override.
  final Gradient? brandGradient;

  /// Base surface color.
  final Color? surface;

  /// AppBar visual style.
  final AppBarStyle appBarStyle;

  /// Resolved brand primary.
  Color get resolvedPrimary => primary ?? AppColors.primary;

  /// Resolved brand secondary.
  Color get resolvedSecondary => secondary ?? AppColors.secondary;

  /// Resolved success.
  Color get resolvedSuccess => success ?? AppColors.success;

  /// Resolved error.
  Color get resolvedError => error ?? AppColors.error;

  /// Resolved warning.
  Color get resolvedWarning => warning ?? AppColors.warning;

  /// Resolved info.
  Color get resolvedInfo => info ?? AppColors.info;

  /// Resolved gradient.
  Gradient get resolvedGradient => brandGradient ?? AppGradients.brand;

  /// Reads the registered extension, falling back to theme defaults.
  static AppThemeExtension of(BuildContext context) {
    final AppThemeExtension? ext =
        Theme.of(context).extension<AppThemeExtension>();
    return ext ?? defaults(Theme.of(context).brightness);
  }

  /// AppBar colors resolved from the current [appBarStyle].
  AppBarColors get appBar {
    switch (appBarStyle) {
      case AppBarStyle.solid:
        final Color bg = surface ?? AppColors.surface;
        return AppBarColors(
            background: bg, foreground: AppColors.contrastFor(bg));
      case AppBarStyle.glass:
        final Color bg = surface ?? AppColors.surface;
        return AppBarColors(
          background: bg.withValues(alpha: 0.85),
          foreground: AppColors.contrastFor(bg),
        );
      case AppBarStyle.gradient:
        return AppBarColors(
            background: resolvedPrimary, foreground: Colors.white);
    }
  }

  /// Builds default tokens for a [brightness].
  static AppThemeExtension defaults(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;
    return AppThemeExtension(
      primary: dark ? AppColors.primaryLight : AppColors.primary,
      secondary: dark ? const Color(0xFF38BDF8) : AppColors.secondary,
      success: dark ? const Color(0xFF34D399) : AppColors.success,
      error: dark ? const Color(0xFFF87171) : AppColors.error,
      warning: dark ? const Color(0xFFFBBF24) : AppColors.warning,
      info: dark ? const Color(0xFF60A5FA) : AppColors.info,
      surface: dark ? AppColors.surfaceDark : AppColors.surface,
    );
  }

  @override
  AppThemeExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Gradient? brandGradient,
    Color? surface,
    AppBarStyle? appBarStyle,
  }) =>
      AppThemeExtension(
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        success: success ?? this.success,
        error: error ?? this.error,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        brandGradient: brandGradient ?? this.brandGradient,
        surface: surface ?? this.surface,
        appBarStyle: appBarStyle ?? this.appBarStyle,
      );

  @override
  AppThemeExtension lerp(
    covariant AppThemeExtension? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      primary: _lerp(primary, other.primary, t),
      secondary: _lerp(secondary, other.secondary, t),
      success: _lerp(success, other.success, t),
      error: _lerp(error, other.error, t),
      warning: _lerp(warning, other.warning, t),
      info: _lerp(info, other.info, t),
      brandGradient: other.brandGradient ?? brandGradient,
      surface: _lerp(surface, other.surface, t),
      appBarStyle: t < 0.5 ? appBarStyle : other.appBarStyle,
    );
  }
}

Color? _lerp(Color? a, Color? b, double t) =>
    a == null || b == null ? b ?? a : Color.lerp(a, b, t);

/// Resolved AppBar colors.
class AppBarColors {
  const AppBarColors({
    required this.background,
    required this.foreground,
  });

  /// AppBar background color.
  final Color background;

  /// AppBar foreground (icon/text) color.
  final Color foreground;
}

/// Visual styles for the app bar.
enum AppBarStyle {
  /// Solid opaque surface.
  solid,

  /// Translucent surface with blur.
  glass,

  /// Brand gradient surface.
  gradient,
}
