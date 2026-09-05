import 'package:flutter/material.dart';

import 'duration.dart';

/// Hover interaction that lifts and scales [child].
///
/// Works with mouse hover on desktop and can also be triggered with a pointer
/// tap-and-hold on touch devices.
class HoverEffect extends StatefulWidget {
  const HoverEffect({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.translateY = -4,
    this.shadow,
    this.duration = AppDuration.fast,
    this.oHoverEffect,
  });

  /// The animated child.
  final Widget child;

  /// Scale applied while hovering.
  final double scale;

  /// Vertical lift applied while hovering.
  final double translateY;

  /// Shadow applied while hovering.
  final List<BoxShadow>? shadow;

  /// Animation duration.
  final Duration duration;

  /// Optional hover callback.
  final ValueChanged<bool>? oHoverEffect;

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    widget.oHoverEffect?.call(value);
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedScale(
          scale: _hovered ? widget.scale : 1,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
                0, _hovered ? widget.translateY : 0, 0),
            decoration: widget.shadow != null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _hovered ? widget.shadow : null,
                  )
                : null,
            child: widget.child,
          ),
        ),
      );
}
