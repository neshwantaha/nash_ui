import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'font_config.dart';
import 'font_weight.dart';

/// Complete typographic scale for the design system.
///
/// Follows the Material 3 type ramp. Use [AppTypography.build] to produce a
/// [TextTheme] for a given font family, or use the individual [AppTypography]
/// style builders for one-off custom styles.
abstract final class AppTypography {
  AppTypography._();

  /// Default type scale uses the active `TextTheme` of [context].
  ///
  /// Each method returns a [TextStyle] pre-wired to the theme with sensible
  /// Material defaults (weight, letter-spacing) that you can then `.copyWith`.
  static TextStyle displayLarge({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.displayLarge,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.bold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Display medium (45 / 52).
  static TextStyle displayMedium({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.displayMedium,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.bold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Display small (36 / 44).
  static TextStyle displaySmall({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.displaySmall,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.bold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Headline large (32 / 40).
  static TextStyle headlineLarge({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.headlineLarge,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.bold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Headline medium (28 / 36).
  static TextStyle headlineMedium({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.headlineMedium,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.semibold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Headline small (24 / 32).
  static TextStyle headlineSmall({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.headlineSmall,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.semibold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Title large (22 / 28).
  static TextStyle titleLarge({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.titleLarge,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.semibold,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Title medium (16 / 24).
  static TextStyle titleMedium({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.titleMedium,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.medium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Title small (14 / 20).
  static TextStyle titleSmall({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.titleSmall,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.medium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Body large (16 / 24).
  static TextStyle bodyLarge({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.bodyLarge,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.regular,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Body medium (14 / 20).
  static TextStyle bodyMedium({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.bodyMedium,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.regular,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Body small (12 / 16).
  static TextStyle bodySmall({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.bodySmall,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.regular,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Label large (14 / 20).
  static TextStyle labelLarge({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.labelLarge,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.medium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Label medium (12 / 16).
  static TextStyle labelMedium({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.labelMedium,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.medium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Label small (11 / 16).
  static TextStyle labelSmall({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      _resolve(
        context: context,
        base: Theme.of(context).textTheme.labelSmall,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.medium,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Caption — an alias of [AppTypography.labelSmall] with regular weight.
  static TextStyle caption({
    required BuildContext context,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) =>
      labelSmall(
        context: context,
        fontFamily: fontFamily,
        color: color,
        weight: weight ?? AppFontWeight.regular,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Builds a complete Material 3 [TextTheme] for the given font configuration.
  ///
  /// **Preferred:** Pass a [FontConfig] for full LTR/RTL control:
  /// ```dart
  /// AppTypography.build(
  ///   fontConfig: FontConfig.google(ltr: 'Inter', rtl: 'Cairo'),
  ///   direction: TextDirection.rtl,
  /// )
  /// ```
  ///
  /// **Legacy:** Pass [fontFamily] + [useGoogleFonts] (still supported).
  static TextTheme build({
    // New API
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
    // Legacy API (kept for backwards compatibility)
    String? fontFamily,
    Color? baseColor,
    bool useGoogleFonts = true,
    double? baseFontSize,
  }) {
    const TextTheme base = TextTheme(
      displayLarge: _displayLarge,
      displayMedium: _displayMedium,
      displaySmall: _displaySmall,
      headlineLarge: _headlineLarge,
      headlineMedium: _headlineMedium,
      headlineSmall: _headlineSmall,
      titleLarge: _titleLarge,
      titleMedium: _titleMedium,
      titleSmall: _titleSmall,
      bodyLarge: _bodyLarge,
      bodyMedium: _bodyMedium,
      bodySmall: _bodySmall,
      labelLarge: _labelLarge,
      labelMedium: _labelMedium,
      labelSmall: _labelSmall,
    );

    TextTheme resolved;

    if (fontConfig != null) {
      // New API path — direction-aware
      resolved = fontConfig.resolveTextTheme(direction, base);
    } else if (fontFamily != null) {
      // Legacy API path
      final String? resolvedFamily;
      if (useGoogleFonts) {
        resolvedFamily = GoogleFonts.config.allowRuntimeFetching
            ? GoogleFonts.getFont(fontFamily).fontFamily
            : fontFamily;
      } else {
        resolvedFamily = fontFamily;
      }
      resolved = base.apply(fontFamily: resolvedFamily);
    } else {
      resolved = base;
    }

    if (baseColor != null || baseFontSize != null) {
      resolved = resolved.apply(
        bodyColor: baseColor,
        displayColor: baseColor,
        fontSizeFactor: baseFontSize != null ? baseFontSize / 14.0 : 1.0,
      );
    }

    return resolved;
  }

  static TextStyle _resolve({
    required BuildContext context,
    required TextStyle? base,
    String? fontFamily,
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    final TextStyle resolved = base ?? const TextStyle();
    return resolved.copyWith(
      fontFamily: fontFamily,
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static const TextStyle _displayLarge = TextStyle(
    fontSize: 57,
    height: 1.12,
    letterSpacing: -0.25,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _displayMedium = TextStyle(
    fontSize: 45,
    height: 1.16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _displaySmall = TextStyle(
    fontSize: 36,
    height: 1.22,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _headlineLarge = TextStyle(
    fontSize: 32,
    height: 1.25,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _headlineMedium = TextStyle(
    fontSize: 28,
    height: 1.29,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _headlineSmall = TextStyle(
    fontSize: 24,
    height: 1.33,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _titleLarge = TextStyle(
    fontSize: 22,
    height: 1.27,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _titleMedium = TextStyle(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _titleSmall = TextStyle(
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _bodySmall = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _labelLarge = TextStyle(
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _labelMedium = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _labelSmall = TextStyle(
    fontSize: 11,
    height: 1.45,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );
}
