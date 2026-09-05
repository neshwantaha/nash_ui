import 'package:flutter/widgets.dart';

/// Spacing scale tokens for the design system.
///
/// Every spacing value used across components should be derived from this
/// scale to guarantee visual rhythm and consistency.
abstract final class AppSpacing {
  AppSpacing._();

  /// 4 logical pixels — smallest gap.
  static const double xs = 4;

  /// 8 logical pixels — small gap.
  static const double sm = 8;

  /// 12 logical pixels — default gap.
  static const double md = 12;

  /// 16 logical pixels — card padding.
  static const double lg = 16;

  /// 20 logical pixels — comfortable gap.
  static const double xl = 20;

  /// 24 logical pixels — section spacing.
  static const double xxl = 24;

  /// 32 logical pixels — large section spacing.
  static const double xxxl = 32;

  /// 40 logical pixels — screen edge spacing.
  static const double huge = 40;

  /// 48 logical pixels — hero spacing.
  static const double massive = 48;

  /// 64 logical pixels — landing spacing.
  static const double giant = 64;

  /// 80 logical pixels — large landing spacing.
  static const double colossal = 80;

  // Numeric aliases for programmatic use.
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s80 = 80;

  /// Convenience [EdgeInsets] with the default card padding ([AppSpacing.lg]).
  static const EdgeInsets screen = EdgeInsets.all(lg);
}
