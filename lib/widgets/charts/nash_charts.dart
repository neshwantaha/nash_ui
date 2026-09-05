import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../colors/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// A single data point for line/area charts.
class ChartPoint {
  const ChartPoint(this.x, this.y);
  final double x;
  final double y;
}

/// A single bar in a bar chart.
class BarData {
  const BarData({required this.label, required this.value, this.color});
  final String label;
  final double value;
  final Color? color;
}

/// A pie/donut segment.
class PieSegment {
  const PieSegment({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final double value;
  final Color color;
}

// ─────────────────────────────────────────────────────────────────────────────
// LineChart — Smooth bezier line chart
// ─────────────────────────────────────────────────────────────────────────────

/// Animated smooth line chart with optional area fill and data point dots.
///
/// ```dart
/// LineChart(
///   points: [ChartPoint(0, 10), ChartPoint(1, 45), ChartPoint(2, 30)],
///   labels: ['Jan', 'Feb', 'Mar'],
/// )
/// ```
class LineChart extends StatefulWidget {
  const LineChart({
    super.key,
    required this.points,
    this.labels = const [],
    this.color,
    this.showArea = true,
    this.showDots = true,
    this.showGrid = true,
    this.height = 200,
    this.animate = true,
    this.strokeWidth = 2.5,
  });

  /// Convenience constructor — accepts a plain [List<double>] and converts
  /// each value to a [ChartPoint] using its index as the x coordinate.
  factory LineChart.fromData({
    Key? key,
    required List<double> data,
    List<String> labels = const [],
    Color? color,
    bool showArea = true,
    bool showDots = true,
    bool showGrid = true,
    double height = 200,
    bool animate = true,
    double strokeWidth = 2.5,
  }) =>
      LineChart(
        key: key,
        points: <ChartPoint>[
          for (int i = 0; i < data.length; i++)
            ChartPoint(i.toDouble(), data[i]),
        ],
        labels: labels,
        color: color,
        showArea: showArea,
        showDots: showDots,
        showGrid: showGrid,
        height: height,
        animate: animate,
        strokeWidth: strokeWidth,
      );

  final List<ChartPoint> points;
  final List<String> labels;
  final Color? color;
  final bool showArea;
  final bool showDots;
  final bool showGrid;
  final double height;
  final bool animate;
  final double strokeWidth;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => CustomPaint(
        size: Size(double.infinity, widget.height),
        painter: _LineChartPainter(
          points: widget.points,
          labels: widget.labels,
          color: color,
          showArea: widget.showArea,
          showDots: widget.showDots,
          showGrid: widget.showGrid,
          progress: widget.animate ? _anim.value : 1.0,
          strokeWidth: widget.strokeWidth,
          isDark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.labels,
    required this.color,
    required this.showArea,
    required this.showDots,
    required this.showGrid,
    required this.progress,
    required this.strokeWidth,
    required this.isDark,
  });

  final List<ChartPoint> points;
  final List<String> labels;
  final Color color;
  final bool showArea;
  final bool showDots;
  final bool showGrid;
  final double progress;
  final double strokeWidth;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const padding = EdgeInsets.fromLTRB(40, 16, 16, 32);
    final chartRect = Rect.fromLTRB(
      padding.left,
      padding.top,
      size.width - padding.right,
      size.height - padding.bottom,
    );

    final minY = points.map((p) => p.y).reduce(math.min);
    final maxY = points.map((p) => p.y).reduce(math.max);
    final minX = points.map((p) => p.x).reduce(math.min);
    final maxX = points.map((p) => p.x).reduce(math.max);
    final yRange = maxY - minY == 0 ? 1.0 : maxY - minY;
    final xRange = maxX - minX == 0 ? 1.0 : maxX - minX;

    Offset toCanvas(ChartPoint p) => Offset(
          chartRect.left + (p.x - minX) / xRange * chartRect.width,
          chartRect.bottom - (p.y - minY) / yRange * chartRect.height,
        );

    // Grid lines
    if (showGrid) {
      final gridPaint = Paint()
        ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.07)
        ..strokeWidth = 1;
      for (int i = 0; i <= 4; i++) {
        final y = chartRect.top + (chartRect.height / 4) * i;
        canvas.drawLine(
            Offset(chartRect.left, y), Offset(chartRect.right, y), gridPaint);
      }
    }

    // Y-axis labels
    final textStyle = TextStyle(
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4),
      fontSize: 10,
    );
    for (int i = 0; i <= 4; i++) {
      final value = maxY - (yRange / 4) * i;
      final y = chartRect.top + (chartRect.height / 4) * i;
      _drawText(canvas, value.toStringAsFixed(0), Offset(0, y - 6), textStyle);
    }

