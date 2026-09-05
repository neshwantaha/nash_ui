import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Renders a diagonal, tiled watermark text overlay on top of [child].
///
/// ```dart
/// Watermark(
///   text: 'CONFIDENTIAL',
///   color: Colors.red.withOpacity(0.15),
///   angle: -30,
///   spacing: 120,
///   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
///   child: MyContent(),
/// )
/// ```
class Watermark extends StatelessWidget {
  const Watermark({
    super.key,
    required this.child,
    this.text = 'WATERMARK',
    this.color,
    this.style,
    this.angle = -30,
    this.spacing = 120.0,
    this.enabled = true,
  });

  final Widget child;
  final String text;

  /// Watermark text colour. Defaults to `Colors.grey.withOpacity(0.18)`.
  final Color? color;
  final TextStyle? style;

  /// Rotation angle in **degrees** (negative = counter-clockwise).
  final double angle;

  /// Distance (px) between repeated watermark tiles.
  final double spacing;

  /// Set to false to disable the watermark entirely.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _WatermarkPainter(
                text: text,
                color: color ?? Colors.grey.withAlpha(46),
                style: style ??
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                angleRad: angle * math.pi / 180,
                spacing: spacing,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  _WatermarkPainter({
    required this.text,
    required this.color,
    required this.style,
    required this.angleRad,
    required this.spacing,
  });

  final String text;
  final Color color;
  final TextStyle style;
  final double angleRad;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style.copyWith(color: color)),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    final diag = math.sqrt(size.width * size.width + size.height * size.height);
    final tiles = (diag / spacing).ceil() + 2;

    canvas
      ..translate(size.width / 2, size.height / 2)
      ..rotate(angleRad);

    for (int row = -tiles; row <= tiles; row++) {
      for (int col = -tiles; col <= tiles; col++) {
        final dx = col * spacing - painter.width / 2;
        final dy = row * spacing - painter.height / 2;
        painter.paint(canvas, Offset(dx, dy));
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_WatermarkPainter old) =>
      old.text != text ||
      old.color != color ||
      old.angleRad != angleRad ||
      old.spacing != spacing;
}
