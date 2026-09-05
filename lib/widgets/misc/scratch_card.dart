import 'package:flutter/material.dart';

/// An interactive scratch-to-reveal card for coupons, rewards, and giveaways.
///
/// ```dart
/// ScratchCard(
///   child: Container(
///     color: Colors.amber,
///     child: Center(child: Text('YOU WON \$500!')),
///   ),
///   scratchColor: Colors.grey.shade400,
///   threshold: 0.5,
///   onThresholdReached: () => print('Revealed!'),
/// )
/// ```
class ScratchCard extends StatefulWidget {
  const ScratchCard({
    super.key,
    required this.child,
    this.scratchColor = const Color(0xFFB0BEC5),
    this.brushSize = 25.0,
    this.threshold = 0.5,
    this.onThresholdReached,
    this.borderRadius,
    this.overlay,
  });

  final Widget child;
  final Color scratchColor;
  final double brushSize;
  final double threshold;
  final VoidCallback? onThresholdReached;
  final BorderRadius? borderRadius;
  final Widget? overlay;

  @override
  State<ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  final List<Offset> _points = [];
  bool _revealed = false;

  void _addPoint(Offset point, Size size) {
    if (_revealed) return;
    setState(() => _points.add(point));

    // Approximate scratched area calculation
    final totalArea = size.width * size.height;
    final scratchedArea =
        _points.length * (widget.brushSize * widget.brushSize * 0.7);
    if (scratchedArea / totalArea >= widget.threshold && !_revealed) {
      _revealed = true;
      widget.onThresholdReached?.call();
    }
  }

  void reset() {
    setState(() {
      _points.clear();
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: br,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth,
              constraints.maxHeight.isFinite ? constraints.maxHeight : 200);

          return GestureDetector(
            onPanStart: (d) => _addPoint(d.localPosition, size),
            onPanUpdate: (d) => _addPoint(d.localPosition, size),
            child: Stack(
              children: [
                // Hidden Child
                widget.child,

                // Scratch Overlay
                if (!_revealed)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ScratchPainter(
                        points: _points,
                        scratchColor: widget.scratchColor,
                        brushSize: widget.brushSize,
                      ),
                      child: widget.overlay,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  _ScratchPainter({
    required this.points,
    required this.scratchColor,
    required this.brushSize,
  });

  final List<Offset> points;
  final Color scratchColor;
  final double brushSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..saveLayer(Offset.zero & size, Paint())
      ..drawRect(Offset.zero & size, Paint()..color = scratchColor);

    // Erase scratched paths
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if ((points[i] - points[i + 1]).distance < brushSize * 2) {
        canvas.drawLine(points[i], points[i + 1], clearPaint);
      } else {
        canvas.drawCircle(points[i], brushSize / 2, clearPaint);
      }
    }

    if (points.isNotEmpty) {
      canvas.drawCircle(points.last, brushSize / 2, clearPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScratchPainter old) => true;
}
