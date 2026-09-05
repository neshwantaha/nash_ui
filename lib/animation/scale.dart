import 'package:flutter/material.dart';

import 'duration.dart';

/// Scale entrance animation.
///
/// Scales [child] from [begin] (default 0.8) to 1.0 with an overshoot curve.
class ScaleAnimation extends StatelessWidget {
  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration = AppDuration.slow,
    this.curve = AppCurves.bounceOut,
    this.begin = 0.8,
  });

  /// The animated child.
  final Widget child;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Starting scale.
  final double begin;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: begin, end: 1),
        duration: duration,
        curve: curve,
        builder: (BuildContext context, double value, Widget? animatedChild) =>
            Transform.scale(scale: value, child: animatedChild),
        child: child,
      );
}

/// Rotate entrance animation.
///
/// Rotates [child] from [degrees] to 0 when displayed.
class RotateAnimation extends StatelessWidget {
  const RotateAnimation({
    super.key,
    required this.child,
    this.duration = AppDuration.slow,
    this.curve = AppCurves.bounceOut,
    this.degrees = 90,
  });

  /// The animated child.
  final Widget child;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Starting rotation in degrees.
  final double degrees;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: degrees, end: 0),
        duration: duration,
        curve: curve,
        builder: (BuildContext context, double value, Widget? animatedChild) =>
            Transform.rotate(angle: value * 0.0174533, child: animatedChild),
        child: child,
      );
}
