import 'package:flutter/material.dart';

/// An interactive before/after image comparison slider.
///
/// ```dart
/// BeforeAfterImage(
///   before: Image.asset('assets/before.jpg'),
///   after: Image.asset('assets/after.jpg'),
///   direction: Axis.horizontal,
/// )
/// ```
class BeforeAfterImage extends StatefulWidget {
  const BeforeAfterImage({
    super.key,
    required this.before,
    required this.after,
    this.initialPosition = 0.5,
    this.direction = Axis.horizontal,
    this.dividerColor = Colors.white,
    this.dividerWidth = 3.0,
    this.handleRadius = 18.0,
    this.handleColor = Colors.white,
    this.handleIconColor = Colors.black87,
    this.borderRadius,
    this.beforeLabel,
    this.afterLabel,
  });

  final Widget before;
  final Widget after;
  final double initialPosition;
  final Axis direction;
  final Color dividerColor;
  final double dividerWidth;
  final double handleRadius;
  final Color handleColor;
  final Color handleIconColor;
  final BorderRadius? borderRadius;
  final Widget? beforeLabel;
  final Widget? afterLabel;

  @override
  State<BeforeAfterImage> createState() => _BeforeAfterImageState();
}

class _BeforeAfterImageState extends State<BeforeAfterImage> {
  late double _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition.clamp(0.0, 1.0);
  }

  void _updatePosition(Offset localPosition, Size size) {
    setState(() {
      if (widget.direction == Axis.horizontal) {
        _position = (localPosition.dx / size.width).clamp(0.0, 1.0);
      } else {
        _position = (localPosition.dy / size.height).clamp(0.0, 1.0);
      }
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
              constraints.maxHeight.isFinite ? constraints.maxHeight : 300);

          return GestureDetector(
            onHorizontalDragUpdate: widget.direction == Axis.horizontal
                ? (d) => _updatePosition(d.localPosition, size)
                : null,
            onVerticalDragUpdate: widget.direction == Axis.vertical
                ? (d) => _updatePosition(d.localPosition, size)
                : null,
            onTapDown: (d) => _updatePosition(d.localPosition, size),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // After Image (Base)
                  widget.after,

                  // Before Image (Clipped)
                  ClipPath(
                    clipper: _BeforeClipper(
                      position: _position,
                      direction: widget.direction,
                    ),
                    child: widget.before,
                  ),

                  // Divider Line
                  CustomPaint(
                    size: size,
                    painter: _DividerPainter(
                      position: _position,
                      direction: widget.direction,
                      color: widget.dividerColor,
                      width: widget.dividerWidth,
                    ),
                  ),

                  // Drag Handle
                  if (widget.direction == Axis.horizontal)
                    Positioned(
                      left: size.width * _position - widget.handleRadius,
                      top: size.height / 2 - widget.handleRadius,
                      child: _buildHandle(),
                    )
                  else
                    Positioned(
                      left: size.width / 2 - widget.handleRadius,
                      top: size.height * _position - widget.handleRadius,
                      child: _buildHandle(),
                    ),

                  // Labels
                  if (widget.beforeLabel != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: widget.beforeLabel!,
                    ),
                  if (widget.afterLabel != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: widget.afterLabel!,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() => Container(
        width: widget.handleRadius * 2,
        height: widget.handleRadius * 2,
        decoration: BoxDecoration(
          color: widget.handleColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(
          widget.direction == Axis.horizontal
              ? Icons.code_rounded
              : Icons.unfold_more_rounded,
          size: widget.handleRadius * 1.1,
          color: widget.handleIconColor,
        ),
      );
}

class _BeforeClipper extends CustomClipper<Path> {
  _BeforeClipper({required this.position, required this.direction});

  final double position;
  final Axis direction;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (direction == Axis.horizontal) {
      path.addRect(Rect.fromLTWH(0, 0, size.width * position, size.height));
    } else {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height * position));
    }
    return path;
  }

  @override
  bool shouldReclip(_BeforeClipper oldClipper) =>
      oldClipper.position != position || oldClipper.direction != direction;
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({
    required this.position,
    required this.direction,
    required this.color,
    required this.width,
  });

  final double position;
  final Axis direction;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    if (direction == Axis.horizontal) {
      final x = size.width * position;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    } else {
      final y = size.height * position;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DividerPainter old) =>
      old.position != position ||
      old.direction != direction ||
      old.color != color ||
      old.width != width;
}
