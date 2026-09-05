import 'package:flutter/widgets.dart';

import '../colors/brand_colors.dart';

/// Gradient tokens for the design system.
///
/// Reusable brand gradients used by hero headers, buttons, cards and charts.
abstract final class AppGradients {
  AppGradients._();

  /// Primary → secondary diagonal gradient.
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AppColors.primary, AppColors.secondary],
  );

  /// Primary → primaryLight diagonal gradient.
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AppColors.primary, AppColors.primaryLight],
  );

  /// Secondary → cyan gradient.
  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AppColors.secondary, Color(0xFF06B6D4)],
  );

  /// Success → emerald gradient.
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF4ADE80), AppColors.success],
  );

  /// Warning → amber gradient.
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFBBF24), AppColors.warning],
  );

  /// Error → rose gradient.
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFF87171), AppColors.error],
  );

  /// Info → blue gradient.
  static const LinearGradient info = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF60A5FA), AppColors.info],
  );

  /// Violet → fuchsia gradient.
  static const LinearGradient violet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF8B5CF6), Color(0xFFD946EF)],
  );

  /// Sunset orange → pink gradient.
  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFF97316), Color(0xFFEC4899)],
  );

  /// Cyberpunk neon gradient (Cyan → Pink).
  static const LinearGradient cyberpunk = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF06B6D4), Color(0xFFEC4899)],
  );

  /// Deep ocean blue → teal gradient.
  static const LinearGradient ocean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF0284C7), Color(0xFF10B981)],
  );

  /// Emerald green → teal gradient.
  static const LinearGradient emerald = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF10B981), Color(0xFF059669)],
  );

  /// Translucent glassmorphism specular gradient.
  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0x33FFFFFF), Color(0x05FFFFFF)],
  );

  /// Neutral slate gradient used for muted surfaces.
  static const LinearGradient neutral = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFCBD5E1), Color(0xFF94A3B8)],
  );

  /// Builds a custom [LinearGradient] from [colors].
  static LinearGradient custom(
    List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(begin: begin, end: end, colors: colors);
}
