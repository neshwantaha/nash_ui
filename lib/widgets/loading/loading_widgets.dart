import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '../indicators/loader.dart';

/// A pulsing placeholder block used while content loads.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius,
    this.shape = BoxShape.rectangle,
    this.color,
    this.margin,
    this.circle = false,
  });

  /// Skeleton width (defaults to full width).
  final double? width;

  /// Skeleton height.
  final double height;

  /// Corner radius override.
  final double? radius;

  /// Box shape (use [circle] for circular avatars).
  final BoxShape shape;

  /// Background color.
  final Color? color;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Shorthand for a circular skeleton.
  final bool circle;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDuration.slow,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color base =
        widget.color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final BoxShape shape = widget.circle ? BoxShape.circle : widget.shape;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;
        final Color color = Color.lerp(base, base.withValues(alpha: 0.6), t)!;
        return Padding(
          padding: widget.margin ?? EdgeInsets.zero,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: color,
              shape: shape,
              borderRadius: shape == BoxShape.rectangle
                  ? BorderRadius.circular(widget.radius ?? AppRadius.small)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

/// A shimmer sweep overlay used to build shimmer placeholders.
///
/// Wraps [child] with an animated diagonal light sweep. Combine with
/// [Skeleton] blocks for a full shimmer skeleton.
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.duration = AppDuration.slow,
    this.baseColor,
    this.highlightColor,
    this.blendMode = BlendMode.srcATop,
  });

  /// The content to shimmer.
  final Widget child;

  /// Sweep animation duration.
  final Duration duration;

  /// Base overlay color.
  final Color? baseColor;

  /// Moving highlight color.
  final Color? highlightColor;

  /// Blend mode for the highlight.
  final BlendMode blendMode;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color base = widget.baseColor ?? scheme.surfaceContainerHighest;
    final Color highlight =
        widget.highlightColor ?? Colors.white.withValues(alpha: 0.6);

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => ShaderMask(
        blendMode: widget.blendMode,
        shaderCallback: (Rect bounds) {
          final double dx = bounds.width * (1.2 + 1.4 * _controller.value);
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              base.withValues(alpha: 0),
              highlight,
              base.withValues(alpha: 0),
            ],
            stops: const <double>[0.2, 0.5, 0.8],
            transform: _SlideGradientTransform(dx / bounds.width),
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * dx, 0, 0);
}

/// A full-screen loading state with an optional title and retry action.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.title,
    this.subtitle,
    this.loader = const Loader(),
  });

  /// Optional loading title.
  final String? title;

  /// Optional loading subtitle.
  final String? subtitle;

  /// Loader widget to display.
  final Widget loader;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          loader,
          if (title != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ],
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A ready-made skeleton for common list items (avatar + lines).
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 72,
    this.withAvatar = true,
    this.shimmer = true,
  });

  /// Number of placeholder rows.
  final int itemCount;

  /// Height of each row.
  final double itemHeight;

  /// Whether each row includes an avatar circle.
  final bool withAvatar;

  /// Whether to apply a shimmer overlay.
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    final Widget rows = Column(
      children: <Widget>[
        for (int i = 0; i < itemCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: SizedBox(
              height: itemHeight,
              child: Row(
                children: <Widget>[
                  if (withAvatar) ...<Widget>[
                    const Skeleton(
                      circle: true,
                      height: 44,
                      width: 44,
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Skeleton(),
                        ),
                        SizedBox(height: 8),
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Skeleton(height: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return shimmer ? Shimmer(child: rows) : rows;
  }
}

/// A skeleton grid of media cards.
class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    super.key,
    this.columns = 2,
    this.itemCount = 4,
    this.aspectRatio = 1,
    this.shimmer = true,
  });

  /// Number of columns.
  final int columns;

  /// Number of placeholder cells.
  final int itemCount;

  /// Cell aspect ratio (width / height).
  final double aspectRatio;

  /// Whether to apply a shimmer overlay.
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    const double spacing = AppSpacing.md;
    final Widget grid = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) =>
          const Skeleton(radius: AppRadius.medium),
    );
    return shimmer ? Shimmer(child: grid) : grid;
  }
}
