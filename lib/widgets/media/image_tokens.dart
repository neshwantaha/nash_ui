/// Image placeholder, error, and skeleton configuration tokens.
abstract final class AppImageTokens {
  AppImageTokens._();

  /// Default placeholder aspect ratio.
  static const double placeholderAspectRatio = 1;

  /// Border radius for image containers.
  static const double borderRadius = 12;

  /// Default placeholder background color opacity.
  static const double placeholderOpacity = 0.08;

  /// Shimmer highlight opacity for loading placeholders.
  static const double shimmerHighlightOpacity = 0.3;

  /// Shimmer base opacity for loading placeholders.
  static const double shimmerBaseOpacity = 0.1;

  /// Duration of the shimmer animation cycle.
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// Default error icon size.
  static const double errorIconSize = 48;

  /// Default placeholder icon size.
  static const double placeholderIconSize = 48;
}

/// Image state for placeholder/error handling.
enum ImageState {
  /// Image is loading.
  loading,

  /// Image loaded successfully.
  loaded,

  /// Image failed to load.
  error,

  /// No image provided.
  empty,
}
