import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as fl show TextButton;

import '../../radius/app_radius.dart';

/// A backwards-compatible alias for [TextButton].
typedef NashTextButton = TextButton;

/// A text-only button.
class TextButton extends StatelessWidget {
  const TextButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.icon,
    this.expanded = false,
    this.width,
    this.height = 48,
    this.radius = AppRadius.medium,
    this.color,
    this.loading = false,
  });

  /// Button label string.
  final String? label;

  /// Button child widget (Flutter compatibility).
  final Widget? child;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When true the button fills the available width.
  final bool expanded;

  /// Fixed width (ignored when [expanded]).
  final double? width;

  /// Button height.
  final double height;

  /// Corner radius.
  final double radius;

  /// Label color (defaults to primary).
  final Color? color;

  /// Shows a spinner and disables interaction.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final Color foreground = color ?? Theme.of(context).colorScheme.primary;
    final Widget contentWidget;
    if (child != null) {
      contentWidget = child!;
    } else if (icon != null) {
      contentWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 8),
          Text(
            label ?? '',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else {
      contentWidget = Text(
        label ?? '',
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
      );
    }

    return fl.TextButton(
      onPressed: (loading || onPressed == null) ? null : onPressed,
      style: fl.TextButton.styleFrom(
        foregroundColor: foreground,
        minimumSize: Size(expanded ? double.infinity : (width ?? 0), height),
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
          : contentWidget,
    );
  }
}