    // Clip to progress
    final visibleWidth = chartRect.left + chartRect.width * progress;
    canvas.clipRect(Rect.fromLTRB(0, 0, visibleWidth, size.height));

    // Build path
    final path = Path();
    final allOffsets = points.map(toCanvas).toList();
    path.moveTo(allOffsets.first.dx, allOffsets.first.dy);
    for (int i = 0; i < allOffsets.length - 1; i++) {
      final cp1 = Offset(
        (allOffsets[i].dx + allOffsets[i + 1].dx) / 2,
        allOffsets[i].dy,
      );
      final cp2 = Offset(
        (allOffsets[i].dx + allOffsets[i + 1].dx) / 2,
        allOffsets[i + 1].dy,
      );
      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        allOffsets[i + 1].dx,
        allOffsets[i + 1].dy,
      );
    }

    // Area fill
    if (showArea) {
      final areaPath = Path.from(path)
        ..lineTo(allOffsets.last.dx, chartRect.bottom)
        ..lineTo(allOffsets.first.dx, chartRect.bottom)
        ..close();
      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
          ).createShader(chartRect),
      );
    }

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots
    if (showDots) {
      final dotPaint = Paint()..color = color;
      final innerDotPaint = Paint()..color = Colors.white;
      for (final o in allOffsets) {
        canvas
          ..drawCircle(o, 4, dotPaint)
          ..drawCircle(o, 2.5, innerDotPaint);
      }
    }

    // X labels
    if (labels.isNotEmpty) {
      for (int i = 0; i < math.min(labels.length, points.length); i++) {
        final o = allOffsets[i];
        _drawText(
          canvas,
          labels[i],
          Offset(o.dx - 12, chartRect.bottom + 4),
          textStyle,
        );
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.progress != progress || old.points != points;
}

// ─────────────────────────────────────────────────────────────────────────────
// BarChart
// ─────────────────────────────────────────────────────────────────────────────

/// Animated vertical bar chart with colored bars and labels.
class BarChart extends StatefulWidget {
  const BarChart({
    super.key,
    required this.bars,
    this.height = 200,
    this.barRadius = 6,
    this.showGrid = true,
    this.animate = true,
  });

  final List<BarData> bars;
  final double height;
  final double barRadius;
  final bool showGrid;
  final bool animate;

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColors = [
      scheme.primary,
      AppColors.violet,
      AppColors.emerald,
      AppColors.amber,
      AppColors.rose,
      AppColors.cyan,
    ];

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxVal = widget.bars.map((b) => b.value).reduce(math.max);
            final chartH = widget.height - 32;

            return Stack(
              children: [
                // Grid
                if (widget.showGrid)
                  CustomPaint(
                    size: Size(constraints.maxWidth, widget.height - 32),
                    painter: _GridPainter(isDark: isDark),
                  ),
                // Bars + labels
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < widget.bars.length; i++) ...[
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: Duration.zero,
                                height: (widget.bars[i].value / maxVal) *
                                    chartH *
                                    _anim.value,
                                decoration: BoxDecoration(
                                  color: widget.bars[i].color ??
                                      defaultColors[i % defaultColors.length],
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(widget.barRadius),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.bars[i].label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: (isDark ? Colors.white : Colors.black)
                                      .withValues(alpha: 0.5),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.07)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// PieChart
// ─────────────────────────────────────────────────────────────────────────────

/// Animated donut/pie chart with legend.
class PieChart extends StatefulWidget {
  const PieChart({
    super.key,
    required this.segments,
    this.size = 180,
    this.donutHole = 0.55,
    this.animate = true,
    this.showLegend = true,
    this.centerLabel,
    this.centerSubLabel,
  });

  final List<PieSegment> segments;
  final double size;

  /// 0 = pie, 0.55 = donut.
  final double donutHole;
  final bool animate;
  final bool showLegend;

  /// Text displayed in the center hole (donut charts).
  final String? centerLabel;

  /// Sub-text displayed below [centerLabel].
  final String? centerSubLabel;

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _PieChartPainter(
                segments: widget.segments,
                donutHole: widget.donutHole,
                progress: _anim.value,
              ),
            ),
            if (widget.showLegend) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: widget.segments
                    .map((s) => _LegendItem(segment: s))
                    .toList(),
              ),
            ],
          ],
        ),
      );
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.segments,
    required this.donutHole,
    required this.progress,
  });

  final List<PieSegment> segments;
  final double donutHole;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -math.pi / 2;
    double currentAngle = startAngle;

    for (final seg in segments) {
      final sweepAngle = (seg.value / total) * 2 * math.pi * progress;
      canvas.drawArc(
        rect,
        currentAngle,
        sweepAngle,
        true,
        Paint()..color = seg.color,
      );
      currentAngle += sweepAngle;
    }

    // Donut hole
    if (donutHole > 0) {
      final center = Offset(size.width / 2, size.height / 2);
      final radius = size.width / 2 * donutHole;
      canvas
        ..drawCircle(
          center,
          radius,
          Paint()
            ..color = Colors.transparent
            ..blendMode = BlendMode.clear,
        )
        ..drawCircle(
          center,
          radius,
          Paint()..color = Colors.transparent,
        );
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter old) => old.progress != progress;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.segment});
  final PieSegment segment;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            segment.label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sparkline — Mini inline chart for dashboard cards
