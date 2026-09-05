import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date/time helpers built on top of `intl`.
class AppDateUtils {
  const AppDateUtils._();

  /// Formats [date] with the given [pattern] and optional [locale].
  static String format(
    DateTime date,
    String pattern, {
    String locale = 'en',
  }) {
    final DateFormat format = DateFormat(pattern, locale);
    return format.format(date);
  }

  /// Formats a date as `dd MMM yyyy` (e.g. `03 Aug 2026`).
  static String formatDate(
    DateTime date, {
    String locale = 'en',
  }) =>
      format(date, 'dd MMM yyyy', locale: locale);

  /// Formats a date and time as `dd MMM yyyy HH:mm`.
  static String formatDateTime(
    DateTime date, {
    String locale = 'en',
  }) =>
      format(date, 'dd MMM yyyy HH:mm', locale: locale);

  /// Formats a date as a relative label (`Today`, `Yesterday`, `dd MMM`).
  static String formatRelative(
    DateTime date, {
    String locale = 'en',
  }) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime day = DateTime(date.year, date.month, date.day);
    final int diff = today.difference(day).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff == -1) return 'Tomorrow';
    return formatDate(date, locale: locale);
  }

  /// Formats a duration as `Xh Ym` or `Xm`.
  static String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  /// Formats a `DateTime` as a short time label.
  static String formatTime(
    DateTime date, {
    String locale = 'en',
  }) =>
      format(date, 'HH:mm', locale: locale);

  /// Returns whether [date] is today.
  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns whether [date] is in the past (before today, time-ignored).
  static bool isPast(DateTime date) {
    final DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return DateTime(date.year, date.month, date.day).isBefore(today);
  }

  /// Returns whether [date] is in the future (after today, time-ignored).
  static bool isFuture(DateTime date) {
    final DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return DateTime(date.year, date.month, date.day).isAfter(today);
  }

  /// Returns the number of days in [month] of [year].
  static int daysInMonth(int year, int month) {
    if (month == DateTime.december) {
      return DateTime(year + 1, DateTime.january, 0).day;
    }
    return DateTime(year, month + 1, 0).day;
  }

  /// Returns a [DateTimeRange] covering the whole current week (Mon–Sun).
  static DateTimeRange currentWeek() {
    final DateTime now = DateTime.now();
    final DateTime monday =
        now.subtract(Duration(days: now.weekday - DateTime.monday));
    final DateTime sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(start: monday, end: sunday);
  }

  /// Returns a [DateTimeRange] covering the whole current month.
  static DateTimeRange currentMonth() {
    final DateTime now = DateTime.now();
    final DateTime first = DateTime(now.year, now.month);
    final DateTime last =
        DateTime(now.year, now.month, daysInMonth(now.year, now.month));
    return DateTimeRange(start: first, end: last);
  }

  /// Returns a [DateTimeRange] covering the whole current year.
  static DateTimeRange currentYear() {
    final DateTime now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year),
      end: DateTime(now.year, 12, 31),
    );
  }

  /// Adds [days] to [date] ignoring time components.
  static DateTime addDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  /// Returns the start of the day for [date].
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Returns the end of the day for [date].
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  /// Returns the Monday of the week containing [date].
  static DateTime startOfWeek(DateTime date) =>
      addDays(startOfDay(date), DateTime.monday - date.weekday);

  /// Parses [text] using [pattern], returning `null` on failure.
  static DateTime? tryParse(String text, String pattern,
      {String locale = 'en'}) {
    try {
      final DateFormat format = DateFormat(pattern, locale);
      return format.parseStrict(text);
    } on FormatException {
      return null;
    }
  }
}
