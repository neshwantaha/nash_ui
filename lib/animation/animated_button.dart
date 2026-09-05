import 'package:flutter/material.dart';

import 'duration.dart';

/// A button wrapper that scales down while pressed for tactile feedback.
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.pressedScale = 0.94,
    this.duration = AppDuration.fast,
    this.borderRadius,
    this.onLongPress,
  });

  /// Triggered on tap.
  final VoidCallback onPressed;

  /// The button content.
  final Widget child;

  /// Scale applied while pressed.
  final double pressedScale;

  /// Animation duration.
  final Duration duration;

  /// Press ripple radius.
  final BorderRadius? borderRadius;

  /// Optional long-press callback.
  final VoidCallback? onLongPress;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _scale = Tween<double>(begin: 1, end: widget.pressedScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _pressDown(PointerDownEvent _) => _controller.forward();

  void _pressUp(PointerUpEvent _) => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressCancel(PointerCancelEvent _) => _controller.reverse();

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: _pressDown,
        onPointerUp: _pressUp,
        onPointerCancel: _pressCancel,
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              onLongPress: widget.onLongPress,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              child: widget.child,
            ),
          ),
        ),
      );
}
