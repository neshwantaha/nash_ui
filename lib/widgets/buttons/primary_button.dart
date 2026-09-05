import 'package:flutter/material.dart';

import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';

/// A primary call-to-action button with a brand gradient fill.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient,
    this.expanded = false,
    this.loading = false,
    this.width,
    this.height = 48,
    this.radius = AppRadius.medium,
    this.elevated = true,
    this.padding,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Custom gradient (defaults to [AppGradients.brand]).
  final Gradient? gradient;

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

  /// Applies the brand glow shadow.
  final bool elevated;

  /// Custom button padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Gradient resolvedGradient = gradient ?? AppGradients.brand;
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (loading)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2.2, color: Colors.white),
          )
        else if (icon != null) ...<Widget>[
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
        ],
        if (loading && icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: resolvedGradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: elevated ? AppShadow.brand : null,
        ),
        child: InkWell(
          onTap: (loading || onPressed == null) ? null : onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            height: height,
            width: expanded ? double.infinity : width,
            constraints: BoxConstraints(
              minWidth: width ?? 96,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
