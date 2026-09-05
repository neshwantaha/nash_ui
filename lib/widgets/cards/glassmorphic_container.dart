import 'dart:ui';
import 'package:flutter/material.dart';

/// A premium glassmorphic frosted-glass container with blur effect,
/// subtle linear gradient background, and luminous border highlight.
class GlassmorphicContainer extends StatelessWidget {
  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.blur = 16,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.glassColor,
    this.borderColor,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? glassColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultGlass = glassColor ??
        (isDark ? Colors.white.withAlpha(25) : Colors.white.withAlpha(160));
    final defaultBorder = borderColor ??
        (isDark ? Colors.white.withAlpha(50) : Colors.white.withAlpha(200));

    final br = BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: br,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 20),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: defaultGlass,
              borderRadius: br,
              border: Border.all(
                color: defaultBorder,
                width: borderWidth,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  defaultGlass.withAlpha(
                      (defaultGlass.a * 255 * 1.3).round().clamp(0, 255)),
                  defaultGlass.withAlpha(
                      (defaultGlass.a * 255 * 0.7).round().clamp(0, 255)),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
