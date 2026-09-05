import 'package:flutter/material.dart';

/// Fade entrance animation.
///
/// Fades [child] in from [opacity] (default 0) to 1 when first displayed.
class FadeAnimation extends StatelessWidget {
  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.begin = 0,
  });

  /// The animated child.
  final Widget child;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Starting opacity.
  final double begin;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: begin, end: 1),
        duration: duration,
        curve: curve,
        builder: (BuildContext context, double value, Widget? animatedChild) =>
            Opacity(opacity: value, child: animatedChild),
        child: child,
      );
}
