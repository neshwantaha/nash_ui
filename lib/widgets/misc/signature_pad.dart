import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A free-hand signature drawing widget.
///
/// ```dart
/// final _sigKey = GlobalKey<SignaturePadState>();
///
/// SignaturePad(key: _sigKey, penColor: Colors.black, strokeWidth: 3)
///
/// // Clear
/// _sigKey.currentState?.clear();
///
/// // Export as PNG bytes
/// final bytes = await _sigKey.currentState?.toImageBytes();
/// ```
class SignaturePad extends StatefulWidget {
  const SignaturePad({
    super.key,
    this.penColor = Colors.black,
    this.strokeWidth = 3.0,
    this.backgroundColor = Colors.white,
    this.borderRadius,
    this.border,
    this.width,
    this.height = 200,
    this.onChanged,
  });

  final Color penColor;
  final double strokeWidth;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double? width;
  final double height;

  /// Called whenever the pad content changes.
  final VoidCallback? onChanged;

  @override
  State<SignaturePad> createState() => SignaturePadState();
}

class SignaturePadState extends State<SignaturePad> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _current;

  bool get isEmpty => _strokes.isEmpty;

  void clear() => setState(_strokes.clear);

  /// Renders the signature as a [ui.Image].
  Future<ui.Image?> toImage() async {
    if (_strokes.isEmpty) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = context.size ?? const Size(300, 200);
    final paint = Paint()
      ..color = widget.penColor
      ..strokeWidth = widget.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = widget.backgroundColor,
    );

    for (final stroke in _strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, widget.strokeWidth / 2, paint);
      } else {
        final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  /// Returns PNG bytes of the signature, or null if empty.
  Future<List<int>?> toImageBytes() async {
    final img = await toImage();
    if (img == null) return null;
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List().toList();
  }

  void _onPanStart(DragStartDetails d) {
    _current = [d.localPosition];
    _strokes.add(_current!);
    setState(() {});
    widget.onChanged?.call();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    _current?.add(d.localPosition);
    setState(() {});
  }

  void _onPanEnd(DragEndDetails _) {
    _current = null;
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            border: widget.border ??
                Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: CustomPaint(
              painter: _SignaturePainter(
                strokes: _strokes,
                penColor: widget.penColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),
        ),
      );
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter({
    required this.strokes,
    required this.penColor,
    required this.strokeWidth,
  });

  final List<List<Offset>> strokes;
  final Color penColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = penColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, strokeWidth / 2, paint);
      } else {
        final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => true;
}
