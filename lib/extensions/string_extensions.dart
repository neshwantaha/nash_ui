/// String validation and transformation extensions.
extension StringX on String {
  /// Whether this string is empty or only whitespace.
  bool get isBlank => trim().isEmpty;

  /// Whether this string is a valid email address.
  bool get isEmail {
    if (length > 254) return false;
    final RegExp emailRegExp = RegExp(
      r'^[\w.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(this);
  }

  /// Whether this string is a valid phone number (loose check).
  bool get isPhoneNumber {
    final RegExp phoneRegExp = RegExp(r'^[+]?[\d\s\-()]{7,20}$');
    return phoneRegExp.hasMatch(trim());
  }

  /// Whether this string is a valid URL.
  bool get isUrl {
    final Uri? uri = Uri.tryParse(trim());
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  /// Whether this string is an integer.
  bool get isInt => int.tryParse(trim()) != null;

  /// Whether this string is a number (integer or decimal).
  bool get isNumber => double.tryParse(trim()) != null;

  /// Whether this string contains only letters and digits.
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Whether this string contains only letters.
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Whether this string contains only digits.
  bool get isDigits => RegExp(r'^\d+$').hasMatch(this);

  /// Capitalizes the first letter.
  String get capitalize =>
      isBlank ? this : substring(0, 1).toUpperCase() + substring(1);

  /// Capitalizes the first letter of every word.
  String get capitalizeWords {
    if (isBlank) return this;
    return trim()
        .split(RegExp(r'\s+'))
        .map((String w) => w.capitalize)
        .join(' ');
  }

  /// Converts to `camelCase`.
  String get toCamelCase {
    final List<String> parts = trim().split(RegExp(r'[\s_\-]+'));
    if (parts.isEmpty) return '';
    return parts.first.toLowerCase() +
        parts.skip(1).map((String p) => p.capitalize).join();
  }

  /// Converts to `snake_case`.
  String get toSnakeCase =>
      trim().replaceAll(RegExp(r'\s+'), '_').toLowerCase();

  /// Converts to `kebab-case`.
  String get toKebabCase =>
      trim().replaceAll(RegExp(r'\s+'), '-').toLowerCase();

  /// Keeps only digit characters.
  String get onlyDigits => replaceAll(RegExp(r'\D'), '');

  /// Removes all whitespace.
  String get removeWhitespace => replaceAll(RegExp(r'\s'), '');

  /// Truncates the string to [maxLength] characters, appending [suffix].
  String truncate(int maxLength, {String suffix = '…'}) {
    if (length <= maxLength) return this;
    return substring(0, maxLength).trimRight() + suffix;
  }

  /// Masks all but the last [visible] characters.
  String mask({int visible = 4, String maskChar = '•'}) {
    if (length <= visible) return this;
    return maskChar * (length - visible) + substring(length - visible);
  }

  /// Parses as [int], returning [fallback] on failure.
  int toIntOr([int fallback = 0]) => int.tryParse(trim()) ?? fallback;

  /// Parses as [double], returning [fallback] on failure.
  double toDoubleOr([double fallback = 0]) =>
      double.tryParse(trim()) ?? fallback;

  /// Parses as [bool].
  bool? toBoolOrNull() {
    final String v = trim().toLowerCase();
    if (v == 'true' || v == '1' || v == 'yes') return true;
    if (v == 'false' || v == '0' || v == 'no') return false;
    return null;
  }

  /// Returns `null` when blank.
  String? get toNullIfBlank => isBlank ? null : this;

  /// Whether this string has a strong password shape
  /// (>= 8 chars, upper, lower, digit).
  bool get isStrongPassword {
    if (length < 8) return false;
    return contains(RegExp(r'[A-Z]')) &&
        contains(RegExp(r'[a-z]')) &&
        contains(RegExp(r'\d'));
  }

  /// Converts this string to title case (e.g. 'hello world' -> 'Hello World').
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((String word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Converts this string to URL-friendly slug (e.g. 'Hello World!' -> 'hello-world').
  String toSlug() => toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'[\s_-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  /// Parses this string as a [DateTime], or returns `null` on failure.
  DateTime? toDate() => DateTime.tryParse(trim());

  /// Truncates string to [maxLength] characters, appending [ellipsis].
  String ellipsize(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }
}

/// Null-safe string helpers.
extension StringNullX on String? {
  /// Whether the value is null or blank.
  bool get isNullOrBlank => this == null || this!.isBlank;

  /// Returns the value or an empty string.
  String get orEmpty => this ?? '';
}
