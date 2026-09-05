import 'dart:math';
import 'package:flutter/material.dart';

/// An interactive audio equalizer visualizer with animated frequency bands.
class EqualizerWidget extends StatefulWidget {
  const EqualizerWidget({
    super.key,
    this.bandCount = 5,
    this.height = 48,
    this.barWidth = 4.0,
    this.spacing = 3.0,
    this.color,
    this.isAnimated = true,
    this.borderRadius = 2.0,
  });

  final int bandCount;
  final double height;
  final double barWidth;
  final double spacing;
  final Color? color;
  final bool isAnimated;
  final double borderRadius;

  @override
  State<EqualizerWidget> createState() => _EqualizerWidgetState();
}

class _EqualizerWidgetState extends State<EqualizerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isAnimated) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant EqualizerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(widget.bandCount, (i) {
            final phase = (i * 0.2) + (_controller.value * 2 * pi);
            final factor = widget.isAnimated
                ? (0.3 + 0.7 * (sin(phase).abs()))
                : (0.4 + (i % 3) * 0.2);
            final barH = (widget.height * factor).clamp(6.0, widget.height);

            return Container(
              width: widget.barWidth,
              height: barH,
              margin: EdgeInsets.only(
                right: i < widget.bandCount - 1 ? widget.spacing : 0,
              ),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            );
          }),
        ),
      ),
    );
  }
}
