import 'package:flutter/material.dart';

/// Semantic alert level for [InlineAlert].
enum InlineAlertType { info, success, warning, error }

/// An inline embedded banner/alert for forms, cards, and pages.
///
/// ```dart
/// InlineAlert(
///   title: 'Payment Successful',
///   message: 'Your order #1234 has been processed.',
///   type: InlineAlertType.success,
///   onDismiss: () => print('dismissed'),
/// )
/// ```
class InlineAlert extends StatelessWidget {
  const InlineAlert({
    super.key,
    required this.message,
    this.title,
    this.type = InlineAlertType.info,
    this.icon,
    this.onDismiss,
    this.action,
    this.actionLabel,
    this.borderRadius = 12,
  });

  final String message;
  final String? title;
  final InlineAlertType type;
  final IconData? icon;
  final VoidCallback? onDismiss;
  final VoidCallback? action;
  final String? actionLabel;
  final double borderRadius;

  (Color bg, Color border, Color fg, IconData defaultIcon) _style(
          BuildContext context) =>
      switch (type) {
        InlineAlertType.info => (
            const Color(0xFFEFF6FF),
            const Color(0xFF93C5FD),
            const Color(0xFF1D4ED8),
            Icons.info_outline_rounded
          ),
        InlineAlertType.success => (
            const Color(0xFFF0FDF4),
            const Color(0xFF86EFAC),
            const Color(0xFF15803D),
            Icons.check_circle_outline_rounded
          ),
        InlineAlertType.warning => (
            const Color(0xFFFEFCE8),
            const Color(0xFFFDE047),
            const Color(0xFFA16207),
            Icons.warning_amber_rounded
          ),
        InlineAlertType.error => (
            const Color(0xFFFEF2F2),
            const Color(0xFFFCA5A5),
            const Color(0xFFB91C1C),
            Icons.error_outline_rounded
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, defaultIcon) = _style(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, color: fg, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: fg.withValues(alpha: 0.9),
                  ),
                ),
                if (actionLabel != null && action != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: action,
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fg,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child:
                  Icon(Icons.close, size: 16, color: fg.withValues(alpha: 0.7)),
            ),
          ],
        ],
      ),
    );
  }
}