// ─────────────────────────────────────────────────────────────────────────────

/// A compact sparkline chart suitable for embedding in dashboard cards.
///
/// ```dart
/// Sparkline(data: [10, 45, 30, 70, 55, 90])
/// ```
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.data,
    this.color,
    this.height = 40,
    this.width = 100,
    this.strokeWidth = 2,
    this.showArea = true,
  });

  final List<double> data;
  final Color? color;
  final double height;
  final double width;
  final double strokeWidth;
  final bool showArea;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(
          data: data, color: c, strokeWidth: strokeWidth, showArea: showArea),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.showArea,
  });

  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool showArea;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final minY = data.reduce(math.min);
    final maxY = data.reduce(math.max);
    final yRange = maxY - minY == 0 ? 1.0 : maxY - minY;
    final step = size.width / (data.length - 1);

    Offset toOff(int i) => Offset(
          step * i,
          size.height - ((data[i] - minY) / yRange * size.height),
        );

    final path = Path()..moveTo(toOff(0).dx, toOff(0).dy);
    for (int i = 1; i < data.length; i++) {
      path.lineTo(toOff(i).dx, toOff(i).dy);
    }

    if (showArea) {
      final areaPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.data != data;
}

// ─────────────────────────────────────────────────────────────────────────────
// AreaChart — Filled area chart
// ─────────────────────────────────────────────────────────────────────────────

/// Same as [LineChart] but with a prominent area fill — useful for
/// comparing two overlaid datasets.
class AreaChart extends StatelessWidget {
  const AreaChart({
    super.key,
    required this.points,
    this.labels = const [],
    this.color,
    this.height = 200,
    this.animate = true,
  });

  final List<ChartPoint> points;
  final List<String> labels;
  final Color? color;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) => LineChart(
        points: points,
        labels: labels,
        color: color,
        showDots: false,
        height: height,
        animate: animate,
        strokeWidth: 1.5,
      );
}
