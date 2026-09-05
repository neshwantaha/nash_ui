import 'dart:ui';
import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A glassmorphic frosted glass button with specular border highlight and backdrop blur.
///
/// ```dart
/// GlassButton(
///   label: 'Explore Pro',
///   icon: Icons.auto_awesome,
///   onPressed: () {},
/// )
/// ```
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.blur = 12.0,
    this.tintColor,
    this.opacity = 0.12,
    this.height = 48.0,
    this.width,
    this.expanded = false,
    this.radius = AppRadius.medium,
    this.borderColor,
    this.textColor,
  });

  /// Button text label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Backdrop filter blur sigma.
  final double blur;

  /// Base tint color (defaults to white in dark mode, surface in light mode).
  final Color? tintColor;

  /// Surface opacity (0.0 to 1.0).
  final double opacity;

  /// Button height.
  final double height;

  /// Button width (ignored when [expanded] is true).
  final double? width;

  /// Whether the button takes up the full parent width.
  final bool expanded;

  /// Border corner radius.
  final double radius;

  /// Custom border highlight color.
  final Color? borderColor;

  /// Text and icon color.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTint = isDark ? Colors.white : Colors.black;
    final fg = textColor ?? (isDark ? Colors.white : Colors.black87);
    final borderCol = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.12));

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: (tintColor ?? defaultTint).withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderCol, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                height: height,
                width: expanded ? double.infinity : width,
                constraints: BoxConstraints(minWidth: width ?? 96),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: fg),
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
                          fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
