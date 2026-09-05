import 'package:flutter/material.dart';

/// Gesture type for [GestureHintOverlay].
enum GestureHintType {
  swipeLeft,
  swipeRight,
  pinchToZoom,
  doubleTap,
  tapAndHold
}

/// An animated hint overlay showing users how to interact with gestures (swipe, pinch, double tap).
class GestureHintOverlay extends StatefulWidget {
  const GestureHintOverlay({
    super.key,
    required this.child,
    this.gesture = GestureHintType.swipeLeft,
    this.hintText,
    this.showHint = true,
    this.accentColor,
  });

  final Widget child;
  final GestureHintType gesture;
  final String? hintText;
  final bool showHint;
  final Color? accentColor;

  @override
  State<GestureHintOverlay> createState() => _GestureHintOverlayState();
}

class _GestureHintOverlayState extends State<GestureHintOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showHint) return widget.child;

    final theme = Theme.of(context);
    final accent = widget.accentColor ?? theme.colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                double dx = 0;
                double scale = 1.0;

                switch (widget.gesture) {
                  case GestureHintType.swipeLeft:
                    dx = -20 * _ctrl.value;
                    break;
                  case GestureHintType.swipeRight:
                    dx = 20 * _ctrl.value;
                    break;
                  case GestureHintType.pinchToZoom:
                    scale = 0.8 + 0.4 * _ctrl.value;
                    break;
                  case GestureHintType.doubleTap:
                  case GestureHintType.tapAndHold:
                    scale = 0.9 + 0.2 * _ctrl.value;
                    break;
                }

                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(180),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: Offset(dx, 0),
                          child: Transform.scale(
                            scale: scale,
                            child: Icon(
                              _iconForGesture(widget.gesture),
                              color: accent,
                              size: 24,
                            ),
                          ),
                        ),
                        if (widget.hintText != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            widget.hintText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconForGesture(GestureHintType type) {
    switch (type) {
      case GestureHintType.swipeLeft:
        return Icons.swipe_left_rounded;
      case GestureHintType.swipeRight:
        return Icons.swipe_right_rounded;
      case GestureHintType.pinchToZoom:
        return Icons.pinch_rounded;
      case GestureHintType.doubleTap:
        return Icons.touch_app_rounded;
      case GestureHintType.tapAndHold:
        return Icons.pan_tool_alt_rounded;
    }
  }
}
