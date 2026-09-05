import 'dart:ui';

import 'package:flutter/material.dart' hide Card;

import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';
import '../../spacing/app_spacing.dart';

/// A flexible base card with design-system styling.
///
/// A backwards-compatible alias for [Card].
typedef NashCard = Card;

/// A flexible base card with design-system styling.
class Card extends StatelessWidget {
  const Card({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius = AppRadius.large,
    this.shadows,
    this.elevated = true,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.constraints,
    this.clipBehavior = Clip.antiAlias,
    this.shape,
    this.elevation,
    this.decoration,
  });

  /// Card content.
  final Widget? child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Background color.
  final Color? color;

  /// Background gradient.
  final Gradient? gradient;

  /// Corner radius.
  final double borderRadius;

  /// Custom shadows.
  final List<BoxShadow>? shadows;

  /// Whether to apply the default card shadow.
  final bool elevated;

  /// Border color.
  final Color? borderColor;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// Box constraints.
  final BoxConstraints? constraints;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Shape border (Flutter compatibility).
  final ShapeBorder? shape;

  /// Elevation in dp (Flutter compatibility).
  final double? elevation;

  /// Explicit decoration override.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius resolvedRadius;
    if (shape is RoundedRectangleBorder) {
      resolvedRadius = (shape as RoundedRectangleBorder)
          .borderRadius
          .resolve(Directionality.maybeOf(context));
    } else {
      resolvedRadius = BorderRadius.circular(borderRadius);
    }

    final Decoration resolvedDecoration = decoration ??
        BoxDecoration(
          color:
              gradient == null ? (color ?? scheme.surfaceContainerLow) : null,
          gradient: gradient,
          borderRadius: resolvedRadius,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: shadows ??
              ((elevated || (elevation != null && elevation! > 0))
                  ? AppShadow.card
                  : null),
        );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: margin,
      constraints: constraints,
      decoration: resolvedDecoration,
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: resolvedRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// A card with a colored gradient header.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.gradient = AppGradients.brand,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadius.large,
    this.onTap,
    this.foregroundColor = Colors.white,
  });

  /// Card content.
  final Widget child;

  /// Header gradient.
  final Gradient gradient;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Corner radius.
  final double radius;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Content color.
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: AppShadow.glow,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
}

/// A modern glassmorphism frosted card with backdrop blur.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.blur = 16.0,
    this.opacity = 0.15,
    this.radius = AppRadius.large,
    this.borderColor,
    this.onTap,
  });

  /// Card child widget.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Blur intensity.
  final double blur;

  /// Surface translucency.
  final double opacity;

  /// Corner radius.
  final double radius;

  /// Specular border color.
  final Color? borderColor;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // In dark mode: white tint. In light mode: black tint for contrast.
    final Color baseColor = isDark ? Colors.white : Colors.black;

    // Border: white-glow in dark, dark-subtle in light.
    final Color border = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.12));

    // Gradient: semi-transparent in both modes but using the correct tint.
    final Color gradientTop = isDark
        ? Colors.white.withValues(alpha: opacity + 0.1)
        : Colors.white.withValues(alpha: 0.65);
    final Color gradientBottom = isDark
        ? Colors.white.withValues(alpha: opacity * 0.4)
        : Colors.white.withValues(alpha: 0.35);

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: isDark ? opacity : 0.08),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: border, width: 1.2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[gradientTop, gradientBottom],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// An ambient glowing card with vibrant shadow highlights.
class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.glowColor,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadius.large,
    this.blurRadius = 24.0,
    this.spreadRadius = 1.0,
    this.onTap,
  });

  /// Card content.
  final Widget child;

  /// Glow accent color.
  final Color? glowColor;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Corner radius.
  final double radius;

  /// Blur intensity for the glow.
  final double blurRadius;

  /// Spread for the glow shadow.
  final double spreadRadius;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = glowColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        padding: padding,
        borderRadius: radius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
