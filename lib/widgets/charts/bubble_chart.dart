import 'dart:math';
import 'package:flutter/material.dart';

/// A data point for [BubbleChart].
class BubblePoint {
  const BubblePoint({
    required this.x,
    required this.y,
    required this.size,
    this.color,
    this.label = '',
  });

  final double x;
  final double y;
  final double size; // bubble radius in data units
  final Color? color;
  final String label;
}

/// A bubble scatter chart for three-dimensional data comparisons.
class BubbleChart extends StatelessWidget {
  const BubbleChart({
    super.key,
    required this.points,
    this.height = 240,
    this.fillOpacity = 0.5,
    this.animate = true,
    this.showLabels = true,
    this.gridLines = 4,
  });

  final List<BubblePoint> points;
  final double height;
  final double fillOpacity;
  final bool animate;
  final bool showLabels;
  final int gridLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _BubblePainter(
          points: points,
          fillOpacity: fillOpacity,
          showLabels: showLabels,
          gridLines: gridLines,
          gridColor: theme.colorScheme.outlineVariant.withAlpha(80),
          defaultColor: theme.colorScheme.primary,
          labelStyle: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({
    required this.points,
    required this.fillOpacity,
    required this.showLabels,
    required this.gridLines,
    required this.gridColor,
    required this.defaultColor,
    this.labelStyle,
  });

  final List<BubblePoint> points;
  final double fillOpacity;
  final bool showLabels;
  final int gridLines;
  final Color gridColor;
  final Color defaultColor;
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxX = points.map((p) => p.x).reduce(max) * 1.1;
    final maxY = points.map((p) => p.y).reduce(max) * 1.1;
    final maxSize = points.map((p) => p.size).reduce(max);

    double toScreenX(double x) => (x / maxX) * size.width;
    double toScreenY(double y) => size.height - (y / maxY) * size.height;

    // Grid
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (int i = 1; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      final x = size.width * i / gridLines;
      canvas
        ..drawLine(Offset(0, y), Offset(size.width, y), gridPaint)
        ..drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Bubbles
    for (final p in points) {
      final sx = toScreenX(p.x);
      final sy = toScreenY(p.y);
      final r = (p.size / maxSize) * (size.width * 0.12);
      final color = p.color ?? defaultColor;

      canvas
        ..drawCircle(
          Offset(sx, sy),
          r,
          Paint()..color = color.withAlpha((fillOpacity * 255).round()),
        )
        ..drawCircle(
          Offset(sx, sy),
          r,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );

      if (showLabels && p.label.isNotEmpty) {
        final tp = TextPainter(
          text: TextSpan(text: p.label, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(sx - tp.width / 2, sy - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}
