import 'package:flutter/material.dart' hide ThemeExtension;

import '../colors/brand_colors.dart';
import '../gradients/brand_gradients.dart';
import '../theme/theme_extension.dart';

/// Access to custom design-system tokens through [ThemeData].
extension ThemeDataX on ThemeData {
  /// The [AppThemeExtension] registered on this theme.
  AppThemeExtension get nash =>
      extension<AppThemeExtension>() ?? AppThemeExtension.defaults(brightness);

  /// Brand primary color (falls back to [AppColors.primary]).
  Color get nPrimary => nash.primary ?? AppColors.primary;

  /// Brand secondary color.
  Color get nSecondary => nash.secondary ?? AppColors.secondary;

  /// Success color.
  Color get nSuccess => nash.success ?? AppColors.success;

  /// Error color.
  Color get nError => nash.error ?? AppColors.error;

  /// Warning color.
  Color get nWarning => nash.warning ?? AppColors.warning;

  /// Info color.
  Color get nInfo => nash.info ?? AppColors.info;

  /// Brand gradient.
  Gradient get nGradient => nash.brandGradient ?? AppGradients.brand;
}

/// Color extension helpers used across components.
extension ContextColorX on BuildContext {
  /// Success color from the theme extension.
  Color get nSuccess => Theme.of(this).nSuccess;

  /// Warning color from the theme extension.
  Color get nWarning => Theme.of(this).nWarning;

  /// Info color from the theme extension.
  Color get nInfo => Theme.of(this).nInfo;

  /// Error color from the theme extension.
  Color get nError => Theme.of(this).nError;
}
