import 'package:flutter/material.dart';

import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';

/// A floating action button wrapper with design-system styling.
class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.heroTag,
    this.gradient,
    this.size = 56,
    this.iconSize = 24,
    this.iconColor,
    this.backgroundColor,
    this.shape,
    this.extendedLabel,
  });

  /// The FAB icon.
  final IconData icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Tooltip text.
  final String? tooltip;

  /// Hero tag.
  final Object? heroTag;

  /// Gradient fill (defaults to [AppGradients.brand]).
  final Gradient? gradient;

  /// FAB diameter.
  final double size;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Solid background (used when [gradient] is null).
  final Color? backgroundColor;

  /// Explicit shape.
  final ShapeBorder? shape;

  /// When set, renders an extended FAB with this label.
  final String? extendedLabel;

  @override
  Widget build(BuildContext context) {
    final Color foreground = iconColor ?? Colors.white;
    final Gradient? resolvedGradient =
        backgroundColor != null ? null : (gradient ?? AppGradients.brand);
    final ShapeBorder resolvedShape = shape ??
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large));

    if (extendedLabel != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: resolvedGradient,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppShadow.floating,
        ),
        child: Material(
          color: Colors.transparent,
          shape: resolvedShape,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: iconSize, color: foreground),
                  const SizedBox(width: 10),
                  Text(
                    extendedLabel!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadow.floating,
      ),
      child: Material(
        color: Colors.transparent,
        shape: resolvedShape,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}
