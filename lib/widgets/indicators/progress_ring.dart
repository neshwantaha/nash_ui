import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular arc progress indicator styled like Apple Watch activity rings.
///
/// Renders a rounded gradient arc that sweeps from 0 to [value] × 360°.
///
/// ```dart
/// ProgressRing(
///   value: 0.72,
///   gradient: LinearGradient(colors: [Colors.pink, Colors.orange]),
///   size: 120,
///   strokeWidth: 14,
///   child: Text('72%'),
/// )
/// ```
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 100,
    this.strokeWidth = 12,
    this.gradient,
    this.trackColor,
    this.startAngle = -math.pi / 2,
    this.animationDuration = const Duration(milliseconds: 900),
    this.animationCurve = Curves.easeOut,
    this.child,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Diameter of the ring.
  final double size;

  /// Width of the arc stroke.
  final double strokeWidth;

  /// Gradient applied to the arc. Defaults to a blue-to-teal gradient.
  final Gradient? gradient;

  /// Color of the background track ring.
  final Color? trackColor;

  /// Starting angle of the arc in radians. Default is top-center (-pi/2).
  final double startAngle;

  /// Duration of the fill-in animation.
  final Duration animationDuration;

  /// Curve of the fill-in animation.
  final Curve animationCurve;

  /// Optional widget centered inside the ring.
  final Widget? child;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _anim = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: widget.animationCurve),
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(ProgressRing old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _anim = Tween<double>(
        begin: _anim.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _ctrl, curve: widget.animationCurve),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = widget.gradient ??
        const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    final trackColor =
        widget.trackColor ?? theme.colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          painter: _RingPainter(
            value: _anim.value,
            gradient: gradient,
            trackColor: trackColor,
            strokeWidth: widget.strokeWidth,
            startAngle: widget.startAngle,
          ),
          child: child,
        ),
      ),
      child: widget.child == null ? null : Center(child: widget.child),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.gradient,
    required this.trackColor,
    required this.strokeWidth,
    required this.startAngle,
  });

  final double value;
  final Gradient gradient;
  final Color trackColor;
  final double strokeWidth;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (value <= 0) return;

    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.gradient != gradient;
}
