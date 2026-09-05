import 'dart:math';
import 'package:flutter/material.dart';

/// A gradual content-reveal widget (paint-brush/eraser effect).
///
/// Drag across the widget to reveal the content beneath the cover layer.
///
/// ```dart
/// ScratchReveal(
///   coverColor: Colors.grey.shade700,
///   coverChild: Text('Scratch!'),
///   revealChild: Text('You Won!', style: TextStyle(fontSize: 28)),
/// )
/// ```
class ScratchReveal extends StatefulWidget {
  const ScratchReveal({
    super.key,
    required this.revealChild,
    this.coverColor,
    this.coverChild,
    this.brushRadius = 28.0,
    this.width = double.infinity,
    this.height = 160,
    this.onComplete,
    this.completeThreshold = 0.5,
    this.borderRadius,
  });

  final Widget revealChild;
  final Color? coverColor;
  final Widget? coverChild;
  final double brushRadius;
  final double width;
  final double height;
  final VoidCallback? onComplete;
  final double completeThreshold;
  final double? borderRadius;

  @override
  State<ScratchReveal> createState() => _ScratchRevealState();
}

class _ScratchRevealState extends State<ScratchReveal> {
  final List<Offset> _points = [];
  bool _completed = false;
  double _scratchedRatio = 0;

  void _onPan(Offset local) {
    setState(() => _points.add(local));
    _estimateScratch();
  }

  void _estimateScratch() {
    if (_completed) return;
    final area = widget.width * widget.height;
    if (area <= 0) return;
    final r = widget.brushRadius;
    final covered = min(_points.length * pi * r * r, area);
    _scratchedRatio = covered / area;
    if (_scratchedRatio >= widget.completeThreshold) {
      _completed = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverColor =
        widget.coverColor ?? Theme.of(context).colorScheme.outlineVariant;
    final br = widget.borderRadius ?? 16.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(br),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Positioned.fill(child: widget.revealChild),
            if (!_completed)
              Positioned.fill(
                child: GestureDetector(
                  onPanUpdate: (d) => _onPan(d.localPosition),
                  child: CustomPaint(
                    painter: _ScratchPainter(
                      points: _points,
                      coverColor: coverColor,
                      brushRadius: widget.brushRadius,
                      coverChild: widget.coverChild,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  _ScratchPainter({
    required this.points,
    required this.coverColor,
    required this.brushRadius,
    this.coverChild,
  });

  final List<Offset> points;
  final Color coverColor;
  final double brushRadius;
  final Widget? coverChild;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..saveLayer(Offset.zero & size, Paint())
      ..drawRect(
        Offset.zero & size,
        Paint()..color = coverColor,
      );

    // Erase scratched areas
    final erasePaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;
    for (final p in points) {
      canvas.drawCircle(p, brushRadius, erasePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScratchPainter old) =>
      old.points.length != points.length;
}
