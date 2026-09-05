import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A secondary (tonal) button using the theme's secondary container.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
    this.foregroundColor,
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

  /// Background color (defaults to secondary container).
  final Color? color;

  /// Foreground color.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color background = color ?? scheme.secondaryContainer;
    final Color foreground = foregroundColor ?? scheme.onSecondaryContainer;

    return FilledButton(
      onPressed: (loading || onPressed == null) ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: background.withValues(alpha: 0.5),
        minimumSize: Size(expanded ? double.infinity : (width ?? 0), height),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      child: loading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: foreground,
              ),
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
