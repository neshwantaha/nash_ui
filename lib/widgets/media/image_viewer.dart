import 'package:flutter/material.dart';

/// Fullscreen zoomable and pannable image viewer modal with swipe-to-dismiss.
///
/// ```dart
/// ImageViewer.show(
///   context,
///   image: NetworkImage('https://example.com/photo.jpg'),
///   title: 'Profile Photo',
/// );
/// ```
class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.imageProvider,
    this.title,
    this.heroTag,
    this.backgroundColor = Colors.black,
    this.minScale = 0.8,
    this.maxScale = 4.0,
  });

  final ImageProvider imageProvider;
  final String? title;
  final Object? heroTag;
  final Color backgroundColor;
  final double minScale;
  final double maxScale;

  /// Shows the image viewer in a fullscreen dialog route.
  static Future<void> show(
    BuildContext context, {
    required ImageProvider image,
    String? title,
    Object? heroTag,
    Color backgroundColor = Colors.black,
  }) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withAlpha(200),
          pageBuilder: (_, __, ___) => ImageViewer(
            imageProvider: image,
            title: title,
            heroTag: heroTag,
            backgroundColor: backgroundColor,
          ),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image(
      image: imageProvider,
      fit: BoxFit.contain,
    );

    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: title != null ? Text(title!) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: minScale,
          maxScale: maxScale,
          clipBehavior: Clip.none,
          child: imageWidget,
        ),
      ),
    );
  }
}
