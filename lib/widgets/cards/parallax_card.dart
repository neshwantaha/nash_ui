import 'package:flutter/material.dart';

/// A card widget with a parallax depth effect responding to pointer movement.
class ParallaxCard extends StatefulWidget {
  const ParallaxCard({
    super.key,
    required this.child,
    this.depthFactor = 0.04,
    this.borderRadius,
    this.elevation = 8,
    this.shadowColor,
    this.clipContent = true,
  });

  final Widget child;

  /// Controls the intensity of the parallax effect (0–1).
  final double depthFactor;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final bool clipContent;

  @override
  State<ParallaxCard> createState() => _ParallaxCardState();
}

class _ParallaxCardState extends State<ParallaxCard>
    with SingleTickerProviderStateMixin {
  Offset _pointer = Offset.zero;
  bool _hovering = false;
  late AnimationController _resetController;
  late Animation<Offset> _resetAnimation;
  Offset _lastPointer = Offset.zero;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent event, BoxConstraints constraints) {
    final rx = event.localPosition.dx / constraints.maxWidth - 0.5;
    final ry = event.localPosition.dy / constraints.maxHeight - 0.5;
    setState(() {
      _pointer = Offset(rx, ry);
      _lastPointer = _pointer;
    });
  }

  void _onExit() {
    _resetAnimation = Tween<Offset>(
      begin: _lastPointer,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _resetController, curve: Curves.easeOut));
    _resetController
      ..reset()
      ..forward();
    _resetAnimation.addListener(() {
      setState(() => _pointer = _resetAnimation.value);
    });
    setState(() => _hovering = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final br = widget.borderRadius ?? BorderRadius.circular(20);
    final shadow = widget.shadowColor ?? theme.colorScheme.shadow;

    // tiltX → rotateY, tiltY → rotateX
    final tiltX = _pointer.dy * widget.depthFactor * 3.14;
    final tiltY = -_pointer.dx * widget.depthFactor * 3.14;

    return LayoutBuilder(
      builder: (context, constraints) => MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => _onExit(),
        child: Listener(
          onPointerMove: (e) => _onPointerMove(e, constraints),
          child: GestureDetector(
            onPanUpdate: (d) {
              final rx = (_pointer.dx + d.delta.dx / constraints.maxWidth)
                  .clamp(-0.5, 0.5);
              final ry = (_pointer.dy + d.delta.dy / constraints.maxHeight)
                  .clamp(-0.5, 0.5);
              setState(() => _pointer = Offset(rx, ry));
            },
            onPanEnd: (_) => _onExit(),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(tiltX)
                ..rotateY(tiltY),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: br,
                  boxShadow: [
                    BoxShadow(
                      color: shadow.withAlpha(_hovering ? 80 : 40),
                      blurRadius: _hovering ? 28 : 12,
                      offset: Offset(_pointer.dx * 12, _pointer.dy * 12 + 4),
                    ),
                  ],
                ),
                child: widget.clipContent
                    ? ClipRRect(borderRadius: br, child: widget.child)
                    : widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
