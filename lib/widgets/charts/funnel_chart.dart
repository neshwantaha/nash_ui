import 'package:flutter/material.dart';

/// Represents a single stage in a [FunnelChart].
class FunnelStage {
  const FunnelStage({
    required this.label,
    required this.value,
    this.color,
    this.percentage,
  });

  final String label;
  final double value;
  final Color? color;
  final double? percentage;
}

/// A funnel chart widget for visualizing conversion stages, sales pipelines,
/// and sequential drop-off rates.
class FunnelChart extends StatelessWidget {
  const FunnelChart({
    super.key,
    required this.stages,
    this.height = 240,
    this.spacing = 4.0,
    this.borderRadius = 6.0,
    this.valueFormatter,
  });

  final List<FunnelStage> stages;
  final double height;
  final double spacing;
  final double borderRadius;
  final String Function(double)? valueFormatter;

  static const List<Color> _defaultPalette = [
    Color(0xFF6C63FF),
    Color(0xFF8B80F9),
    Color(0xFFAA9EFA),
    Color(0xFFC8BCFB),
    Color(0xFFE5DAFC),
  ];

  @override
  Widget build(BuildContext context) {
    final n = stages.length;
    if (n == 0) return const SizedBox.shrink();

    final maxVal = stages.first.value > 0 ? stages.first.value : 1.0;
    final totalSpacing = (n - 1) * spacing;
    final stageHeight = (height - totalSpacing) / n;

    return SizedBox(
      height: height,
      child: Column(
        children: List.generate(n, (i) {
          final stage = stages[i];
          final topWidthFraction =
              i == 0 ? 1.0 : (stages[i - 1].value / maxVal).clamp(0.2, 1.0);
          final bottomWidthFraction = (stage.value / maxVal).clamp(0.2, 1.0);
          final color =
              stage.color ?? _defaultPalette[i % _defaultPalette.length];
          final formattedVal = valueFormatter != null
              ? valueFormatter!(stage.value)
              : stage.value.toStringAsFixed(0);

          return Padding(
            padding: EdgeInsets.only(bottom: i < n - 1 ? spacing : 0),
            child: SizedBox(
              height: stageHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(double.infinity, stageHeight),
                    painter: _FunnelStagePainter(
                      topFraction: topWidthFraction,
                      bottomFraction: bottomWidthFraction,
                      color: color,
                      borderRadius: borderRadius,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stage.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '$formattedVal${stage.percentage != null ? ' (${stage.percentage!.toStringAsFixed(1)}%)' : ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FunnelStagePainter extends CustomPainter {
  _FunnelStagePainter({
    required this.topFraction,
    required this.bottomFraction,
    required this.color,
    required this.borderRadius,
  });

  final double topFraction;
  final double bottomFraction;
  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final topInset = (w * (1 - topFraction)) / 2;
    final bottomInset = (w * (1 - bottomFraction)) / 2;

    final path = Path()
      ..moveTo(topInset, 0)
      ..lineTo(w - topInset, 0)
      ..lineTo(w - bottomInset, h)
      ..lineTo(bottomInset, h)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FunnelStagePainter old) =>
      old.topFraction != topFraction ||
      old.bottomFraction != bottomFraction ||
      old.color != color;
}
