import 'package:flutter/material.dart';

import 'duration.dart';

/// Direction of a slide animation.
enum SlideAnimationDirection {
  /// Slides up from the bottom.
  up,

  /// Slides down from the top.
  down,

  /// Slides in from the left.
  left,

  /// Slides in from the right.
  right,
}

/// Slide entrance animation.
class SlideAnimation extends StatelessWidget {
  const SlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideAnimationDirection.up,
    this.duration = AppDuration.slow,
    this.curve = AppCurves.easeOut,
    this.offset = 0.25,
  });

  /// The animated child.
  final Widget child;

  /// Direction of travel.
  final SlideAnimationDirection direction;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Starting offset as a fraction of the child size.
  final double offset;

  Offset _initialOffset() {
    switch (direction) {
      case SlideAnimationDirection.up:
        return Offset(0, offset);
      case SlideAnimationDirection.down:
        return Offset(0, -offset);
      case SlideAnimationDirection.left:
        return Offset(offset, 0);
      case SlideAnimationDirection.right:
        return Offset(-offset, 0);
    }
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(begin: _initialOffset(), end: Offset.zero),
        duration: duration,
        curve: curve,
        builder: (BuildContext context, Offset value, Widget? animatedChild) =>
            FractionalTranslation(translation: value, child: animatedChild),
        child: child,
      );
}
