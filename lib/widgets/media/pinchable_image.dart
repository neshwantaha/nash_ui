import 'package:flutter/material.dart';

/// An interactive image viewer supporting pinch-to-zoom, panning,
/// double-tap zoom, and smooth spring-back animation on release.
///
/// ```dart
/// PinchableImage(
///   image: NetworkImage('https://example.com/photo.jpg'),
///   maxScale: 4.0,
/// )
/// ```
class PinchableImage extends StatefulWidget {
  const PinchableImage({
    super.key,
    required this.image,
    this.minScale = 1.0,
    this.maxScale = 3.5,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.borderRadius,
    this.onDoubleTap,
  });

  /// The image provider to render.
  final ImageProvider image;

  /// Minimum allowed scale factor (default: 1.0).
  final double minScale;

  /// Maximum allowed scale factor (default: 3.5).
  final double maxScale;

  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onDoubleTap;

  @override
  State<PinchableImage> createState() => _PinchableImageState();
}

class _PinchableImageState extends State<PinchableImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late AnimationController _animCtrl;
  Animation<Matrix4>? _anim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_anim != null) {
          _controller.value = _anim!.value;
        }
      });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    widget.onDoubleTap?.call();
    final currentScale = _controller.value.getMaxScaleOnAxis();
    final targetMatrix = (currentScale > 1.2)
        ? Matrix4.identity()
        : Matrix4.diagonal3Values(2.5, 2.5, 1.0);

    _anim = Matrix4Tween(
      begin: _controller.value,
      end: targetMatrix,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));

    _animCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        clipBehavior: Clip.antiAlias,
        child: Image(
          image: widget.image,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );

    if (widget.borderRadius != null) {
      content = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: content,
      );
    }

    return content;
  }
}
