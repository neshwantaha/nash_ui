import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Alignment position for the [CornerRibbon].
enum RibbonPosition { topLeft, topRight, bottomLeft, bottomRight }

/// A diagonal corner ribbon/banner overlay for cards and containers.
///
/// ```dart
/// CornerRibbon(
///   text: 'SALE 50%',
///   color: Colors.red,
///   position: RibbonPosition.topRight,
///   child: MyCardWidget(),
/// )
/// ```
class CornerRibbon extends StatelessWidget {
  const CornerRibbon({
    super.key,
    required this.child,
    required this.text,
    this.color = const Color(0xFFEF4444),
    this.textColor = Colors.white,
    this.position = RibbonPosition.topRight,
    this.size = 80.0,
    this.textStyle,
    this.elevation = 2.0,
  });

  final Widget child;
  final String text;
  final Color color;
  final Color textColor;
  final RibbonPosition position;
  final double size;
  final TextStyle? textStyle;
  final double elevation;

  @override
  Widget build(BuildContext context) => ClipRRect(
        child: Stack(
          children: [
            child,
            Positioned(
              top: position == RibbonPosition.topLeft ||
                      position == RibbonPosition.topRight
                  ? 0
                  : null,
              bottom: position == RibbonPosition.bottomLeft ||
                      position == RibbonPosition.bottomRight
                  ? 0
                  : null,
              left: position == RibbonPosition.topLeft ||
                      position == RibbonPosition.bottomLeft
                  ? 0
                  : null,
              right: position == RibbonPosition.topRight ||
                      position == RibbonPosition.bottomRight
                  ? 0
                  : null,
              child: CustomPaint(
                size: Size(size, size),
                painter: _RibbonPainter(
                  text: text,
                  color: color,
                  textColor: textColor,
                  position: position,
                  style: textStyle ??
                      const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                  elevation: elevation,
                ),
              ),
            ),
          ],
        ),
      );
}

class _RibbonPainter extends CustomPainter {
  _RibbonPainter({
    required this.text,
    required this.color,
    required this.textColor,
    required this.position,
    required this.style,
    required this.elevation,
  });

  final String text;
  final Color color;
  final Color textColor;
  final RibbonPosition position;
  final TextStyle style;
  final double elevation;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final path = Path();
    double angle = 0.0;
    Offset textOffset = Offset.zero;

    switch (position) {
      case RibbonPosition.topLeft:
        path
          ..moveTo(0, s * 0.7)
          ..lineTo(s * 0.7, 0)
          ..lineTo(s, 0)
          ..lineTo(0, s)
          ..close();
        angle = -math.pi / 4;
        textOffset = Offset(s * 0.35, s * 0.35);
        break;

      case RibbonPosition.topRight:
        path
          ..moveTo(s * 0.3, 0)
          ..lineTo(s, s * 0.7)
          ..lineTo(s, s)
          ..lineTo(0, 0)
          ..close();
        angle = math.pi / 4;
        textOffset = Offset(s * 0.65, s * 0.35);
        break;

      case RibbonPosition.bottomLeft:
        path
          ..moveTo(0, s * 0.3)
          ..lineTo(s * 0.7, s)
          ..lineTo(s, s)
          ..lineTo(0, 0)
          ..close();
        angle = math.pi / 4;
        textOffset = Offset(s * 0.35, s * 0.65);
        break;

      case RibbonPosition.bottomRight:
        path
          ..moveTo(s, s * 0.3)
          ..lineTo(s * 0.3, s)
          ..lineTo(0, s)
          ..lineTo(s, 0)
          ..close();
        angle = -math.pi / 4;
        textOffset = Offset(s * 0.65, s * 0.65);
        break;
    }

    if (elevation > 0) {
      canvas.drawShadow(path, Colors.black, elevation, true);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final painter = TextPainter(
      text: TextSpan(text: text, style: style.copyWith(color: textColor)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    canvas
      ..save()
      ..translate(textOffset.dx, textOffset.dy)
      ..rotate(angle);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RibbonPainter old) =>
      old.text != text ||
      old.color != color ||
      old.textColor != textColor ||
      old.position != position ||
      old.elevation != elevation;
}
