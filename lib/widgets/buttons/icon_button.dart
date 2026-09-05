import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter/material.dart' as fl show IconButton;

import '../../radius/app_radius.dart';

/// A backwards-compatible alias for [IconButton].
typedef NashIconButton = IconButton;

/// A themed icon button with optional tooltip.
///
/// Accepts either an [IconData] (e.g. `Icons.add`) or a [Widget] (e.g. `Icon(Icons.add)`)
/// for full drop-in compatibility with Flutter's standard `IconButton`.
class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.padding,
    this.radius = AppRadius.medium,
    this.enabled = true,
    this.style,
  });

  /// Filled variant.
  const IconButton.filled({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.padding,
    this.radius = AppRadius.medium,
    this.enabled = true,
    this.style,
  });

  /// Filled tonal variant.
  const IconButton.filledTonal({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.padding,
    this.radius = AppRadius.medium,
    this.enabled = true,
    this.style,
  });

  /// Outlined variant.
  const IconButton.outlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.padding,
    this.radius = AppRadius.medium,
    this.enabled = true,
    this.style,
  });

  /// Custom button style.
  final ButtonStyle? style;

  /// Helper to create ButtonStyle.
  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    bool? enableFeedback,
    Duration? animationDuration,
  }) =>
      fl.IconButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        elevation: elevation,
        minimumSize: minimumSize,
        fixedSize: fixedSize,
        maximumSize: maximumSize,
        side: side,
        shape: shape,
        padding: padding,
        enableFeedback: enableFeedback,
        animationDuration: animationDuration,
      );

  /// The icon (can be [IconData] or [Widget]).
  final dynamic icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Tooltip text.
  final String? tooltip;

  /// Icon color.
  final Color? color;

  /// Background fill color.
  final Color? backgroundColor;

  /// Icon size.
  final double size;

  /// Icon button padding.
  final EdgeInsetsGeometry? padding;

  /// Corner radius.
  final double radius;

  /// When false the button is disabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon as IconData,
          size: size, color: color ?? scheme.onSurfaceVariant);
    } else if (icon is Widget) {
      iconWidget = icon as Widget;
    } else {
      iconWidget = const SizedBox.shrink();
    }

    return fl.IconButton(
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
      icon: iconWidget,
      style: style ??
          fl.IconButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: padding,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
          ),
    );
  }
}
