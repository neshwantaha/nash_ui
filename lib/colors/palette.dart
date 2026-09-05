import 'package:flutter/material.dart';

/// A curated set of Material palettes exposed as [MaterialColor] tokens.
///
/// Useful when building custom themes with `ColorScheme.fromSeed` or when a
/// component needs a classic Material palette value.
abstract final class AppPalette {
  AppPalette._();

  /// Indigo primary palette.
  static const MaterialColor indigo = MaterialColor(
    0xFF4F46E5,
    <int, Color>{
      50: Color(0xFFEEF2FF),
      100: Color(0xFFE0E7FF),
      200: Color(0xFFC7D2FE),
      300: Color(0xFFA5B4FC),
      400: Color(0xFF818CF8),
      500: Color(0xFF4F46E5),
      600: Color(0xFF4F46E5),
      700: Color(0xFF4338CA),
      800: Color(0xFF3730A3),
      900: Color(0xFF312E81),
    },
  );

  /// Sky / blue secondary palette.
  static const MaterialColor sky = MaterialColor(
    0xFF0284C7,
    <int, Color>{
      50: Color(0xFFF0F9FF),
      100: Color(0xFFE0F2FE),
      200: Color(0xFFBAE6FD),
      300: Color(0xFF7DD3FC),
      400: Color(0xFF38BDF8),
      500: Color(0xFF0EA5E9),
      600: Color(0xFF0284C7),
      700: Color(0xFF0369A1),
      800: Color(0xFF075985),
      900: Color(0xFF0C4A6E),
    },
  );

  /// Emerald success palette.
  static const MaterialColor emerald = MaterialColor(
    0xFF10B981,
    <int, Color>{
      50: Color(0xFFECFDF5),
      100: Color(0xFFD1FAE5),
      200: Color(0xFFA7F3D0),
      300: Color(0xFF6EE7B7),
      400: Color(0xFF34D399),
      500: Color(0xFF10B981),
      600: Color(0xFF059669),
      700: Color(0xFF047857),
      800: Color(0xFF065F46),
      900: Color(0xFF064E3B),
    },
  );

  /// Red error palette.
  static const MaterialColor red = MaterialColor(
    0xFFEF4444,
    <int, Color>{
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      200: Color(0xFFFECACA),
      300: Color(0xFFFCA5A5),
      400: Color(0xFFF87171),
      500: Color(0xFFEF4444),
      600: Color(0xFFDC2626),
      700: Color(0xFFB91C1C),
      800: Color(0xFF991B1B),
      900: Color(0xFF7F1D1D),
    },
  );

  /// Amber warning palette.
  static const MaterialColor amber = MaterialColor(
    0xFFF59E0B,
    <int, Color>{
      50: Color(0xFFFFFBEB),
      100: Color(0xFFFEF3C7),
      200: Color(0xFFFDE68A),
      300: Color(0xFFFCD34D),
      400: Color(0xFFFBBF24),
      500: Color(0xFFF59E0B),
      600: Color(0xFFD97706),
      700: Color(0xFFB45309),
      800: Color(0xFF92400E),
      900: Color(0xFF78350F),
    },
  );

  /// Blue info palette.
  static const MaterialColor blue = MaterialColor(
    0xFF3B82F6,
    <int, Color>{
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA),
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB),
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    },
  );

  /// Violet accent palette.
  static const MaterialColor violet = MaterialColor(
    0xFF8B5CF6,
    <int, Color>{
      50: Color(0xFFF5F3FF),
      100: Color(0xFFEDE9FE),
      200: Color(0xFFDDD6FE),
      300: Color(0xFFC4B5FD),
      400: Color(0xFFA78BFA),
      500: Color(0xFF8B5CF6),
      600: Color(0xFF7C3AED),
      700: Color(0xFF6D28D9),
      800: Color(0xFF5B21B6),
      900: Color(0xFF4C1D95),
    },
  );

  /// Rose accent palette.
  static const MaterialColor rose = MaterialColor(
    0xFFF43F5E,
    <int, Color>{
      50: Color(0xFFFFF1F2),
      100: Color(0xFFFFE4E6),
      200: Color(0xFFFECDD3),
      300: Color(0xFFFDA4AF),
      400: Color(0xFFFB7185),
      500: Color(0xFFF43F5E),
      600: Color(0xFFE11D48),
      700: Color(0xFFBE123C),
      800: Color(0xFF9F1239),
      900: Color(0xFF881337),
    },
  );

  /// Generates a [MaterialColor] palette from a single [primary] color.
  static MaterialColor fromSeed(Color primary) {
    final int primaryValue = primary.toARGB32();
    final double r = (primaryValue >> 16 & 0xFF) / 255.0;
    final double g = (primaryValue >> 8 & 0xFF) / 255.0;
    final double b = (primaryValue & 0xFF) / 255.0;

    final Map<int, Color> swatch = <int, Color>{
      50: Color.fromRGBO(
          (r * 255 + (255 - r * 255) * 0.95).round(),
          (g * 255 + (255 - g * 255) * 0.95).round(),
          (b * 255 + (255 - b * 255) * 0.95).round(),
          1),
      100: Color.fromRGBO(
          (r * 255 + (255 - r * 255) * 0.9).round(),
          (g * 255 + (255 - g * 255) * 0.9).round(),
          (b * 255 + (255 - b * 255) * 0.9).round(),
          1),
      200: Color.fromRGBO(
          (r * 255 + (255 - r * 255) * 0.7).round(),
          (g * 255 + (255 - g * 255) * 0.7).round(),
          (b * 255 + (255 - b * 255) * 0.7).round(),
          1),
      300: Color.fromRGBO(
          (r * 255 + (255 - r * 255) * 0.5).round(),
          (g * 255 + (255 - g * 255) * 0.5).round(),
          (b * 255 + (255 - b * 255) * 0.5).round(),
          1),
      400: Color.fromRGBO(
          (r * 255 + (255 - r * 255) * 0.25).round(),
          (g * 255 + (255 - g * 255) * 0.25).round(),
          (b * 255 + (255 - b * 255) * 0.25).round(),
          1),
      500: primary,
      600: Color.fromRGBO((r * 255 * 0.9).round(), (g * 255 * 0.9).round(),
          (b * 255 * 0.9).round(), 1),
      700: Color.fromRGBO((r * 255 * 0.8).round(), (g * 255 * 0.8).round(),
          (b * 255 * 0.8).round(), 1),
      800: Color.fromRGBO((r * 255 * 0.7).round(), (g * 255 * 0.7).round(),
          (b * 255 * 0.7).round(), 1),
      900: Color.fromRGBO((r * 255 * 0.55).round(), (g * 255 * 0.55).round(),
          (b * 255 * 0.55).round(), 1),
    };

    return MaterialColor(primaryValue, swatch);
  }
}
