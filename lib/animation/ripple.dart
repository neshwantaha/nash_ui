import 'package:flutter/material.dart';

/// Infinite expanding ripple / pulse effect behind [child].
class Ripple extends StatefulWidget {
  const Ripple({
    super.key,
    required this.child,
    this.color,
    this.duration = const Duration(milliseconds: 1600),
    this.rings = 1,
    this.maxRadius = 64,
    this.enabled = true,
  });

  /// The centered content.
  final Widget child;

  /// Ripple color (defaults to the theme primary).
  final Color? color;

  /// One ripple period.
  final Duration duration;

  /// Number of simultaneous ripple rings.
  final int rings;

  /// Maximum ring radius.
  final double maxRadius;

  /// When false the child is rendered without animation.
  final bool enabled;

  @override
  State<Ripple> createState() => _RippleState();
}

class _RippleState extends State<Ripple> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final List<Widget> rings = <Widget>[];
        for (int i = 0; i < widget.rings; i++) {
          final double t = (_controller.value + i / widget.rings) % 1.0;
          rings.add(
            CustomPaint(
              painter: _RipplePainter(
                  progress: t, color: color, maxRadius: widget.maxRadius),
            ),
          );
        }
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[...rings, child!],
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter(
      {required this.progress, required this.color, required this.maxRadius});

  final double progress;
  final Color color;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = progress * maxRadius;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color.withValues(alpha: (1 - progress) * 0.6);
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.maxRadius != maxRadius;
}
