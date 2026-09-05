import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// An outlined button.
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
    this.loading = false,
    this.width,
    this.height = 48,
    this.radius = AppRadius.medium,
    this.color,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When true the button fills the available width.
  final bool expanded;

  /// Shows a spinner and disables interaction.
  final bool loading;

  /// Fixed width (ignored when [expanded]).
  final double? width;

  /// Button height.
  final double height;

  /// Corner radius.
  final double radius;

  /// Label color (defaults to primary).
  final Color? color;

  /// Border color (defaults to theme outline).
  final Color? borderColor;

  /// Border stroke width.
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color foreground = color ?? scheme.primary;

    return OutlinedButton(
      onPressed: (loading || onPressed == null) ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        minimumSize: Size(expanded ? double.infinity : (width ?? 96), height),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        side: BorderSide(
            color: borderColor ?? scheme.outline, width: borderWidth),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      child: loading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2.2, color: foreground),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 20, color: foreground),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: foreground, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
    );
  }
}
