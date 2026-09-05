/// Validation helpers and extension methods for common field checks.
library;

/// Extension on [String] providing common validation shortcuts.
extension StringValidationX on String {
  /// Whether this string is a valid email address.
  bool get isEmail => Validators.isEmail(this);

  /// Whether this string is a valid phone number.
  bool get isPhone => Validators.isPhone(this);

  /// Whether this string is a valid numeric value.
  bool get isNumber => Validators.isNumber(this);

  /// Whether this string is a valid URL.
  bool get isURL => Validators.isURL(this);

  /// Whether this string is a strong password.
  bool get isStrongPassword => Validators.isStrongPassword(this);

  /// Whether this string is a valid credit card number (Luhn).
  bool get isCreditCard => Validators.isCreditCard(this);

  /// Whether this string is a valid Arabic or English identifier.
  bool get isUsername => Validators.isUsername(this);
}

/// A collection of stateless validation functions.
class Validators {
  const Validators._();

  /// Returns `true` for a valid email address.
  static bool isEmail(String value) {
    if (value.trim().length > 254) return false;
    final RegExp regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
    );
    return regex.hasMatch(value.trim());
  }

  /// Returns `true` for a valid phone number (6–15 digits, optional prefix).
  static bool isPhone(String value) {
    final String cleaned = value.trim().replaceAll(' ', '');
    final RegExp regex = RegExp(r'^\+?[0-9]{6,15}$');
    return regex.hasMatch(cleaned);
  }

  /// Returns `true` for a valid numeric string (integer or decimal).
  static bool isNumber(String value) {
    final RegExp regex = RegExp(r'^[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$');
    return regex.hasMatch(value.trim());
  }

  /// Returns `true` for a valid URL.
  static bool isURL(String value) {
    final Uri? uri = Uri.tryParse(value.trim());
    if (uri == null) return false;
    return (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Returns `true` for a strong password (min 8 chars, mixed case + digit).
  static bool isStrongPassword(String value) {
    if (value.length < 8) return false;
    return RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value);
  }

  /// Returns `true` for a valid credit card number using the Luhn algorithm.
  static bool isCreditCard(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.length < 12 || cleaned.length > 19) return false;
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  /// Returns `true` for a valid username (3–20 chars, letters/digits/_).
  static bool isUsername(String value) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return regex.hasMatch(value);
  }

  /// Returns `true` when the value is empty or null-safe blank.
  static bool isBlank(String? value) => value == null || value.trim().isEmpty;

  /// Returns `true` when the value is not blank.
  static bool isNotBlank(String? value) => !isBlank(value);

  /// Returns `true` for an IBAN-format string (2 letters + digits).
  static bool isIBAN(String value) {
    final RegExp regex = RegExp(r'^[A-Za-z]{2}[0-9]{2}[A-Za-z0-9]{11,30}$');
    return regex.hasMatch(value.trim());
  }
}

/// Common validator functions returning an error message or `null`.
abstract class V {
  const V._();

  /// Validates that a value is not empty.
  static String? required(String? value,
          {String message = 'This field is required'}) =>
      Validators.isBlank(value) ? message : null;

  /// Validates an email address.
  static String? email(String? value,
      {String message = 'Enter a valid email address'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isEmail(value) ? null : message;
  }

  /// Validates a phone number.
  static String? phone(String? value,
      {String message = 'Enter a valid phone number'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isPhone(value) ? null : message;
  }

  /// Validates a strong password.
  static String? strongPassword(
    String? value, {
    String message =
        'Password must be at least 8 characters and include a number',
  }) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isStrongPassword(value) ? null : message;
  }

  /// Validates a minimum length.
  static String? minLength(String? value, int length, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.length >= length) return null;
    return message ?? 'Must be at least $length characters';
  }

  /// Validates a maximum length.
  static String? maxLength(String? value, int length, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.length <= length) return null;
    return message ?? 'Must be at most $length characters';
  }

  /// Validates a numeric value.
  static String? number(String? value,
      {String message = 'Enter a valid number'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isNumber(value) ? null : message;
  }

  /// Validates a URL.
  static String? url(String? value, {String message = 'Enter a valid URL'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isURL(value) ? null : message;
  }

  /// Validates a credit card number.
  static String? creditCard(String? value,
      {String message = 'Enter a valid card number'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isCreditCard(value) ? null : message;
  }

  /// Validates a username.
  static String? username(String? value,
      {String message = '3–20 letters, numbers or underscores'}) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.isUsername(value) ? null : message;
  }

  /// Validates two values match (e.g. confirm password).
  static String? Function(String?) match(String other,
          {String message = 'Values do not match'}) =>
      (String? value) => value == other ? null : message;
}
