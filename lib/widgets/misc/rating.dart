import 'package:flutter/material.dart';

/// A rating display with filled/outline stars and optional count.
class Rating extends StatelessWidget {
  const Rating({
    super.key,
    this.value = 0,
    this.count,
    this.size = 18,
    this.color,
    this.emptyColor,
    this.onChanged,
    this.showValue = false,
    this.maxRating = 5,
  });

  /// Current rating value.
  final double value;

  /// Total reviews count text (e.g. `(128)`).
  final String? count;

  /// Star size.
  final double size;

  /// Filled star color.
  final Color? color;

  /// Empty star color.
  final Color? emptyColor;

  /// Interactive change callback (enables editing mode).
  final ValueChanged<double>? onChanged;

  /// Whether to show the numeric value.
  final bool showValue;

  /// Maximum rating.
  final int maxRating;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color filled = color ?? const Color(0xFFF59E0B);
    final Color empty = emptyColor ?? scheme.outlineVariant;
    final double p = value.clamp(0, maxRating.toDouble());

    Widget stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 1; i <= maxRating; i++) ...<Widget>[
          Icon(
            i <= p.round() ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: i <= p.round() ? filled : empty,
          ),
        ],
      ],
    );

    if (onChanged != null) {
      stars = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 1; i <= maxRating; i++)
            GestureDetector(
              onTap: () => onChanged!(i.toDouble()),
              child: Icon(
                i <= p.round()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: size,
                color: i <= p.round() ? filled : empty,
              ),
            ),
        ],
      );
    }

    if (!showValue && count == null) return stars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        stars,
        if (showValue) ...<Widget>[
          const SizedBox(width: 6),
          Text(
            p.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
        if (count != null) ...<Widget>[
          const SizedBox(width: 6),
          Text(
            '(${count!})',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}
