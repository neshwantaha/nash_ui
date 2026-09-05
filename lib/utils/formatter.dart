import 'package:intl/intl.dart';

/// Number and text formatting helpers.
class Formatter {
  const Formatter._();

  /// Formats [value] with thousands separators (e.g. `1,234,567`).
  static String number(num value, {String? locale}) {
    final NumberFormat format = NumberFormat.decimalPattern(locale);
    return format.format(value);
  }

  /// Formats [value] with a fixed number of [decimals].
  static String decimal(num value, {int decimals = 2, String? locale}) {
    final NumberFormat format = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return format.format(value);
  }

  /// Formats a currency amount using [symbol].
  static String currency(num value,
      {String symbol = '\$', int decimals = 2, String? locale}) {
    final NumberFormat format = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return '$symbol${format.format(value)}';
  }

  /// Formats [value] as a compact number (e.g. `1.2K`, `3.4M`).
  static String compact(num value, {String? locale}) {
    final NumberFormat format = NumberFormat.compact(locale: locale);
    return format.format(value);
  }

  /// Formats a perceTage (e.g. `12.5%`).
  static String percent(num value, {int decimals = 1}) =>
      '${decimal(value, decimals: decimals)}%';

  /// Masks a card number keeping the first 4 and last 4 digits.
  static String maskCard(String cardNumber) {
    final String cleaned = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.length <= 8) return cleaned;
    return '${cleaned.substring(0, 4)} •••• ${cleaned.substring(cleaned.length - 4)}';
  }

  /// Masks a phone number keeping the last 4 digits.
  static String maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return '••••••${phone.substring(phone.length - 4)}';
  }

  /// Masks an email address.
  static String maskEmail(String email) {
    final int at = email.indexOf('@');
    if (at <= 1) return email;
    return '${email.substring(0, 1)}•••${email.substring(at)}';
  }

  /// Truncates [text] to [maxLength] and appends an ellipsis.
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trimRight()}…';
  }

  /// Capitalizes the first letter of each word.
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.trim().split(RegExp(r'\s+')).map((String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
