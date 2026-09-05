import 'package:flutter/widgets.dart';

/// Responsive typography that scales text based on screen size.
///
/// ```dart
/// final style = ResponsiveTypography.bodyLarge(context);
/// ```
abstract final class ResponsiveTypography {
  ResponsiveTypography._();

  /// Returns a font size scaled to the current screen width.
  ///
  /// [base] is the font size at the design reference width (default 390).
  /// [min] and [max] clamp the result.
  static double scaledFontSize(
    BuildContext context, {
    required double base,
    double min = 10,
    double max = 72,
    double designWidth = 390,
  }) {
    final double width = MediaQuery.sizeOf(context).width;
    final double factor = width / designWidth;
    return (base * factor).clamp(min, max);
  }

  /// Display large — scaled.
  static TextStyle displayLarge(BuildContext context, {Color? color}) =>
      _scaled(context, 57, FontWeight.w700, color: color);

  /// Display medium — scaled.
  static TextStyle displayMedium(BuildContext context, {Color? color}) =>
      _scaled(context, 45, FontWeight.w700, color: color);

  /// Display small — scaled.
  static TextStyle displaySmall(BuildContext context, {Color? color}) =>
      _scaled(context, 36, FontWeight.w700, color: color);

  /// Headline large — scaled.
  static TextStyle headlineLarge(BuildContext context, {Color? color}) =>
      _scaled(context, 32, FontWeight.w600, color: color);

  /// Headline medium — scaled.
  static TextStyle headlineMedium(BuildContext context, {Color? color}) =>
      _scaled(context, 28, FontWeight.w600, color: color);

  /// Headline small — scaled.
  static TextStyle headlineSmall(BuildContext context, {Color? color}) =>
      _scaled(context, 24, FontWeight.w600, color: color);

  /// Title large — scaled.
  static TextStyle titleLarge(BuildContext context, {Color? color}) =>
      _scaled(context, 22, FontWeight.w600, color: color);

  /// Title medium — scaled.
  static TextStyle titleMedium(BuildContext context, {Color? color}) =>
      _scaled(context, 16, FontWeight.w500, color: color);

  /// Title small — scaled.
  static TextStyle titleSmall(BuildContext context, {Color? color}) =>
      _scaled(context, 14, FontWeight.w500, color: color);

  /// Body large — scaled.
  static TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _scaled(context, 16, FontWeight.w400, color: color);

  /// Body medium — scaled.
  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      _scaled(context, 14, FontWeight.w400, color: color);

  /// Body small — scaled.
  static TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _scaled(context, 12, FontWeight.w400, color: color);

  /// Label large — scaled.
  static TextStyle labelLarge(BuildContext context, {Color? color}) =>
      _scaled(context, 14, FontWeight.w500, color: color);

  /// Label medium — scaled.
  static TextStyle labelMedium(BuildContext context, {Color? color}) =>
      _scaled(context, 12, FontWeight.w500, color: color);

  /// Label small — scaled.
  static TextStyle labelSmall(BuildContext context, {Color? color}) =>
      _scaled(context, 11, FontWeight.w500, color: color);

  static TextStyle _scaled(
    BuildContext context,
    double baseFontSize,
    FontWeight weight, {
    Color? color,
    double designWidth = 390,
    double min = 10,
    double max = 72,
  }) {
    final double fontSize = scaledFontSize(
      context,
      base: baseFontSize,
      min: min,
      max: max,
      designWidth: designWidth,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
    );
  }
}
