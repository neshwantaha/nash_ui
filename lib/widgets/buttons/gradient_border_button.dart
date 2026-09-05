import 'package:flutter/material.dart';

import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';

/// A sleek button with an animated or multi-stop gradient border and inner glow.
///
/// ```dart
/// GradientBorderButton(
///   label: 'Upgrade to Ultra',
///   gradient: AppGradients.primary,
///   icon: Icons.bolt_rounded,
///   onPressed: () {},
/// )
/// ```
class GradientBorderButton extends StatelessWidget {
  const GradientBorderButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient,
    this.borderWidth = 2.0,
    this.height = 48.0,
    this.width,
    this.expanded = false,
    this.radius = AppRadius.medium,
    this.backgroundColor,
    this.textColor,
    this.glow = true,
  });

  /// Button label text.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// The gradient used to stroke the border.
  final Gradient? gradient;

  /// Width of the gradient border stroke.
  final double borderWidth;

  /// Button height.
  final double height;

  /// Fixed button width.
  final double? width;

  /// When true fills parent width.
  final bool expanded;

  /// Corner radius.
  final double radius;

  /// Interior fill color (defaults to theme background / dark surface).
  final Color? backgroundColor;

  /// Custom text and icon color.
  final Color? textColor;

  /// Whether to render a subtle exterior glow matching the gradient.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedGradient = gradient ?? AppGradients.primary;
    final bg =
        backgroundColor ?? (isDark ? const Color(0xFF10101C) : Colors.white);
    final fg = textColor ?? (isDark ? Colors.white : const Color(0xFF1E1E2F));

    return Container(
      height: height,
      width: expanded ? double.infinity : width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: resolvedGradient,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: resolvedGradient.colors.first.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(radius - borderWidth),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(radius - borderWidth),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    ShaderMask(
                      shaderCallback: resolvedGradient.createShader,
                      child: Icon(icon, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: fg,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
