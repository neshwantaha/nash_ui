import 'package:flutter/material.dart' hide Badge;

/// A backwards-compatible alias for [Badge].
typedef NashBadge = Badge;

/// A badge/counter pill attached to a child.
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.child,
    this.label,
    this.count,
    this.maxCount = 99,
    this.color,
    this.textColor,
    this.top = 0,
    this.right = 0,
    this.showZero = false,
    this.borderColor,
  });

  /// The wrapped widget.
  final Widget child;

  /// Badge text label.
  final String? label;

  /// Numeric count.
  final int? count;

  /// Maximum count shown as `max+`.
  final int maxCount;

  /// Badge color.
  final Color? color;

  /// Badge text color.
  final Color? textColor;

  /// Offset from top.
  final double top;

  /// Offset from right.
  final double right;

  /// Whether to show `0`.
  final bool showZero;

  /// Badge border color.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color badgeColor = color ?? scheme.error;

    final String text;
    if (label != null) {
      text = label!;
    } else if (count != null) {
      if (count == 0 && !showZero) {
        return child;
      }
      text = count! > maxCount ? '$maxCount+' : '$count';
    } else {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        Positioned(
          top: top,
          right: right,
          child: Container(
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(100),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: 1.5)
                  : null,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.35),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
