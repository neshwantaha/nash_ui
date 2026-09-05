import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A network image with loading, error and placeholder states.
///
/// Uses Flutter's built-in [Image.network] with the framework's own
/// [ImageCache], so no external caching library is needed.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.borderRadius,
    this.placeholderIcon,
    this.errorIcon,
    this.placeholderColor,
  });

  /// Image URL.
  final String url;

  /// Image width.
  final double? width;

  /// Image height.
  final double? height;

  /// Box fit.
  final BoxFit fit;

  /// Corner radius (applied to all corners).
  final double? radius;

  /// Explicit border radius.
  final BorderRadius? borderRadius;

  /// Loading placeholder icon.
  final IconData? placeholderIcon;

  /// Error icon.
  final IconData? errorIcon;

  /// Placeholder background color.
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius resolvedRadius =
        borderRadius ?? BorderRadius.circular(radius ?? 0);
    final Color placeholder =
        placeholderColor ?? scheme.surfaceContainerHighest;

    Widget image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: placeholder,
          child: Center(
            child: Icon(
              placeholderIcon ?? Icons.image,
              size: 28,
              color: scheme.onSurfaceVariant,
            ),
          ),
        );
      },
      errorBuilder: (BuildContext context, Object _, StackTrace? __) =>
          Container(
        width: width,
        height: height,
        color: placeholder,
        child: Center(
          child: Icon(
            errorIcon ?? Icons.broken_image_outlined,
            size: 28,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );

    if (radius != null || borderRadius != null) {
      image = ClipRRect(borderRadius: resolvedRadius, child: image);
    }
    return image;
  }
}

/// A video placeholder with a play button.
class VideoPlaceholder extends StatelessWidget {
  const VideoPlaceholder({
    super.key,
    this.thumbnail,
    this.width,
    this.height,
    this.radius = AppRadius.medium,
    this.onPlay,
    this.playButtonColor,
    this.label,
  });

  /// Optional thumbnail URL.
  final String? thumbnail;

  /// Width.
  final double? width;

  /// Height.
  final double? height;

  /// Corner radius.
  final double radius;

  /// Play callback.
  final VoidCallback? onPlay;

  /// Play button color.
  final Color? playButtonColor;

  /// Optional duration label.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (thumbnail != null)
            Image.network(thumbnail!, fit: BoxFit.cover)
          else
            Container(
              color: scheme.surfaceContainerHighest,
              child: Icon(Icons.play_circle_outline,
                  size: 48, color: scheme.onSurfaceVariant),
            ),
          Container(
            color: Colors.black.withValues(alpha: 0.25),
            child: Center(
              child: IconButton.filled(
                onPressed: onPlay,
                iconSize: 36,
                style: IconButton.styleFrom(
                  backgroundColor:
                      playButtonColor ?? Colors.white.withValues(alpha: 0.9),
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                tooltip: 'Play',
              ),
            ),
          ),
          if (label != null)
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label!,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
