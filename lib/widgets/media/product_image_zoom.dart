import 'package:flutter/material.dart';

/// An interactive product image zoom widget.
/// Long-press or pinch to magnify the image.
class ProductImageZoom extends StatefulWidget {
  const ProductImageZoom({
    super.key,
    required this.imageProvider,
    this.width,
    this.height = 300,
    this.borderRadius = 12.0,
    this.maxScale = 4.0,
    this.minScale = 1.0,
  });

  final ImageProvider imageProvider;
  final double? width;
  final double height;
  final double borderRadius;
  final double maxScale;
  final double minScale;

  @override
  State<ProductImageZoom> createState() => _ProductImageZoomState();
}

class _ProductImageZoomState extends State<ProductImageZoom>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformCtrl;
  late AnimationController _resetCtrl;
  Animation<Matrix4>? _resetAnim;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transformCtrl = TransformationController();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onDoubleTap(TapDownDetails details) {
    if (_zoomed) {
      _resetAnim = Matrix4Tween(
        begin: _transformCtrl.value,
        end: Matrix4.identity(),
      ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut));
      _resetCtrl.forward(from: 0);
      _resetAnim!.addListener(() {
        _transformCtrl.value = _resetAnim!.value;
      });
      _zoomed = false;
    } else {
      final pos = details.localPosition;
      const scale = 2.5;
      _transformCtrl.value = Matrix4.identity()
        ..setEntry(0, 0, scale)
        ..setEntry(1, 1, scale)
        ..setEntry(0, 3, -pos.dx * (scale - 1))
        ..setEntry(1, 3, -pos.dy * (scale - 1));
      _zoomed = true;
    }
  }

  @override
  void dispose() {
    _transformCtrl.dispose();
    _resetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: GestureDetector(
          onDoubleTapDown: _onDoubleTap,
          onDoubleTap: () {},
          child: InteractiveViewer(
            transformationController: _transformCtrl,
            maxScale: widget.maxScale,
            minScale: widget.minScale,
            child: Image(
              image: widget.imageProvider,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
