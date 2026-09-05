import 'package:flutter/material.dart';

/// Repeating bounce emphasis animation.
class Bounce extends StatefulWidget {
  const Bounce({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeInOut,
    this.strength = 0.15,
    this.enabled = true,
  });

  /// The animated child.
  final Widget child;

  /// One bounce period.
  final Duration duration;

  /// Bounce curve.
  final Curve curve;

  /// Maximum scale deviation.
  final double strength;

  /// When false the child is rendered without animation.
  final bool enabled;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 1, end: 1 + widget.strength)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    if (widget.enabled) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _scale,
      child: widget.child,
      builder: (BuildContext context, Widget? child) =>
          Transform.scale(scale: _scale.value, child: child),
    );
  }
}

/// Repeating horizontal shake emphasis animation.
class Shake extends StatefulWidget {
  const Shake({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.strength = 6,
    this.enabled = true,
  });

  /// The animated child.
  final Widget child;

  /// One shake period.
  final Duration duration;

  /// Maximum horizontal displacement in pixels.
  final double strength;

  /// When false the child is rendered without animation.
  final bool enabled;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => Transform.translate(
        offset: Offset(
          (_controller.value - 0.5) * 2 * widget.strength,
          0,
        ),
        child: child,
      ),
    );
  }
}
