/// Image helpers: initials, URL detection and aspect-ratio math.
abstract final class ImageUtils {
  ImageUtils._();

  /// Builds a short initials string from [name] (max [maxChars] characters).
  ///
  /// ```dart
  /// ImageUtils.initials('Nash Taha') // 'NT'
  /// ImageUtils.initials('Ada')       // 'A'
  /// ```
  static String initials(String? name,
      {int maxChars = 2, String fallback = '?'}) {
    if (name == null || name.trim().isEmpty) return fallback;
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    final StringBuffer buffer = StringBuffer();
    for (final String part in parts) {
      buffer.write(part[0]);
      if (buffer.length >= maxChars) break;
    }
    final String result = buffer.toString().toUpperCase();
    return result.isEmpty ? fallback : result;
  }

  /// Whether [value] is an `http(s)` image URL.
  static bool isNetworkUrl(String value) {
    final Uri? uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Whether [value] is a local asset path (starts with `assets/`).
  static bool isAssetPath(String value) =>
      value.trimLeft().toLowerCase().startsWith('assets/');

  /// Whether [value] is a `data:` URI.
  static bool isDataUri(String value) =>
      value.trimLeft().toLowerCase().startsWith('data:');

  /// The aspect ratio of [width] / [height] (1.0 when height is 0).
  static double aspectRatio(double width, double height) {
    if (height == 0) return 1;
    return width / height;
  }

  /// Height that keeps the given [aspectRatio] for [width].
  static double heightForWidth(double width, double aspectRatio) {
    if (aspectRatio <= 0) return width;
    return width / aspectRatio;
  }

  /// Width that keeps the given [aspectRatio] for [height].
  static double widthForHeight(double height, double aspectRatio) {
    if (aspectRatio <= 0) return height;
    return height * aspectRatio;
  }
}
