import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RtlHelper — RTL-aware utilities
// ─────────────────────────────────────────────────────────────────────────────

/// Utility class for RTL-aware layouts and text direction detection.
///
/// ```dart
/// final isRtl = RtlHelper.isRtl(context);  // true for Arabic, Persian, Hebrew, Urdu
/// Padding(padding: RtlHelper.paddingStart(context, 16))
/// ```
abstract final class RtlHelper {
  RtlHelper._();

  /// Returns true if the current text direction is RTL.
  static bool isRtl(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  /// Returns [TextAlign.right] for RTL locales, [TextAlign.left] for LTR.
  static TextAlign textAlign(BuildContext context) =>
      isRtl(context) ? TextAlign.right : TextAlign.left;

  /// Returns [TextAlign.left] for RTL locales (opposite of content alignment).
  static TextAlign textAlignOpposite(BuildContext context) =>
      isRtl(context) ? TextAlign.left : TextAlign.right;

  /// Logical start padding (left in LTR, right in RTL).
  static EdgeInsetsDirectional paddingStart(
          BuildContext context, double value) =>
      EdgeInsetsDirectional.only(start: value);

  /// Logical end padding (right in LTR, left in RTL).
  static EdgeInsetsDirectional paddingEnd(BuildContext context, double value) =>
      EdgeInsetsDirectional.only(end: value);

  /// Logical start + end padding.
  static EdgeInsetsDirectional paddingHorizontal(double value) =>
      EdgeInsetsDirectional.symmetric(horizontal: value);

  /// Returns the correct arrow icon for forward navigation
  /// (right arrow in LTR, left arrow in RTL).
  static IconData forwardArrow(BuildContext context) => isRtl(context)
      ? Icons.arrow_back_ios_rounded
      : Icons.arrow_forward_ios_rounded;

  /// Returns the correct arrow icon for backward navigation.
  static IconData backArrow(BuildContext context) => isRtl(context)
      ? Icons.arrow_forward_ios_rounded
      : Icons.arrow_back_ios_rounded;

  /// Flips a horizontal offset for RTL layouts.
  static Offset flipOffset(BuildContext context, Offset offset) =>
      isRtl(context) ? Offset(-offset.dx, offset.dy) : offset;

  /// Returns [CrossAxisAlignment.end] for RTL and [start] for LTR.
  static CrossAxisAlignment crossAxisStart(BuildContext context) =>
      isRtl(context) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
}

// ─────────────────────────────────────────────────────────────────────────────
// BuildContext RTL Extension
// ─────────────────────────────────────────────────────────────────────────────

/// Shorthand RTL helpers directly on [BuildContext].
extension RtlContextX on BuildContext {
  /// True when the locale text direction is RTL.
  bool get isRtl => RtlHelper.isRtl(this);

  /// True when the locale text direction is LTR.
  bool get isLtr => !isRtl;

  /// Locale-appropriate text alignment.
  TextAlign get textAlignStart => RtlHelper.textAlign(this);

  /// Forward navigation arrow icon (→ LTR, ← RTL).
  IconData get forwardArrow => RtlHelper.forwardArrow(this);

  /// Back navigation arrow icon (← LTR, → RTL).
  IconData get backArrow => RtlHelper.backArrow(this);
}
