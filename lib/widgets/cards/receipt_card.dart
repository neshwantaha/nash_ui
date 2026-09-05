import 'package:flutter/material.dart';

/// A line item on a [ReceiptCard].
class ReceiptItem {
  const ReceiptItem({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.isSubtotal = false,
  });

  final String label;
  final double amount;
  final bool isDiscount;
  final bool isSubtotal;
}

/// A paper-style receipt card widget with perforated divider.
///
/// ```dart
/// ReceiptCard(
///   merchantName: 'Coffee & Co.',
///   orderId: '#ORD-4892',
///   items: [
///     ReceiptItem(label: 'Latte', amount: 4.50),
///     ReceiptItem(label: 'Croissant', amount: 3.20),
///   ],
///   total: 7.70,
///   currency: '\$',
/// )
/// ```
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.merchantName,
    required this.items,
    required this.total,
    this.orderId,
    this.dateTime,
    this.currency = '\$',
    this.logoIcon,
    this.statusLabel,
    this.statusColor,
  });

  final String merchantName;
  final List<ReceiptItem> items;
  final double total;
  final String? orderId;
  final String? dateTime;
  final String currency;
  final IconData? logoIcon;
  final String? statusLabel;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              children: [
                Icon(
                  logoIcon ?? Icons.receipt_long_rounded,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  merchantName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (orderId != null)
                  Text(orderId!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                if (dateTime != null)
                  Text(dateTime!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
              ],
            ),
          ),

          // Perforated divider
          _PerforatedDivider(color: theme.colorScheme.outlineVariant),

          // Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: items.map((item) {
                final textColor = item.isDiscount
                    ? Colors.green
                    : item.isSubtotal
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontWeight:
                                item.isSubtotal ? FontWeight.w600 : null,
                          )),
                      Text(
                        '${item.isDiscount ? '-' : ''}$currency${item.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: item.isSubtotal ? FontWeight.w600 : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Perforated divider
          _PerforatedDivider(color: theme.colorScheme.outlineVariant),

          // Total
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    )),
                Text(
                  '$currency${total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          if (statusLabel != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: (statusColor ?? Colors.green).withAlpha(25),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                statusLabel!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor ?? Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PerforatedDivider extends StatelessWidget {
  const _PerforatedDivider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 20,
        child: CustomPaint(
          painter: _DashedLinePainter(color: color),
          child: const SizedBox.expand(),
        ),
      );
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const notchR = 10.0;
    // Left and right notches
    canvas
      ..drawCircle(
        Offset(-notchR, size.height / 2),
        notchR,
        Paint()..color = color,
      )
      ..drawCircle(
        Offset(size.width + notchR, size.height / 2),
        notchR,
        Paint()..color = color,
      );
    // Dashed line
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    double x = notchR * 2;
    while (x < size.width - notchR * 2) {
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(x + 6, size.height / 2), paint);
      x += 12;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
