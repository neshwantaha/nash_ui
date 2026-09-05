import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A card that flips in 3-D to reveal its [back] face when tapped.
///
/// Uses a perspective-correct rotation transform on the Y axis.
///
/// ```dart
/// FlipCard(
///   front: CardFront(title: 'Tap me'),
///   back: CardBack(details: '...'),
///   flipDirection: FlipDirection.horizontal,
///   duration: Duration(milliseconds: 600),
/// )
/// ```
class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.flipDirection = FlipDirection.horizontal,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.autoFlip = false,
    this.autoFlipDelay,
    this.onFlip,
  });

  /// The content shown initially.
  final Widget front;

  /// The content revealed on flip.
  final Widget back;

  /// Whether to flip on the horizontal or vertical axis.
  final FlipDirection flipDirection;

  /// Duration of the flip animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// When true, flips automatically after [autoFlipDelay].
  final bool autoFlip;

  /// Delay before auto-flip. Defaults to [duration] × 2.
  final Duration? autoFlipDelay;

  /// Called with the new face index whenever the card flips.
  final ValueChanged<bool>? onFlip;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

/// Controls the flip state of a [FlipCard].
class FlipCardController {
  _FlipCardState? _state;

  /// Flips the card programmatically.
  void flip() => _state?._flip();

  /// Resets the card to the front face.
  void reset() => _state?._reset();

  /// Whether the back face is currently showing.
  bool get isFlipped => _state?._isFlipped ?? false;
}

/// Axis of the flip animation.
enum FlipDirection { horizontal, vertical }

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: widget.curve),
    );

    if (widget.autoFlip) {
      final delay = widget.autoFlipDelay ?? widget.duration * 2;
      Future.delayed(delay, () {
        if (mounted) _flip();
      });
    }
  }

  void _flip() {
    if (_isFlipped) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
    widget.onFlip?.call(_isFlipped);
  }

  void _reset() {
    _ctrl.reverse();
    setState(() => _isFlipped = false);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _flip,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) {
            final angle = _anim.value * math.pi;
            final isFront = angle < math.pi / 2;

            final rotateAxis = Matrix4.identity()..setEntry(3, 2, 0.001);
            if (widget.flipDirection == FlipDirection.horizontal) {
              rotateAxis.rotateY(angle);
            } else {
              rotateAxis.rotateX(angle);
            }

            return Transform(
              transform: rotateAxis,
              alignment: Alignment.center,
              child: isFront
                  ? widget.front
                  : _Mirror(widget.back, widget.flipDirection),
            );
          },
        ),
      );
}

class _Mirror extends StatelessWidget {
  const _Mirror(this.child, this.direction);
  final Widget child;
  final FlipDirection direction;

  @override
  Widget build(BuildContext context) => Transform(
        alignment: Alignment.center,
        transform: direction == FlipDirection.horizontal
            ? (Matrix4.identity()..rotateY(math.pi))
            : (Matrix4.identity()..rotateX(math.pi)),
        child: child,
      );
}
