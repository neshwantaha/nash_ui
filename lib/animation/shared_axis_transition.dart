import 'package:flutter/material.dart';

import 'duration.dart';

/// Axis for the shared-axis transition.
enum SharedAxis {
  /// Horizontal.
  horizontal,

  /// Vertical.
  vertical,
}

/// A Material "shared axis" transition between two children.
///
/// The outgoing child slides out along [axis] while the incoming child slides
/// in from the opposite side. Use a keyed container when switching content so
/// the widgets rebuild with their own entrance.
class SharedAxisTransition extends StatefulWidget {
  const SharedAxisTransition({
    super.key,
    required this.current,
    this.previous,
    this.axis = SharedAxis.horizontal,
    this.duration = AppDuration.slow,
    this.curve = AppCurves.standard,
  });

  /// The currently displayed child.
  final Widget current;

  /// The previously displayed child (optional exit animation).
  final Widget? previous;

  /// Movement axis.
  final SharedAxis axis;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  State<SharedAxisTransition> createState() => _SharedAxisTransitionState();
}

class _SharedAxisTransitionState extends State<SharedAxisTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    if (widget.previous != null) _controller.forward();
  }

  @override
  void didUpdateWidget(SharedAxisTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.previous != null && widget.previous != oldWidget.previous) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _offsetFor(double value, bool incoming) {
    final double traveled = 1 - value;
    return (incoming ? -traveled : traveled) * 0.2;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? previous = widget.previous;
    if (previous == null) return widget.current;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final double v = _animation.value;
            final double dx =
                widget.axis == SharedAxis.horizontal ? _offsetFor(v, false) : 0;
            final double dy =
                widget.axis == SharedAxis.vertical ? _offsetFor(v, false) : 0;
            return Opacity(
              opacity: 1 - v,
              child: FractionalTranslation(
                translation: Offset(dx, dy),
                child: child,
              ),
            );
          },
          child: previous,
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final double v = _animation.value;
            final double dx =
                widget.axis == SharedAxis.horizontal ? _offsetFor(v, true) : 0;
            final double dy =
                widget.axis == SharedAxis.vertical ? _offsetFor(v, true) : 0;
            return Opacity(
              opacity: v,
              child: FractionalTranslation(
                translation: Offset(dx, dy),
                child: child,
              ),
            );
          },
          child: widget.current,
        ),
      ],
    );
  }
}
