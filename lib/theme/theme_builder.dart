import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/font_config.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ThemeBuilder — Generate a complete theme from a single seed color
// ─────────────────────────────────────────────────────────────────────────────

/// Generates a complete Material 3 [ThemeData] from a single seed color,
/// with optional overrides for font, border radius, and density.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeBuilder.fromSeed(
///     seedColor: Color(0xFF6366F1),
///     fontFamily: 'Poppins',
///     borderRadius: 12,
///   ),
///   darkTheme: ThemeBuilder.fromSeed(
///     seedColor: Color(0xFF6366F1),
///     isDark: true,
///   ),
/// )
/// ```
abstract final class ThemeBuilder {
  ThemeBuilder._();

  /// Generates a [ThemeData] from a seed color.
  ///
  /// - [seedColor]: The primary seed color for the Material 3 color scheme.
  /// - [isDark]: Whether to generate a dark or light theme.
  /// - [fontConfig]: Direction-aware font configuration (preferred). Supports
  ///   separate LTR and RTL fonts from Google Fonts or local assets.
  /// - [fontFamily]: Legacy — a Google Font family name (e.g., 'Poppins').
  ///   Use [fontConfig] instead for RTL support.
  /// - [direction]: Text direction to use when resolving [fontConfig].
  /// - [borderRadius]: Global border radius for buttons, cards, and inputs.
  /// - [visualDensity]: UI density setting.
  static ThemeData fromSeed({
    required Color seedColor,
    bool isDark = false,
    FontConfig? fontConfig,
    String fontFamily = 'Inter',
    TextDirection direction = TextDirection.ltr,
    double borderRadius = 12.0,
    VisualDensity? visualDensity,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    final TextTheme textTheme;
    if (fontConfig != null) {
      textTheme = fontConfig.resolveTextTheme(direction, ThemeData().textTheme);
    } else {
      textTheme = _buildTextTheme(fontFamily, colorScheme);
    }
    final radius = Radius.circular(borderRadius);
    final shapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(radius),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      textTheme: textTheme,
      visualDensity: visualDensity ?? VisualDensity.standard,

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: shapeBorder,
        color: colorScheme.surfaceContainerLow,
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: shapeBorder,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: shapeBorder,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: shapeBorder,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: shapeBorder,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius + 4)),
        ),
      ),

      // Bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius + 8),
          ),
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(String fontFamily, ColorScheme scheme) {
    try {
      return GoogleFonts.getTextTheme(fontFamily);
    } catch (_) {
      return ThemeData(colorScheme: scheme).textTheme;
    }
  }
}
