import 'dart:math';
import 'package:flutter/material.dart';

/// A liquid wave progress bar using CustomPainter.
class LiquidProgressBar extends StatefulWidget {
  const LiquidProgressBar({
    super.key,
    required this.value,
    this.height = 56,
    this.borderRadius,
    this.waveColor,
    this.backgroundColor,
    this.labelStyle,
    this.showLabel = true,
    this.animate = true,
    this.waveCount = 2,
  });

  /// Progress value from 0.0 to 1.0.
  final double value;
  final double height;
  final BorderRadius? borderRadius;
  final Color? waveColor;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final bool showLabel;
  final bool animate;
  final int waveCount;

  @override
  State<LiquidProgressBar> createState() => _LiquidProgressBarState();
}

class _LiquidProgressBarState extends State<LiquidProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.animate) {
      _waveController.repeat();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveColor = widget.waveColor ?? theme.colorScheme.primary;
    final bg =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final br = widget.borderRadius ?? BorderRadius.circular(widget.height / 2);

    return ClipRRect(
      borderRadius: br,
      child: Container(
        height: widget.height,
        color: bg,
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (_, __) => CustomPaint(
            painter: _LiquidPainter(
              progress: widget.value.clamp(0, 1),
              wavePhase: _waveController.value,
              waveColor: waveColor,
              waveCount: widget.waveCount,
            ),
            child: widget.showLabel
                ? Center(
                    child: Text(
                      '${(widget.value * 100).round()}%',
                      style: widget.labelStyle ??
                          theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.value > 0.5
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({
    required this.progress,
    required this.wavePhase,
    required this.waveColor,
    required this.waveCount,
  });

  final double progress;
  final double wavePhase;
  final Color waveColor;
  final int waveCount;

  @override
  void paint(Canvas canvas, Size size) {
    final fillY = size.height * (1 - progress);
    final waveH = size.height * 0.08;

    final path = Path()..moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = fillY +
          sin((x / size.width * waveCount * 2 * pi) + (wavePhase * 2 * pi)) *
              waveH;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()..color = waveColor;
    canvas.drawPath(path, paint);

    // Secondary wave (slightly offset)
    final path2 = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = fillY +
          sin((x / size.width * waveCount * 2 * pi) +
                  (wavePhase * 2 * pi) +
                  pi / 2) *
              (waveH * 0.6);
      if (x == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path2, Paint()..color = waveColor.withAlpha(80));
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter old) =>
      old.progress != progress || old.wavePhase != wavePhase;
}
