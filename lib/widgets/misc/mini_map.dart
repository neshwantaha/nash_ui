import 'package:flutter/material.dart';

/// A scrollable minimap widget that shows a small overview of a larger
/// scrollable area with a draggable viewport indicator.
class MiniMap extends StatefulWidget {
  const MiniMap({
    super.key,
    required this.controller,
    required this.child,
    this.mapWidth = 120,
    this.mapHeight = 80,
    this.mapColor,
    this.viewportColor,
    this.borderRadius,
    this.position = MiniMapPosition.bottomRight,
  });

  final ScrollController controller;
  final Widget child;
  final double mapWidth;
  final double mapHeight;
  final Color? mapColor;
  final Color? viewportColor;
  final BorderRadius? borderRadius;
  final MiniMapPosition position;

  @override
  State<MiniMap> createState() => _MiniMapState();
}

enum MiniMapPosition { topLeft, topRight, bottomLeft, bottomRight }

class _MiniMapState extends State<MiniMap> {
  double _scrollFraction = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    if (max == 0) return;
    setState(() => _scrollFraction = widget.controller.offset / max);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  Positioned _buildMiniMap(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.mapColor ?? theme.colorScheme.surface.withAlpha(220);
    final vp = widget.viewportColor ?? theme.colorScheme.primary.withAlpha(100);
    final br = widget.borderRadius ?? BorderRadius.circular(8);

    const double padding = 12;
    const double inset = 8;

    final (double? t, double? b, double? l, double? r) =
        switch (widget.position) {
      MiniMapPosition.topLeft => (inset, null, inset, null),
      MiniMapPosition.topRight => (inset, null, null, inset),
      MiniMapPosition.bottomLeft => (null, inset, inset, null),
      MiniMapPosition.bottomRight => (null, inset, null, inset),
    };

    final viewportH = widget.mapHeight * 0.3;
    final vpTop =
        _scrollFraction * (widget.mapHeight - viewportH - padding * 2);

    return Positioned(
      top: t,
      bottom: b,
      left: l,
      right: r,
      child: ClipRRect(
        borderRadius: br,
        child: Container(
          width: widget.mapWidth,
          height: widget.mapHeight,
          padding: const EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: br,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Stack(
            children: [
              // Scroll track
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Viewport indicator
              Positioned(
                top: vpTop.clamp(0, widget.mapHeight - viewportH - padding * 2),
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (d) {
                    if (!widget.controller.hasClients) return;
                    final max = widget.controller.position.maxScrollExtent;
                    final delta =
                        (d.delta.dy / (widget.mapHeight - padding * 2)) * max;
                    widget.controller.jumpTo(
                      (widget.controller.offset + delta).clamp(0, max),
                    );
                  },
                  child: Container(
                    height: viewportH,
                    decoration: BoxDecoration(
                      color: vp,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(180),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [widget.child, _buildMiniMap(context)],
      );
}
