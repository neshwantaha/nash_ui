import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A decorated image with optional overlay, border and shadow.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.medium,
    this.overlayColor,
    this.border,
    this.shadow,
    this.onTap,
    this.alignment = Alignment.center,
    this.placeholder,
  });

  /// The image provider.
  final ImageProvider image;

  /// Width.
  final double? width;

  /// Height.
  final double? height;

  /// Box fit.
  final BoxFit fit;

  /// Corner radius.
  final double radius;

  /// Semi-transparent overlay color tint.
  final Color? overlayColor;

  /// Border decoration.
  final BoxBorder? border;

  /// Box shadow.
  final BoxShadow? shadow;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Image alignment.
  final AlignmentGeometry alignment;

  /// Placeholder shown while loading.
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    Widget child = Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      frameBuilder: (BuildContext context, Widget widget, int? frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return widget;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: frame == null
              ? (placeholder ??
                  Container(
                    key: const ValueKey('loading'),
                    color: scheme.surfaceContainerHighest,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ))
              : widget,
        );
      },
    );

    if (overlayColor != null) {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[child, Container(color: overlayColor)],
      );
    }

    if (border != null || shadow != null || radius > 0 || onTap != null) {
      child = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: border,
          boxShadow: shadow == null ? null : <BoxShadow>[shadow!],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    return onTap == null ? child : GestureDetector(onTap: onTap, child: child);
  }
}

/// A network image with decoration, mirroring [AppImage]'s API.
///
/// Uses Flutter's built-in [Image.network] with the framework's own
/// [ImageCache] — no external dependency required.
class AppImageCached extends StatelessWidget {
  const AppImageCached({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.medium,
    this.overlayColor,
    this.border,
    this.shadow,
    this.onTap,
    this.alignment = Alignment.center,
    this.placeholderIcon,
    this.errorIcon,
    this.placeholderColor,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  /// Image URL.
  final String url;

  /// Width.
  final double? width;

  /// Height.
  final double? height;

  /// Box fit.
  final BoxFit fit;

  /// Corner radius.
  final double radius;

  /// Semi-transparent overlay color tint.
  final Color? overlayColor;

  /// Border decoration.
  final BoxBorder? border;

  /// Box shadow.
  final BoxShadow? shadow;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Image alignment.
  final Alignment alignment;

  /// Loading placeholder icon.
  final IconData? placeholderIcon;

  /// Error icon.
  final IconData? errorIcon;

  /// Placeholder background color.
  final Color? placeholderColor;

  /// Image fade-in duration.
  final Duration fadeInDuration;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color placeholderBg =
        placeholderColor ?? scheme.surfaceContainerHighest;

    Widget child = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return AnimatedOpacity(
            opacity: 1,
            duration: fadeInDuration,
            child: child,
          );
        }
        return Container(
          width: width,
          height: height,
          color: placeholderBg,
          child: Center(
            child: Icon(
              placeholderIcon ?? Icons.image_outlined,
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
        color: placeholderBg,
        child: Center(
          child: Icon(
            errorIcon ?? Icons.broken_image_outlined,
            size: 28,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );

    if (overlayColor != null) {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[child, Container(color: overlayColor)],
      );
    }

    if (border != null || shadow != null || radius > 0 || onTap != null) {
      child = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: border,
          boxShadow: shadow == null ? null : <BoxShadow>[shadow!],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    return onTap == null ? child : GestureDetector(onTap: onTap, child: child);
  }
}
