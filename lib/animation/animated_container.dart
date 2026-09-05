import 'package:flutter/material.dart' as fl;

import 'duration.dart';

/// A widget that animates its child between a target [enabled] state with
/// theme-aware easing. Useful for interactive emphasis.
class AnimatedContainer extends fl.StatelessWidget {
  const AnimatedContainer({
    super.key,
    this.child,
    this.duration = AppDuration.normal,
    this.curve = AppCurves.standard,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.borderRadius,
    this.shadows,
    this.border,
    this.gradient,
    this.decoration,
    this.constraints,
  });

  /// The animated child.
  final fl.Widget? child;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final fl.Curve curve;

  /// Background decoration. If provided, overrides individual color/gradient/borderRadius/shadows/border.
  final fl.Decoration? decoration;

  /// Background color.
  final fl.Color? color;

  /// Inner padding.
  final fl.EdgeInsetsGeometry? padding;

  /// Outer margin.
  final fl.EdgeInsetsGeometry? margin;

  /// Width.
  final double? width;

  /// Height.
  final double? height;

  /// Child alignment.
  final fl.AlignmentGeometry? alignment;

  /// Corner radius.
  final fl.BorderRadius? borderRadius;

  /// Box shadows.
  final List<fl.BoxShadow>? shadows;

  /// Border.
  final fl.BoxBorder? border;

  /// Background gradient.
  final fl.Gradient? gradient;

  /// Constraints.
  final fl.BoxConstraints? constraints;

  @override
  fl.Widget build(fl.BuildContext context) => fl.AnimatedContainer(
        duration: duration,
        curve: curve,
        decoration: decoration ??
            fl.BoxDecoration(
              color: gradient == null ? color : null,
              gradient: gradient,
              borderRadius: borderRadius,
              boxShadow: shadows,
              border: border,
            ),
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        alignment: alignment,
        constraints: constraints,
        child: child,
      );
}
