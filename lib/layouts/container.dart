import 'package:flutter/material.dart';

import '../radius/app_radius.dart';
import '../shadows/shadow.dart';

/// A flexible, theme-aware container.
///
/// Combines the most common box properties (color, gradient, border, radius,
/// shadow, padding, tap) into a single widget with sensible design-system
/// defaults.
class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.child,
    this.color,
    this.gradient,
    this.padding,
    this.margin,
    this.radius,
    this.border,
    this.borderColor,
    this.borderWidth = 1,
    this.shadows,
    this.elevated = false,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
    this.constraints,
  });

  /// The inner content.
  final Widget? child;

  /// Solid background color.
  final Color? color;

  /// Background gradient (takes precedence over [color]).
  final Gradient? gradient;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Corner radius. Defaults to [AppRadius.medium].
  final double? radius;

  /// Explicit border radius (overrides [radius]).
  final BorderRadius? border;

  /// Border color when [borderWidth] is used.
  final Color? borderColor;

  /// Border stroke width.
  final double borderWidth;

  /// Custom box shadows.
  final List<BoxShadow>? shadows;

  /// Applies the default elevated card shadow.
  final bool elevated;

  /// Tap callback (wraps content in [Material] + [InkWell]).
  final VoidCallback? onTap;

  /// Fixed width.
  final double? width;

  /// Fixed height.
  final double? height;

  /// Child alignment.
  final AlignmentGeometry? alignment;

  /// Box constraints.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        border ?? BorderRadius.circular(radius ?? AppRadius.medium);
    final BoxDecoration decoration = BoxDecoration(
      color: gradient == null ? color : null,
      gradient: gradient,
      borderRadius: borderWidth > 0 ? borderRadius : null,
      border: borderWidth > 0
          ? Border.all(
              color: borderColor ?? Colors.transparent, width: borderWidth)
          : null,
      boxShadow: shadows ?? (elevated ? AppShadow.card : null),
    );

    final Widget box = Container(
      width: width,
      height: height,
      constraints: constraints,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return box;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            width: width,
            height: height,
            constraints: constraints,
            padding: padding,
            margin: margin,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}
