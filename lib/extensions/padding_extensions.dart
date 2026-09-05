import 'package:flutter/material.dart';

/// Padding helpers on [EdgeInsets].
extension EdgeInsetsX on EdgeInsets {
  /// A copy with new [horizontal] values, keeping vertical from this inset.
  EdgeInsets withHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value, vertical: vertical);

  /// A copy with new [vertical] values, keeping horizontal from this inset.
  EdgeInsets withVertical(double value) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: value);

  /// `EdgeInsets.symmetric(horizontal: v, vertical: 0)`.
  EdgeInsets get symmetricHorizontal =>
      EdgeInsets.symmetric(horizontal: horizontal);

  /// `EdgeInsets.symmetric(vertical: v, horizontal: 0)`.
  EdgeInsets get symmetricVertical => EdgeInsets.symmetric(vertical: vertical);
}

/// Padding shortcuts on [num].
extension NumPaddingX on num {
  /// Uniform padding of `value`.
  EdgeInsets get toPaddingAll => EdgeInsets.all(toDouble());

  /// Horizontal-only padding of `value`.
  EdgeInsets get toPaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Vertical-only padding of `value`.
  EdgeInsets get toPaddingVertical =>
      EdgeInsets.symmetric(vertical: toDouble());

  /// `EdgeInsets.symmetric(horizontal: value, vertical: 0)`.
  EdgeInsets get toPaddingLeft => EdgeInsets.only(left: toDouble());

  /// `EdgeInsets.only(right: value)`.
  EdgeInsets get toPaddingRight => EdgeInsets.only(right: toDouble());

  /// `EdgeInsets.only(top: value)`.
  EdgeInsets get toPaddingTop => EdgeInsets.only(top: toDouble());

  /// `EdgeInsets.only(bottom: value)`.
  EdgeInsets get toPaddingBottom => EdgeInsets.only(bottom: toDouble());
}

/// Border helpers on [BorderRadius].
extension AppBorderRadiusX on BorderRadius {
  /// A [Border] with this radius and the given [color]/[width].
  Border toBorder({Color? color, double width = 1}) =>
      Border.all(color: color ?? const Color(0xFFE2E8F0), width: width);

  /// A rounded [OutlineInputBorder] using this radius.
  OutlineInputBorder toOutlineInputBorder({
    Color color = const Color(0xFFCBD5E1),
    double width = 1,
  }) =>
      OutlineInputBorder(
        borderRadius: this,
        borderSide: BorderSide(color: color, width: width),
      );
}
