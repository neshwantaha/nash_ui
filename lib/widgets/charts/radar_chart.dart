import 'dart:math';
import 'package:flutter/material.dart';

/// A radar (spider) chart widget for comparing multi-dimensional data.
class RadarChart extends StatefulWidget {
  const RadarChart({
    super.key,
    required this.labels,
    required this.dataSets,
    this.maxValue = 100,
    this.size = 260,
    this.gridColor,
    this.labelStyle,
    this.animate = true,
  });

  /// Axis labels (e.g. ['Speed', 'Strength', 'Agility']).
  final List<String> labels;

  /// Multiple data series; each is a [RadarDataSet].
  final List<RadarDataSet> dataSets;
  final double maxValue;
  final double size;
  final Color? gridColor;
  final TextStyle? labelStyle;
  final bool animate;

  @override
  State<RadarChart> createState() => _RadarChartState();
}

class RadarDataSet {
  const RadarDataSet({
    required this.values,
    required this.color,
    this.fillOpacity = 0.2,
    this.label,
  });

  final List<double> values;
  final Color color;
  final double fillOpacity;
  final String? label;
}

class _RadarChartState extends State<RadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progress =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _progress,
          builder: (_, __) => CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RadarPainter(
              labels: widget.labels,
              dataSets: widget.dataSets,
              maxValue: widget.maxValue,
              gridColor:
                  widget.gridColor ?? theme.colorScheme.outline.withAlpha(60),
              labelStyle: widget.labelStyle ??
                  theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.onSurface),
              progress: _progress.value,
            ),
          ),
        ),
        // Legend
        if (widget.dataSets.any((d) => d.label != null))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 16,
              children: widget.dataSets
                  .where((d) => d.label != null)
                  .map((d) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: d.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(d.label!, style: theme.textTheme.labelSmall),
                        ],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.labels,
    required this.dataSets,
    required this.maxValue,
    required this.gridColor,
    required this.labelStyle,
    required this.progress,
  });

  final List<String> labels;
  final List<RadarDataSet> dataSets;
  final double maxValue;
  final Color gridColor;
  final TextStyle? labelStyle;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 32;
    final n = labels.length;
    if (n < 3) {
      return;
    }
    const gridLevels = 4;

    // Draw grid
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int lvl = 1; lvl <= gridLevels; lvl++) {
      final r = radius * lvl / gridLevels;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final angle = (2 * pi * i / n) - pi / 2;
        final p =
            Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines
    for (int i = 0; i < n; i++) {
      final angle = (2 * pi * i / n) - pi / 2;
      canvas.drawLine(
        center,
        Offset(
            center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        gridPaint,
      );
    }

    // Draw data sets
    for (final ds in dataSets) {
      final fillPaint = Paint()
        ..color = ds.color.withAlpha((ds.fillOpacity * 255 * progress).round())
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = ds.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      for (int i = 0; i < n; i++) {
        final val =
            (ds.values.length > i ? ds.values[i] : 0).clamp(0, maxValue);
        final r = radius * (val / maxValue) * progress;
        final angle = (2 * pi * i / n) - pi / 2;
        final p =
            Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas
        ..drawPath(path, fillPaint)
        ..drawPath(path, strokePaint);
    }

    // Draw labels
    for (int i = 0; i < n; i++) {
      final angle = (2 * pi * i / n) - pi / 2;
      final labelR = radius + 24;
      final p = Offset(
          center.dx + labelR * cos(angle), center.dy + labelR * sin(angle));
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(
        canvas,
        Offset(p.dx - tp.width / 2, p.dy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.progress != progress || old.dataSets != dataSets;
}
