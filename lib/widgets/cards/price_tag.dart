import 'package:flutter/material.dart';

/// A price tag widget with old/new price, discount percentage, and badge.
///
/// ```dart
/// PriceTag(
///   price: 49.99,
///   originalPrice: 89.99,
///   currency: '\$',
/// )
/// ```
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.currency = '\$',
    this.color,
    this.showDiscount = true,
    this.priceStyle,
    this.originalPriceStyle,
    this.badgeStyle,
  });

  final double price;
  final double? originalPrice;
  final String currency;
  final Color? color;
  final bool showDiscount;
  final TextStyle? priceStyle;
  final TextStyle? originalPriceStyle;
  final TextStyle? badgeStyle;

  int get _discountPercent {
    if (originalPrice == null || originalPrice! <= 0) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceColor = color ?? theme.colorScheme.primary;
    final discount = _discountPercent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$currency${price.toStringAsFixed(2)}',
          style: priceStyle ??
              theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: priceColor,
              ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            '$currency${originalPrice!.toStringAsFixed(2)}',
            style: originalPriceStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        if (showDiscount && discount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-$discount%',
              style: badgeStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
