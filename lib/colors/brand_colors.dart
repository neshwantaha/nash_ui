import 'package:flutter/material.dart';

/// Severity levels shared across feedback, dialogs and cards.
enum AppFeedbackType {
  /// Informational (primary).
  info,

  /// Success.
  success,

  /// Warning.
  warning,

  /// Error / destructive.
  error,
}

/// Core semantic color tokens for the `nash_design_system`.
///
/// These are the canonical brand colors used across every component,
/// template and theme. They are designed to meet WCAG AA contrast ratios
/// against the neutral surfaces defined in [AppColors.neutral].
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand / Primary
  // ---------------------------------------------------------------------------

  /// Brand primary (Indigo).
  static const Color primary = Color(0xFF4F46E5);

  /// Lighter variant of [primary] used for hover / soft states.
  static const Color primaryLight = Color(0xFF818CF8);

  /// Darker variant of [primary] used for pressed / focus states.
  static const Color primaryDark = Color(0xFF3730A3);

  /// Soft primary container used for highlighted surfaces.
  static const Color primaryContainer = Color(0xFFE0E7FF);

  /// Brand secondary (Sky).
  static const Color secondary = Color(0xFF0284C7);

  /// Secondary container.
  static const Color secondaryContainer = Color(0xFFE0F2FE);

  // ---------------------------------------------------------------------------
  // Accent & Vibrant Tokens
  // ---------------------------------------------------------------------------

  /// Electric Violet.
  static const Color violet = Color(0xFF8B5CF6);

  /// Emerald Green.
  static const Color emerald = Color(0xFF10B981);

  /// Bright Rose.
  static const Color rose = Color(0xFFF43F5E);

  /// Warm Amber.
  static const Color amber = Color(0xFFF59E0B);

  /// Neon Cyan.
  static const Color cyan = Color(0xFF06B6D4);

  /// Vivid Pink.
  static const Color pink = Color(0xFFEC4899);

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Success status color.
  static const Color success = Color(0xFF16A34A);

  /// Success soft container.
  static const Color successContainer = Color(0xFFDCFCE7);

  /// Error status color.
  static const Color error = Color(0xFFDC2626);

  /// Error soft container.
  static const Color errorContainer = Color(0xFFFEE2E2);

  /// Warning status color.
  static const Color warning = Color(0xFFD97706);

  /// Warning soft container.
  static const Color warningContainer = Color(0xFFFEF3C7);

  /// Info status color.
  static const Color info = Color(0xFF2563EB);

  /// Info soft container.
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  /// Light surface color.
  static const Color surface = Color(0xFFFFFFFF);

  /// Muted surface used for elevated cards on light backgrounds.
  static const Color surfaceMuted = Color(0xFFF8FAFC);

  /// Light background color.
  static const Color background = Color(0xFFF1F5F9);

  /// Dark surface color.
  static const Color surfaceDark = Color(0xFF0F172A);

  /// True black surface (AMOLED).
  static const Color amoled = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Neutral / Grey scale
  // ---------------------------------------------------------------------------

  /// Neutral scale from near-black to near-white.
  static const Map<int, Color> neutral = <int, Color>{
    50: Color(0xFFF8FAFC),
    100: Color(0xFFF1F5F9),
    200: Color(0xFFE2E8F0),
    300: Color(0xFFCBD5E1),
    400: Color(0xFF94A3B8),
    500: Color(0xFF64748B),
    600: Color(0xFF475569),
    700: Color(0xFF334155),
    800: Color(0xFF1E293B),
    900: Color(0xFF0F172A),
  };

  /// Black.
  static const Color black = Color(0xFF000000);

  /// White.
  static const Color white = Color(0xFFFFFFFF);

  /// True grey scale.
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ---------------------------------------------------------------------------
  // Transparency
  // ---------------------------------------------------------------------------

  /// Black at 12% used for faint dividers.
  static const Color black12 = Color(0x1F000000);

  /// Black at 24% used for disabled states.
  static const Color black24 = Color(0x3D000000);

  /// Black at 38% used for hint text.
  static const Color black38 = Color(0x61000000);

  /// Black at 54% used for secondary text.
  static const Color black54 = Color(0x8A000000);

  /// White at 12% used for faint dividers on dark surfaces.
  static const Color white12 = Color(0x1FFFFFFF);

  /// White at 24% used for disabled states on dark surfaces.
  static const Color white24 = Color(0x3DFFFFFF);

  /// White at 38% used for hint text on dark surfaces.
  static const Color white38 = Color(0x61FFFFFF);

  /// White at 70% used for secondary text on dark surfaces.
  static const Color white70 = Color(0xB3FFFFFF);

  /// Resolves a neutral color by shade, falling back to [neutral]`[500]`.
  static Color neutralOf(int shade) => neutral[shade] ?? neutral[500]!;

  /// Resolves the accent color for a given [AppFeedbackType].
  static Color forFeedback(AppFeedbackType type) {
    switch (type) {
      case AppFeedbackType.info:
        return info;
      case AppFeedbackType.success:
        return success;
      case AppFeedbackType.warning:
        return warning;
      case AppFeedbackType.error:
        return error;
    }
  }

  /// Returns the text color (white or black) that contrasts best with [bg].
  static Color contrastFor(Color bg) =>
      bg.computeLuminance() > 0.45 ? Colors.black : Colors.white;
}
