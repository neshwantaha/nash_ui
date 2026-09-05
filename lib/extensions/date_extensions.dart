import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date utilities as extensions on [DateTime].
extension DateX on DateTime {
  /// Whether this date is today.
  bool get isToday {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is yesterday.
  bool get isYesterday {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Whether this date is tomorrow.
  bool get isTomorrow {
    final DateTime now = DateTime.now();
    final DateTime tomorrow = now.add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Copy of this date at 00:00:00.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Copy of this date at 23:59:59.999.
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Copy of this date at the start of its month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Copy of this date at the end of its month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// First day of the week containing this date (Monday-first).
  DateTime get startOfWeek {
    final DateTime start = startOfDay;
    return start.subtract(Duration(days: start.weekday - DateTime.monday));
  }

  /// Last day of the week containing this date (Sunday-last).
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));

  /// Whole days between this date and [other] (`other - this`).
  int daysUntil(DateTime other) =>
      other.startOfDay.difference(startOfDay).inDays;

  /// Whether [other] falls on the same calendar day.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Whether this date is before [other] ignoring time.
  bool isBeforeDay(DateTime other) => startOfDay.isBefore(other.startOfDay);

  /// Whether this date is after [other] ignoring time.
  bool isAfterDay(DateTime other) => startOfDay.isAfter(other.startOfDay);

  /// Whether this date falls inside [range].
  bool isInRange(DateTimeRange range) =>
      !startOfDay.isBefore(range.start.startOfDay) &&
      !startOfDay.isAfter(range.end.endOfDay);

  /// Formats using an [intl] [pattern] and optional [locale].
  String format(String pattern, {String? locale}) =>
      DateFormat(pattern, locale).format(this);

  /// Short date, e.g. `Aug 3, 2026`.
  String get formatDate => format('MMM d, yyyy');

  /// Short time, e.g. `10:30 AM`.
  String get formatTime => format('h:mm a');

  /// Date + time, e.g. `Aug 3, 2026, 10:30 AM`.
  String get formatDateTime => format('MMM d, yyyy, h:mm a');

  /// Year only.
  String get formatYear => format('yyyy');

  /// Age in full years.
  int get age {
    final DateTime now = DateTime.now();
    int years = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Month name, e.g. `August`.
  String get monthName => format('MMMM');

  /// Short month name, e.g. `Aug`.
  String get monthNameShort => format('MMM');

  /// Weekday name, e.g. `Monday`.
  String get weekdayName => format('EEEE');

  /// Short weekday name, e.g. `Mon`.
  String get weekdayNameShort => format('EEE');

  /// ISO 8601 string, e.g. `2026-08-03`.
  String get toIsoDate => DateFormat('yyyy-MM-dd').format(this);
}

/// Formatting helpers for durations.
extension AppDurationX on Duration {
  /// `HH:MM:SS`.
  String get toClockTime {
    final String h = inHours.toString().padLeft(2, '0');
    final String m = (inMinutes % 60).toString().padLeft(2, '0');
    final String s = (inSeconds % 60).toString().padLeft(2, '0');
    return inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  /// `Xh Ym` or `Xm` for zero hours.
  String get toHuman {
    if (inDays > 0) return '${inDays}d ${inHours % 24}h';
    if (inHours > 0) return '${inHours}h ${inMinutes % 60}m';
    if (inMinutes > 0) return '${inMinutes}m ${inSeconds % 60}s';
    return '${inSeconds}s';
  }
}
