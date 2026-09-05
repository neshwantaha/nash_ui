import 'package:flutter/material.dart';

/// A clickable tag/chip with icon, label and optional removal.
class Tag extends StatelessWidget {
  const Tag({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
    this.onRemoved,
    this.size = 12,
    this.outlined = false,
    this.removeIcon = Icons.close,
    this.fontWeight = FontWeight.w600,
  });

  /// Tag label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Tag color (defaults to primary).
  final Color? color;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Removal callback (shows a close icon).
  final VoidCallback? onRemoved;

  /// Text size.
  final double size;

  /// Outlined style.
  final bool outlined;

  /// Remove icon.
  final IconData removeIcon;

  /// Label font weight.
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color accent = color ?? scheme.primary;

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: size + 2, color: outlined ? accent : Colors.white),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            color: outlined ? accent : Colors.white,
          ),
        ),
        if (onRemoved != null) ...<Widget>[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemoved,
            child: Icon(
              removeIcon,
              size: size + 2,
              color: outlined ? accent : Colors.white,
            ),
          ),
        ],
      ],
    );

    final Widget pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : accent,
        border: outlined ? Border.all(color: accent, width: 1.2) : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: content,
    );

    if (onTap == null) return pill;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: pill,
    );
  }
}
