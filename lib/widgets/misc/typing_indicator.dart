import 'package:flutter/material.dart';

/// A "is typing..." indicator with three animated bouncing dots.
///
/// ```dart
/// TypingIndicator(color: Colors.grey)
/// ```
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.color,
    this.dotSize = 8.0,
    this.dotSpacing = 4.0,
    this.dotCount = 3,
    this.showLabel = false,
    this.label = 'typing...',
  });

  final Color? color;
  final double dotSize;
  final double dotSpacing;
  final int dotCount;
  final bool showLabel;
  final String label;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor =
        widget.color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
              widget.dotCount,
              (i) => AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) {
                      final t =
                          ((_ctrl.value * widget.dotCount) - i).clamp(0.0, 1.0);
                      final bounce = (t < 0.5 ? t * 2 : (1 - t) * 2);
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: widget.dotSpacing / 2),
                        child: Transform.translate(
                          offset: Offset(0, -5 * bounce),
                          child: Container(
                            width: widget.dotSize,
                            height: widget.dotSize,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
          if (widget.showLabel) ...[
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: dotColor.withAlpha(180),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
