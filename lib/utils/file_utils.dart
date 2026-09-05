/// Pure-Dart file/path helpers that work on every Flutter platform.
///
/// Anything touching the real filesystem should use `dart:io` (or a plugin)
/// at the call site; these helpers only deal with names and sizes.
abstract final class FileUtils {
  FileUtils._();

  /// Returns the extension of [path] including the dot, or `''` when absent.
  ///
  /// ```dart
  /// FileUtils.extensionOf('reports/q3.pdf') // '.pdf'
  /// ```
  static String extensionOf(String path) {
    final int dot = path.lastIndexOf('.');
    final int slash = path.lastIndexOf(RegExp(r'[/\\]'));
    if (dot <= slash || dot == path.length - 1) return '';
    return path.substring(dot);
  }

  /// Returns the file name (last path segment) of [path].
  static String fileName(String path) {
    final int slash = path.lastIndexOf(RegExp(r'[/\\]'));
    return slash == -1 ? path : path.substring(slash + 1);
  }

  /// Returns the directory portion of [path] (without the trailing slash).
  static String directory(String path) {
    final int slash = path.lastIndexOf(RegExp(r'[/\\]'));
    if (slash <= 0) return slash == 0 ? path.substring(0, 1) : '.';
    return path.substring(0, slash);
  }

  /// Formats a byte count as a human-readable size.
  ///
  /// ```dart
  /// FileUtils.sizeLabel(1536) // '1.5 KB'
  /// ```
  static String sizeLabel(int bytes, {int decimals = 1}) {
    if (bytes < 1024) return '$bytes B';
    const List<String> units = <String>['KB', 'MB', 'GB', 'TB', 'PB'];
    double value = bytes.toDouble();
    int unit = -1;
    do {
      value /= 1024;
      unit++;
    } while (value >= 1024 && unit < units.length - 1);
    final String text = value.toStringAsFixed(decimals);
    return '$text ${units[unit]}';
  }

  /// Whether [name] is one of [extensions] (case-insensitive, no dot needed).
  static bool hasExtension(String name, List<String> extensions) {
    final String ext = extensionOf(name).toLowerCase();
    return extensions.any((String e) => ext == '.${e.toLowerCase()}');
  }

  /// Whether [name] looks like an image file.
  static bool isImage(String name) => hasExtension(name, const <String>[
        'png',
        'jpg',
        'jpeg',
        'gif',
        'webp',
        'bmp',
        'svg',
        'heic',
        'heif'
      ]);

  /// Whether [name] looks like a video file.
  static bool isVideo(String name) => hasExtension(
      name, const <String>['mp4', 'mkv', 'webm', 'mov', 'avi', 'm4v']);

  /// Whether [name] looks like an audio file.
  static bool isAudio(String name) => hasExtension(
      name, const <String>['mp3', 'wav', 'aac', 'ogg', 'm4a', 'flac']);

  /// Whether [name] looks like a compressed archive.
  static bool isArchive(String name) =>
      hasExtension(name, const <String>['zip', 'rar', '7z', 'tar', 'gz']);
}
