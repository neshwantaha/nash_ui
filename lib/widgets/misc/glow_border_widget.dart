import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps a child with an animated rotating gradient border.
///
/// The gradient rotates continuously to produce a glowing halo effect.
///
/// ```dart
/// GlowBorderWidget(
///   borderWidth: 3,
///   glowColors: [Colors.purple, Colors.cyan, Colors.pink],
///   borderRadius: BorderRadius.circular(16),
///   child: MyCard(),
/// )
/// ```
class GlowBorderWidget extends StatefulWidget {
  const GlowBorderWidget({
    super.key,
    required this.child,
    this.borderWidth = 2.5,
    this.glowColors,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.rotationDuration = const Duration(seconds: 3),
    this.glowBlur = 8,
    this.animated = true,
    this.padding = EdgeInsets.zero,
  });

  /// The widget to decorate.
  final Widget child;

  /// Width of the glowing border stroke.
  final double borderWidth;

  /// Colors of the rotating gradient. Defaults to purple → cyan → pink → purple.
  final List<Color>? glowColors;

  /// Border radius of both the outer glow and the inner clip.
  final BorderRadius borderRadius;

  /// Duration for one full rotation of the gradient.
  final Duration rotationDuration;

  /// Spread radius / blur amount for the glow effect.
  final double glowBlur;

  /// When false the gradient is static (no animation).
  final bool animated;

  /// Padding between the border and the child.
  final EdgeInsetsGeometry padding;

  @override
  State<GlowBorderWidget> createState() => _GlowBorderWidgetState();
}

class _GlowBorderWidgetState extends State<GlowBorderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    );
    if (widget.animated) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.glowColors ??
        const [
          Color(0xFFAB47BC),
          Color(0xFF00E5FF),
          Color(0xFFFF4081),
          Color(0xFFAB47BC),
        ];

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => CustomPaint(
        painter: _GlowBorderPainter(
          angle: _ctrl.value * 2 * math.pi,
          colors: colors,
          borderWidth: widget.borderWidth,
          borderRadius: widget.borderRadius,
          blurRadius: widget.glowBlur,
        ),
        child: child,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.borderWidth).add(widget.padding),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

class _GlowBorderPainter extends CustomPainter {
  _GlowBorderPainter({
    required this.angle,
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    required this.blurRadius,
  });

  final double angle;
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final double blurRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = borderRadius.toRRect(rect);

    // Gradient origin rotates around the center
    final begin = Alignment(
      math.cos(angle) * 0.8,
      math.sin(angle) * 0.8,
    );
    final end = Alignment(
      math.cos(angle + math.pi) * 0.8,
      math.sin(angle + math.pi) * 0.8,
    );

    final gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.drawRRect(rRect, paint);

    // Solid stroke on top for crispness
    final crispPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 0.6;
    canvas.drawRRect(rRect, crispPaint);
  }

  @override
  bool shouldRepaint(_GlowBorderPainter old) => old.angle != angle;
}
