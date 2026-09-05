import 'package:flutter/material.dart';

/// An interactive magnifying glass lens widget that magnifies its child
/// following touch and pointer position with customizable scale and lens size.
class MagnifierLens extends StatefulWidget {
  const MagnifierLens({
    super.key,
    required this.child,
    this.lensSize = 120,
    this.magnification = 2.0,
    this.borderColor,
    this.borderWidth = 3.0,
    this.enabled = true,
  });

  final Widget child;
  final double lensSize;
  final double magnification;
  final Color? borderColor;
  final double borderWidth;
  final bool enabled;

  @override
  State<MagnifierLens> createState() => _MagnifierLensState();
}

class _MagnifierLensState extends State<MagnifierLens> {
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = widget.borderColor ?? theme.colorScheme.primary;

    if (!widget.enabled) return widget.child;

    return GestureDetector(
      onPanDown: (d) => setState(() => _position = d.localPosition),
      onPanUpdate: (d) => setState(() => _position = d.localPosition),
      onPanEnd: (_) => setState(() => _position = null),
      onPanCancel: () => setState(() => _position = null),
      child: Stack(
        children: [
          widget.child,
          if (_position != null)
            Positioned(
              left: _position!.dx - (widget.lensSize / 2),
              top: _position!.dy - (widget.lensSize / 2) - 40,
              child: IgnorePointer(
                child: Container(
                  width: widget.lensSize,
                  height: widget.lensSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: border, width: widget.borderWidth),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: RawMagnifier(
                      size: Size(widget.lensSize, widget.lensSize),
                      magnificationScale: widget.magnification,
                      decoration: const MagnifierDecoration(
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
