import 'package:flutter/material.dart';

/// A 9-dot pattern lock widget for security and PIN setups.
///
/// ```dart
/// PatternLock(
///   dimension: 3,
///   onComplete: (pattern) {
///     print('Drawn pattern: $pattern'); // e.g. [0, 1, 2, 5, 8]
///   },
/// )
/// ```
class PatternLock extends StatefulWidget {
  const PatternLock({
    super.key,
    this.dimension = 3,
    required this.onComplete,
    this.selectedColor,
    this.dotColor,
    this.lineColor,
    this.dotRadius = 10.0,
    this.lineWidth = 4.0,
    this.size = 280.0,
    this.enableFeedback = true,
  });

  final int dimension;
  final void Function(List<int> pattern) onComplete;
  final Color? selectedColor;
  final Color? dotColor;
  final Color? lineColor;
  final double dotRadius;
  final double lineWidth;
  final double size;
  final bool enableFeedback;

  @override
  State<PatternLock> createState() => _PatternLockState();
}

class _PatternLockState extends State<PatternLock> {
  final List<int> _selected = [];
  Offset? _currentTouch;

  List<Offset> _calculateDotCenters(Size size) {
    final centers = <Offset>[];
    final stepX = size.width / (widget.dimension + 1);
    final stepY = size.height / (widget.dimension + 1);
    for (int r = 0; r < widget.dimension; r++) {
      for (int c = 0; c < widget.dimension; c++) {
        centers.add(Offset(stepX * (c + 1), stepY * (r + 1)));
      }
    }
    return centers;
  }

  int? _findTouchedDot(Offset touch, List<Offset> centers) {
    for (int i = 0; i < centers.length; i++) {
      if ((touch - centers[i]).distance <= widget.dotRadius * 2.5) {
        return i;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails d, Size size) {
    _selected.clear();
    final centers = _calculateDotCenters(size);
    final touched = _findTouchedDot(d.localPosition, centers);
    if (touched != null) {
      _selected.add(touched);
    }
    _currentTouch = d.localPosition;
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails d, Size size) {
    final centers = _calculateDotCenters(size);
    final touched = _findTouchedDot(d.localPosition, centers);
    if (touched != null && !_selected.contains(touched)) {
      _selected.add(touched);
    }
    _currentTouch = d.localPosition;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails _, Size size) {
    _currentTouch = null;
    setState(() {});
    if (_selected.isNotEmpty) {
      widget.onComplete(List.unmodifiable(_selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.selectedColor ?? theme.colorScheme.primary;
    final defaultDotColor = widget.dotColor ?? theme.colorScheme.outlineVariant;
    final defaultLineColor = widget.lineColor ?? activeColor.withAlpha(180);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final centers = _calculateDotCenters(size);

          return GestureDetector(
            onPanStart: (d) => _onPanStart(d, size),
            onPanUpdate: (d) => _onPanUpdate(d, size),
            onPanEnd: (d) => _onPanEnd(d, size),
            child: CustomPaint(
              size: size,
              painter: _PatternPainter(
                centers: centers,
                selected: _selected,
                currentTouch: _currentTouch,
                dotColor: defaultDotColor,
                selectedColor: activeColor,
                lineColor: defaultLineColor,
                dotRadius: widget.dotRadius,
                lineWidth: widget.lineWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({
    required this.centers,
    required this.selected,
    required this.currentTouch,
    required this.dotColor,
    required this.selectedColor,
    required this.lineColor,
    required this.dotRadius,
    required this.lineWidth,
  });

  final List<Offset> centers;
  final List<int> selected;
  final Offset? currentTouch;
  final Color dotColor;
  final Color selectedColor;
  final Color lineColor;
  final double dotRadius;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw connected lines
    if (selected.length > 1) {
      final path = Path()
        ..moveTo(centers[selected.first].dx, centers[selected.first].dy);
      for (int i = 1; i < selected.length; i++) {
        path.lineTo(centers[selected[i]].dx, centers[selected[i]].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw active finger drag line
    if (selected.isNotEmpty && currentTouch != null) {
      canvas.drawLine(centers[selected.last], currentTouch!, linePaint);
    }

    // Draw dots
    for (int i = 0; i < centers.length; i++) {
      final isSelected = selected.contains(i);
      final center = centers[i];

      final dotPaint = Paint()
        ..color = isSelected ? selectedColor : dotColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, dotRadius, dotPaint);

      if (isSelected) {
        final ringPaint = Paint()
          ..color = selectedColor.withAlpha(80)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(center, dotRadius * 2, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_PatternPainter old) => true;
}
