import 'package:flutter/material.dart';

import '../colors/brand_colors.dart';

/// Color manipulation and conversion extensions.
extension ColorX on Color {
  /// Returns this color with [opacity] (0..1) applied.
  Color withOpacity(double opacity) => withValues(alpha: opacity.clamp(0, 1));

  /// Lightens the color by [amount] (0..1).
  Color lighten([double amount = 0.1]) =>
      Color.lerp(this, Colors.white, amount.clamp(0, 1))!;

  /// Darkens the color by [amount] (0..1).
  Color darken([double amount = 0.1]) =>
      Color.lerp(this, Colors.black, amount.clamp(0, 1))!;

  /// Blends this color with [other] by [amount] (0..1).
  Color mixWith(Color other, [double amount = 0.5]) =>
      Color.lerp(this, other, amount.clamp(0, 1))!;

  /// Whether the color is perceptually light.
  bool get isLight => computeLuminance() > 0.5;

  /// Whether the color is perceptually dark.
  bool get isDark => !isLight;

  /// The most readable monochrome text color for this background.
  Color get contrastText => AppColors.contrastFor(this);

  /// Converts to an 8-digit hex string `#AARRGGBB`.
  String toHex({bool withAlpha = true}) {
    final int argb = toARGB32();
    final int alpha = (argb >> 24) & 0xFF;
    final int red = (argb >> 16) & 0xFF;
    final int green = (argb >> 8) & 0xFF;
    final int blue = argb & 0xFF;
    if (!withAlpha) {
      return '#${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}';
    }
    return '#${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// Returns the complementary color (180° hue rotation).
  Color get complementary {
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  /// Rotates the hue by [degrees].
  Color rotateHue(double degrees) {
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withHue((hsl.hue + degrees) % 360).toColor();
  }

  /// Applies an alpha fraction relative to the current alpha.
  Color withAlphaFraction(double fraction) =>
      withValues(alpha: (a * fraction).clamp(0, 1));

  /// Creates a [MaterialColor] swatch from this color.
  MaterialColor toMaterialColor() {
    final List<double> strengths = <double>[
      0.05,
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.6,
      0.7,
      0.8,
      0.9
    ];
    final Map<int, Color> swatch = <int, Color>{};
    for (int i = 0; i < strengths.length; i++) {
      final double strength = strengths[i];
      final double ds = 0.5 - strength;
      swatch[(i + 1) * 100] = mixWith(
        ds >= 0 ? Colors.white : Colors.black,
        ds.abs() * 2,
      );
    }
    return MaterialColor(toARGB32(), swatch);
  }
}

/// Extensions for [ColorScheme] convenience.
extension AppColorschemeX on ColorScheme {
  /// Whether this scheme is dark.
  bool get isDark => brightness == Brightness.dark;
}

/// Parses hex strings into [Color] values.
extension AppColorstringX on String {
  /// Parses `#RGB`, `#RRGGBB`, `#AARRGGBB` or `#RRGGBBAA` strings.
  Color? toColor() {
    String hex = replaceFirst('#', '').trim();
    if (hex.length == 3) {
      hex = hex.split('').map((String c) => '$c$c').join();
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) return null;
    final int? parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return null;
    final int alpha = (parsed >> 24) & 0xFF;
    final int red = (parsed >> 16) & 0xFF;
    final int green = (parsed >> 8) & 0xFF;
    final int blue = parsed & 0xFF;
    return Color.fromARGB(alpha, red, green, blue);
  }

  /// A deterministic color derived from this string (for avatars, tags).
  Color colorFromString() {
    int hash = 0;
    for (final int code in codeUnits) {
      hash = (hash * 31 + code) & 0xFFFFFFFF;
    }
    const List<Color> palette = <Color>[
      Color(0xFF4F46E5),
      Color(0xFF0284C7),
      Color(0xFF16A34A),
      Color(0xFFD97706),
      Color(0xFFDC2626),
      Color(0xFF8B5CF6),
      Color(0xFFDB2777),
      Color(0xFF0891B2),
    ];
    return palette[hash % palette.length];
  }
}
