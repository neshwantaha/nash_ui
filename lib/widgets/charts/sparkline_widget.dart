import 'dart:math';
import 'package:flutter/material.dart';

/// A compact inline sparkline chart for embedding in lists and cards.
///
/// ```dart
/// SparklineWidget(
///   data: [10, 25, 18, 40, 35, 55, 48],
///   color: Colors.green,
///   height: 40,
/// )
/// ```
class SparklineWidget extends StatelessWidget {
  const SparklineWidget({
    super.key,
    required this.data,
    this.height = 40,
    this.color,
    this.strokeWidth = 2.0,
    this.fill = true,
    this.showEndDot = true,
    this.curved = true,
  });

  final List<double> data;
  final double height;
  final Color? color;
  final double strokeWidth;
  final bool fill;
  final bool showEndDot;
  final bool curved;

  @override
  Widget build(BuildContext context) {
    final lineColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _SparkPainter(
          data: data,
          color: lineColor,
          strokeWidth: strokeWidth,
          fill: fill,
          showEndDot: showEndDot,
          curved: curved,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.fill,
    required this.showEndDot,
    required this.curved,
  });

  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool fill;
  final bool showEndDot;
  final bool curved;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final minVal = data.reduce(min);
    final maxVal = data.reduce(max);
    final range = max(maxVal - minVal, 0.001);

    Offset toPoint(int i) {
      final x = size.width * i / (data.length - 1);
      final y = size.height - ((data[i] - minVal) / range) * size.height;
      return Offset(x, y);
    }

    final points = List.generate(data.length, toPoint);
    final path = Path()..moveTo(points[0].dx, points[0].dy);

    if (curved) {
      for (int i = 1; i < points.length; i++) {
        final cp1 = Offset(
          (points[i - 1].dx + points[i].dx) / 2,
          points[i - 1].dy,
        );
        final cp2 = Offset(
          (points[i - 1].dx + points[i].dx) / 2,
          points[i].dy,
        );
        path.cubicTo(
            cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
    } else {
      for (final p in points) {
        path.lineTo(p.dx, p.dy);
      }
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()..color = color.withAlpha(40),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    if (showEndDot && points.isNotEmpty) {
      canvas
        ..drawCircle(points.last, strokeWidth * 2, Paint()..color = color)
        ..drawCircle(
          points.last,
          strokeWidth * 2,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.data != data;
}
