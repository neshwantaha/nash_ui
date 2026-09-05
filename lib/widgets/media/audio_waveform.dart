import 'package:flutter/material.dart';

/// An interactive audio waveform visualizer for voice notes and music players.
///
/// ```dart
/// AudioWaveform(
///   amplitudes: [0.2, 0.5, 0.8, 0.4, 0.9, 0.3, 0.7],
///   progress: 0.45,
///   onSeek: (pos) => print('Seek to: $pos'),
/// )
/// ```
class AudioWaveform extends StatelessWidget {
  const AudioWaveform({
    super.key,
    required this.amplitudes,
    this.progress = 0.0,
    this.playedColor = const Color(0xFF6366F1),
    this.unplayedColor = const Color(0xFFCBD5E1),
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.barRadius = 2.0,
    this.height = 48.0,
    this.onSeek,
  });

  final List<double> amplitudes;
  final double progress;
  final Color playedColor;
  final Color unplayedColor;
  final double barWidth;
  final double barSpacing;
  final double barRadius;
  final double height;
  final ValueChanged<double>? onSeek;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: onSeek != null
            ? (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final ratio =
                      (d.localPosition.dx / box.size.width).clamp(0.0, 1.0);
                  onSeek!(ratio);
                }
              }
            : null,
        onHorizontalDragUpdate: onSeek != null
            ? (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final ratio =
                      (d.localPosition.dx / box.size.width).clamp(0.0, 1.0);
                  onSeek!(ratio);
                }
              }
            : null,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _WaveformPainter(
              amplitudes: amplitudes,
              progress: progress.clamp(0.0, 1.0),
              playedColor: playedColor,
              unplayedColor: unplayedColor,
              barWidth: barWidth,
              barSpacing: barSpacing,
              barRadius: barRadius,
            ),
          ),
        ),
      );
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.amplitudes,
    required this.progress,
    required this.playedColor,
    required this.unplayedColor,
    required this.barWidth,
    required this.barSpacing,
    required this.barRadius,
  });

  final List<double> amplitudes;
  final double progress;
  final Color playedColor;
  final Color unplayedColor;
  final double barWidth;
  final double barSpacing;
  final double barRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final totalBarStep = barWidth + barSpacing;
    final maxBars = (size.width / totalBarStep).floor();
    final barsToDraw = mathMin(amplitudes.length, maxBars);

    final playedBarsCount = (barsToDraw * progress).round();

    for (int i = 0; i < barsToDraw; i++) {
      final amp = amplitudes[i].clamp(0.05, 1.0);
      final barHeight = size.height * amp;
      final x = i * totalBarStep;
      final y = (size.height - barHeight) / 2;

      final paint = Paint()
        ..color = i < playedBarsCount ? playedColor : unplayedColor
        ..style = PaintingStyle.fill;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barRadius),
      );

      canvas.drawRRect(rrect, paint);
    }
  }

  int mathMin(int a, int b) => a < b ? a : b;

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.progress != progress ||
      old.amplitudes != amplitudes ||
      old.playedColor != playedColor ||
      old.unplayedColor != unplayedColor;
}
