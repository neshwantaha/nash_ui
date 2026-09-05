import 'package:flutter/material.dart';

/// A multi-snap draggable bottom sheet with configurable snap heights.
class BottomSheetDraggable extends StatefulWidget {
  const BottomSheetDraggable({
    super.key,
    required this.child,
    this.snapHeights = const [0.3, 0.6, 0.92],
    this.initialSnapIndex = 0,
    this.backgroundColor,
    this.handleColor,
    this.borderRadius = 28,
    this.header,
    this.minHeight = 60,
    this.backdrop = true,
    this.onSnap,
  });

  final Widget child;

  /// Fraction of screen height (0–1) for each snap stop.
  final List<double> snapHeights;
  final int initialSnapIndex;
  final Color? backgroundColor;
  final Color? handleColor;
  final double borderRadius;
  final Widget? header;
  final double minHeight;
  final bool backdrop;
  final ValueChanged<int>? onSnap;

  @override
  State<BottomSheetDraggable> createState() => _BottomSheetDraggableState();
}

class _BottomSheetDraggableState extends State<BottomSheetDraggable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnim;
  int _snapIndex = 0;
  double _dragStart = 0;
  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();
    _snapIndex =
        widget.initialSnapIndex.clamp(0, widget.snapHeights.length - 1);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snapTo(int index, double screenH) {
    final targetH = widget.snapHeights[index] * screenH;
    _heightAnim = Tween<double>(begin: _currentHeight, end: targetH).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller
      ..reset()
      ..forward();
    _heightAnim
        .addListener(() => setState(() => _currentHeight = _heightAnim.value));
    _snapIndex = index;
    widget.onSnap?.call(index);
  }

  void _onDragEnd(DragEndDetails d, double screenH) {
    final velocity = d.primaryVelocity ?? 0;
    if (velocity < -300) {
      // swipe up → next snap
      if (_snapIndex < widget.snapHeights.length - 1) {
        _snapTo(_snapIndex + 1, screenH);
      }
    } else if (velocity > 300) {
      // swipe down → prev snap
      if (_snapIndex > 0) {
        _snapTo(_snapIndex - 1, screenH);
      }
    } else {
      // find nearest snap
      int nearest = 0;
      double minDist = double.infinity;
      for (int i = 0; i < widget.snapHeights.length; i++) {
        final dist = (_currentHeight - widget.snapHeights[i] * screenH).abs();
        if (dist < minDist) {
          minDist = dist;
          nearest = i;
        }
      }
      _snapTo(nearest, screenH);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.backgroundColor ?? theme.colorScheme.surface;
    final handle =
        widget.handleColor ?? theme.colorScheme.onSurface.withAlpha(80);

    return LayoutBuilder(builder: (context, constraints) {
      final screenH = constraints.maxHeight;
      if (_currentHeight == 0) {
        _currentHeight = widget.snapHeights[_snapIndex] * screenH;
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Backdrop
          if (widget.backdrop)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _snapTo(0, screenH),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity:
                      (_currentHeight / screenH - widget.snapHeights.first) /
                          (widget.snapHeights.last - widget.snapHeights.first) *
                          0.5,
                  child: Container(color: Colors.black),
                ),
              ),
            ),

          // Sheet
          GestureDetector(
            onVerticalDragStart: (d) => _dragStart = d.globalPosition.dy,
            onVerticalDragUpdate: (d) {
              final delta = _dragStart - d.globalPosition.dy;
              _dragStart = d.globalPosition.dy;
              setState(() {
                _currentHeight = (_currentHeight + delta)
                    .clamp(widget.minHeight, screenH * widget.snapHeights.last);
              });
            },
            onVerticalDragEnd: (d) => _onDragEnd(d, screenH),
            child: Container(
              height: _currentHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(widget.borderRadius)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Handle indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: handle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.header != null) widget.header!,
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
