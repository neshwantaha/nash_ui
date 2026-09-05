import 'dart:ui';

/// Color manipulation and accessibility helpers.
abstract final class ColorUtils {
  ColorUtils._();

  /// Converts [color] to a hex string like `#FF4F46E5`.
  static String toHex(Color color, {bool withAlpha = true}) {
    final int a = (color.a * 255).round();
    final int r = (color.r * 255).round();
    final int g = (color.g * 255).round();
    final int b = (color.b * 255).round();
    String two(int value) =>
        value.toRadixString(16).padLeft(2, '0').toUpperCase();
    return withAlpha
        ? '#${two(a)}${two(r)}${two(g)}${two(b)}'
        : '#${two(r)}${two(g)}${two(b)}';
  }

  /// Parses a hex string (`#RGB`, `#RRGGBB`, `#AARRGGBB`, with or without `#`)
  /// into a [Color]. Returns `null` when the input is not valid.
  static Color? fromHex(String hex) {
    String value = hex.trim();
    if (value.startsWith('#')) value = value.substring(1);
    if (value.length == 3) {
      value = value.split('').map((String c) => '$c$c').join();
    }
    final int? parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    switch (value.length) {
      case 6:
        return Color(0xFF000000 | parsed);
      case 8:
        return Color(parsed);
      default:
        return null;
    }
  }

  /// Linearly interpolates between [a] and [b] at [t] (clamped to 0–1).
  static Color blend(Color a, Color b, double t) =>
      Color.lerp(a, b, t.clamp(0.0, 1.0))!;

  /// Mixes [color] towards white by [amount] (0–1).
  static Color lighten(Color color, double amount) =>
      blend(color, const Color(0xFFFFFFFF), amount);

  /// Mixes [color] towards black by [amount] (0–1).
  static Color darken(Color color, double amount) =>
      blend(color, const Color(0xFF000000), amount);

  /// Whether [color] is perceived as light.
  static bool isLight(Color color) => color.computeLuminance() > 0.5;

  /// Whether [color] is perceived as dark.
  static bool isDark(Color color) => !isLight(color);

  /// The relative luminance of [color] (0–1, WCAG definition).
  static double luminance(Color color) => color.computeLuminance();

  /// The WCAG contrast ratio between [a] and [b] (1–21).
  static double contrastRatio(Color a, Color b) {
    double channel(double value) =>
        value <= 0.03928 ? value / 12.92 : pow2((value + 0.055) / 1.055);
    double lum(Color c) {
      final double r = channel(c.r);
      final double g = channel(c.g);
      final double b = channel(c.b);
      return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    final double l1 = lum(a);
    final double l2 = lum(b);
    final double lighter = l1 > l2 ? l1 : l2;
    final double darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Whether [fg] on [bg] meets the WCAG AA contrast for normal text (4.5:1).
  static bool isReadable(Color fg, Color bg, {bool largeText = false}) =>
      contrastRatio(fg, bg) >= (largeText ? 3.0 : 4.5);

  /// Returns black or white depending on which contrasts best with [background].
  static Color contrastFor(Color background) =>
      contrastRatio(background, const Color(0xFF000000)) >
              contrastRatio(background, const Color(0xFFFFFFFF))
          ? const Color(0xFF000000)
          : const Color(0xFFFFFFFF);

  static double pow2(double value) => value * value;
}
