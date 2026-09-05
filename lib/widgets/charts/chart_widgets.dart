import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/font_weight.dart';

/// A line chart with gradient fill, grid lines and optional dots/labels.
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.data,
    this.labels,
    this.height = 200,
    this.lineColor,
    this.gradient,
    this.showGrid = true,
    this.showDots = true,
    this.showLabels = true,
    this.showArea = true,
    this.lineWidth = 2.5,
  });

  /// Y values to plot (ordered by x position).
  final List<double> data;

  /// Optional x-axis labels matching [data] length.
  final List<String>? labels;

  /// Chart height.
  final double height;

  /// Line color.
  final Color? lineColor;

  /// Area gradient under the line.
  final Gradient? gradient;

  /// Whether to draw horizontal grid lines.
  final bool showGrid;

  /// Whether to draw points on the line.
  final bool showDots;

  /// Whether to draw x-axis labels.
  final bool showLabels;

  /// Whether to fill the area under the line.
  final bool showArea;

  /// Stroke width of the line.
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (data.length < 2) return const SizedBox.shrink();

    final Color stroke = lineColor ?? scheme.primary;
    final Gradient area = gradient ??
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            stroke.withValues(alpha: 0.3),
            stroke.withValues(alpha: 0.02),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineChartPainter(
              data: data,
              stroke: stroke,
              gradient: area,
              showGrid: showGrid,
              showDots: showDots,
              showArea: showArea,
              lineWidth: lineWidth,
              gridColor: scheme.outlineVariant.withValues(alpha: 0.4),
              labelStyle: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        if (showLabels && labels != null && labels!.length == data.length)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs, left: 8),
            child: Row(
              children: <Widget>[
                for (final String label in labels!) ...<Widget>[
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.data,
    required this.stroke,
    required this.gradient,
    required this.showGrid,
    required this.showDots,
    required this.showArea,
    required this.lineWidth,
    required this.gridColor,
    required this.labelStyle,
  });

  final List<double> data;
  final Color stroke;
  final Gradient gradient;
  final bool showGrid;
  final bool showDots;
  final bool showArea;
  final double lineWidth;
  final Color gridColor;
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final double min = data.reduce((double a, double b) => a < b ? a : b);
    final double max = data.reduce((double a, double b) => a > b ? a : b);
    final double range = max - min == 0 ? 1 : max - min;
    const double padTop = 10;
    const double padBottom = 8;

    double yFor(double value) =>
        padTop +
        (1 - (value - min) / range) * (size.height - padTop - padBottom);
    double xFor(int index) =>
        size.width * (data.length == 1 ? 0.5 : index / (data.length - 1));

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    if (showGrid) {
      for (int i = 0; i <= 3; i++) {
        final double y = padTop + (size.height - padTop - padBottom) * i / 3;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    final Path linePath = Path();
    for (int i = 0; i < data.length; i++) {
      final Offset p = Offset(xFor(i), yFor(data[i]));
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
      } else {
        linePath.lineTo(p.dx, p.dy);
      }
    }

    if (showArea && data.isNotEmpty) {
      final Path areaPath = Path.from(linePath)
        ..lineTo(xFor(data.length - 1), size.height - padBottom)
        ..lineTo(xFor(0), size.height - padBottom)
        ..close();
      final Paint areaPaint = Paint()
        ..shader =
            gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(areaPath, areaPaint);
    }

    final Paint strokePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, strokePaint);

    if (showDots) {
      final Paint dotPaint = Paint()..color = stroke;
      final Paint dotFill = Paint()..color = Colors.white;
      for (int i = 0; i < data.length; i++) {
        final Offset p = Offset(xFor(i), yFor(data[i]));
        canvas
          ..drawCircle(p, 3.5, dotFill)
          ..drawCircle(p, 2.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.stroke != stroke ||
      oldDelegate.gradient != gradient ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.showDots != showDots ||
      oldDelegate.showArea != showArea ||
      oldDelegate.lineWidth != lineWidth;
}

/// A grouped/segmented bar chart with optional value labels.
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.data,
    this.labels,
    this.height = 180,
    this.color,
    this.showValues = false,
    this.rounded = true,
    this.valuesColor,
  });

  /// Bar heights (normalized automatically).
  final List<double> data;

  /// Optional category labels.
  final List<String>? labels;

  /// Chart height.
  final double height;

  /// Bar color.
  final Color? color;

  /// Whether to draw value labels above bars.
  final bool showValues;

  /// Whether bars have rounded tops.
  final bool rounded;

  /// Value label color.
  final Color? valuesColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (data.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarChartPainter(
          data: data,
          barColor: color ?? scheme.primary,
          showValues: showValues,
          rounded: rounded,
          valueColor: valuesColor ?? scheme.onSurfaceVariant,
          labelColor: scheme.onSurfaceVariant,
          labels: labels,
          labelStyle: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.data,
    required this.barColor,
    required this.showValues,
    required this.rounded,
    required this.valueColor,
    required this.labelColor,
    required this.labels,
    required this.labelStyle,
  });

  final List<double> data;
  final Color barColor;
  final bool showValues;
  final bool rounded;
  final Color valueColor;
  final Color labelColor;
  final List<String>? labels;
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final double max = data.reduce((double a, double b) => a > b ? a : b);
    final double normalizedMax = max <= 0 ? 1 : max;
    const double bottomPad = 18;
    final double topPad = showValues ? 18 : 6;

    final double slot = size.width / data.length;
    final double barWidth = slot * 0.55;

    for (int i = 0; i < data.length; i++) {
      final double barHeight =
          (data[i] / normalizedMax) * (size.height - bottomPad - topPad);
      final Rect barRect = Rect.fromLTWH(
        i * slot + (slot - barWidth) / 2,
        size.height - bottomPad - barHeight,
        barWidth,
        barHeight,
      );

      final Paint paint = Paint()..color = barColor;
      if (rounded && barHeight > 0) {
        final RRect rrect = RRect.fromRectAndCorners(
          barRect,
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        );
        canvas.drawRRect(rrect, paint);
      } else {
        canvas.drawRect(barRect, paint);
      }

      if (showValues) {
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: data[i].round().toString(),
            style: labelStyle?.copyWith(
              color: valueColor,
              fontWeight: AppFontWeight.semibold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            barRect.center.dx - tp.width / 2,
            barRect.top - tp.height - 2,
          ),
        );
      }

      if (labels != null && i < labels!.length) {
        final String label = labels![i];
        final TextPainter tp = TextPainter(
          text: TextSpan(
              text: label, style: labelStyle?.copyWith(color: labelColor)),
          textDirection: TextDirection.ltr,
          maxLines: 1,
          ellipsis: '…',
        )..layout(maxWidth: slot);
        tp.paint(
          canvas,
          Offset(
            barRect.center.dx - tp.width / 2,
            size.height - bottomPad + 4,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.barColor != barColor ||
      oldDelegate.showValues != showValues ||
      oldDelegate.rounded != rounded;
}

/// A donut/pie chart with legend and optional center label.
class PieChart extends StatelessWidget {
  const PieChart({
    super.key,
    required this.segments,
    this.centerLabel,
    this.centerSubLabel,
    this.size = 160,
    this.showLegend = true,
    this.thickness = 28,
  });

  /// Data segments.
  final List<PieSegment> segments;

  /// Optional center label (e.g. total).
  final String? centerLabel;

  /// Optional center sub label.
  final String? centerSubLabel;

  /// Chart diameter.
  final double size;

  /// Whether to show the legend below.
  final bool showLegend;

  /// Donut ring thickness.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _PieChartPainter(segments: segments, thickness: thickness),
            child: centerLabel == null && centerSubLabel == null
                ? null
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (centerLabel != null)
                          Text(
                            centerLabel!,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: AppFontWeight.bold,
                              color: scheme.onSurface,
                            ),
                          ),
                        if (centerSubLabel != null)
                          Text(
                            centerSubLabel!,
                            style: textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
        if (showLegend)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final PieSegment segment in segments)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: segment.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${segment.label} (${segment.value.round()})',
                        style: textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A single pie/donut chart segment.
class PieSegment {
  const PieSegment({
    required this.value,
    required this.label,
    required this.color,
  });

  /// Segment value.
  final double value;

  /// Segment label.
  final String label;

  /// Segment color.
  final Color color;
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({required this.segments, required this.thickness});

  final List<PieSegment> segments;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final double total =
        segments.fold<double>(0, (double sum, PieSegment s) => sum + s.value);
    if (total <= 0) return;

    final Rect rect = Rect.fromLTWH(
      thickness / 2,
      thickness / 2,
      size.width - thickness,
      size.height - thickness,
    );
    final double radius = (size.width - thickness) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    double startAngle = -1.57079633;
    for (final PieSegment segment in segments) {
      final double sweep = 6.2831853 * segment.value / total;
      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = segment.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweep;
    }

    if (segments.length == 1) {
      canvas.drawCircle(center, radius, Paint()..color = segments.first.color);
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.thickness != thickness;
}

/// A compact sparkline used for mini trends.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.data,
    this.height = 40,
    this.color,
    this.strokeWidth = 2,
    this.fill = true,
  });

  /// Data points.
  final List<double> data;

  /// Sparkline height.
  final double height;

  /// Line color.
  final Color? color;

  /// Stroke width.
  final double strokeWidth;

  /// Whether to fill the area under the line.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: color ?? AppColors.primary,
          strokeWidth: strokeWidth,
          fill: fill,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.fill,
  });

  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool fill;

  @override
  void paint(Canvas canvas, Size size) {
    final double min = data.reduce((double a, double b) => a < b ? a : b);
    final double max = data.reduce((double a, double b) => a > b ? a : b);
    final double range = max - min == 0 ? 1 : max - min;

    Offset pointFor(int i) => Offset(
          size.width * i / (data.length - 1),
          size.height - (data[i] - min) / range * (size.height - 2) - 1,
        );

    final Path path = Path();
    for (int i = 0; i < data.length; i++) {
      final Offset p = pointFor(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    if (fill) {
      final Path area = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              color.withValues(alpha: 0.25),
              color.withValues(alpha: 0.01),
            ],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.fill != fill;
}
