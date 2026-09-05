/// Opacity tokens for the design system.
///
/// Keeps translucent states consistent across the entire product.
abstract final class AppOpacity {
  AppOpacity._();

  /// Fully visible.
  static const double none = 1.0;

  /// 90% — strong emphasis.
  static const double xs = 0.9;

  /// 80% — high emphasis.
  static const double sm = 0.8;

  /// 70% — default disabled / secondary.
  static const double md = 0.7;

  /// 60% — hint emphasis.
  static const double lg = 0.6;

  /// 50% — muted.
  static const double xl = 0.5;

  /// 38% — material standard for disabled text.
  static const double disabled = 0.38;

  /// 12% — faint wash.
  static const double faint = 0.12;

  /// 8% — very faint wash.
  static const double faintest = 0.08;

  /// 0% — invisible.
  static const double hidden = 0.0;
}
