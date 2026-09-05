import 'package:flutter/material.dart';

import '../colors/brand_colors.dart';

/// Border and divider tokens for the design system.
abstract final class AppBorder {
  AppBorder._();

  /// 1px hairline stroke.
  static const double thin = 1;

  /// 1.5px default stroke.
  static const double normal = 1.5;

  /// 2px emphasis stroke.
  static const double bold = 2;

  /// 3px strong stroke.
  static const double heavy = 3;

  /// Default side (neutral grey, 1px).
  static const BorderSide side = BorderSide(color: Color(0x1F000000));

  /// Side for outlined controls (neutral, 1.5px).
  static const BorderSide sideOutline =
      BorderSide(color: Color(0x29000000), width: 1.5);

  /// Primary side (2px).
  static const BorderSide sidePrimary =
      BorderSide(color: AppColors.primary, width: 2);

  /// Success side (2px).
  static const BorderSide sideSuccess =
      BorderSide(color: AppColors.success, width: 2);

  /// Error side (2px).
  static const BorderSide sideError =
      BorderSide(color: AppColors.error, width: 2);

  /// Warning side (2px).
  static const BorderSide sideWarning =
      BorderSide(color: AppColors.warning, width: 2);

  /// Info side (2px).
  static const BorderSide sideInfo =
      BorderSide(color: AppColors.info, width: 2);

  /// Fully rounded outlined border for inputs.
  static const OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: sideOutline,
  );

  /// Focused outlined border for inputs.
  static const OutlineInputBorder inputFocused = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: sidePrimary,
  );

  /// Error outlined border for inputs.
  static const OutlineInputBorder inputError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: sideError,
  );

  /// Builds a [Border] with [color], [width] and optional [radius].
  static Border all({
    Color color = const Color(0x1F000000),
    double width = thin,
  }) =>
      Border.all(color: color, width: width);
}
