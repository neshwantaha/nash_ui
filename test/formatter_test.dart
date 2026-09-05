import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

import 'helpers.dart';

void main() {
  setUpAll(initDateFormats);
  group('Formatter', () {
    test('number adds thousands separators', () {
      expect(Formatter.number(1234567), '1,234,567');
      expect(Formatter.number(1000), '1,000');
    });

    test('decimal fixes precision', () {
      expect(Formatter.decimal(3.14159), '3.14');
      expect(Formatter.decimal(2, decimals: 3), '2.000');
    });

    test('currency prefixes a symbol', () {
      expect(Formatter.currency(99.9), '\$99.90');
      expect(Formatter.currency(5, symbol: '€'), '€5.00');
    });

    test('compact shortens large numbers', () {
      expect(Formatter.compact(1200), '1.2K');
      expect(Formatter.compact(3400000), '3.4M');
    });

    test('percent formats values', () {
      expect(Formatter.percent(12.5), '12.5%');
      expect(Formatter.percent(50, decimals: 0), '50%');
    });

    test('maskCard keeps first and last four', () {
      expect(Formatter.maskCard('4111 1111 1111 1111'), '4111 •••• 1111');
      expect(Formatter.maskCard('1234'), '1234');
    });

    test('maskPhone keeps the last four', () {
      expect(Formatter.maskPhone('+972500000000'), '••••••0000');
      expect(Formatter.maskPhone('1234'), '1234');
    });

    test('maskEmail keeps first letter and domain', () {
      expect(Formatter.maskEmail('nash@example.com'), 'n•••@example.com');
      expect(Formatter.maskEmail('a@b.com'), 'a@b.com');
    });

    test('truncate appends an ellipsis', () {
      expect(Formatter.truncate('hello world', 5), 'hello…');
      expect(Formatter.truncate('hi', 5), 'hi');
    });

    test('titleCase capitalizes each word', () {
      expect(Formatter.titleCase('hello world'), 'Hello World');
      expect(Formatter.titleCase('  nash  taha '), 'Nash Taha');
      expect(Formatter.titleCase(''), '');
    });
  });

  group('AppDateUtils', () {
    test('format uses patterns', () {
      final DateTime date = DateTime(2026, 8, 3, 14, 30);
      expect(AppDateUtils.formatDate(date), '03 Aug 2026');
      expect(AppDateUtils.formatTime(date), '14:30');
    });

    test('relative labels', () {
      final DateTime now = DateTime.now();
      expect(AppDateUtils.formatRelative(now), 'Today');
      expect(
        AppDateUtils.formatRelative(now.subtract(const Duration(days: 1))),
        'Yesterday',
      );
    });

    test('formatDuration', () {
      expect(AppDateUtils.formatDuration(const Duration(hours: 2, minutes: 5)),
          '2h 5m');
      expect(AppDateUtils.formatDuration(const Duration(minutes: 45)), '45m');
    });

    test('today / past / future checks', () {
      expect(AppDateUtils.isToday(DateTime.now()), isTrue);
      expect(
        AppDateUtils.isPast(DateTime.now().subtract(const Duration(days: 1))),
        isTrue,
      );
      expect(
        AppDateUtils.isFuture(DateTime.now().add(const Duration(days: 1))),
        isTrue,
      );
    });

    test('daysInMonth', () {
      expect(AppDateUtils.daysInMonth(2026, 2), 28);
      expect(AppDateUtils.daysInMonth(2024, 2), 29);
      expect(AppDateUtils.daysInMonth(2026, 4), 30);
    });

    test('week and month ranges', () {
      final DateTimeRange week = AppDateUtils.currentWeek();
      expect(week.start.weekday, DateTime.monday);
      expect(week.duration.inDays, 6);

      final DateTimeRange month = AppDateUtils.currentMonth();
      expect(month.start.day, 1);
    });

    test('startOfWeek returns a Monday', () {
      final DateTime date = DateTime(2026, 8, 13);
      final DateTime monday = AppDateUtils.startOfWeek(date);
      expect(monday.weekday, DateTime.monday);
    });

    test('tryParse returns null on failure', () {
      expect(AppDateUtils.tryParse('03/08/2026', 'dd/MM/yyyy'), isNotNull);
      expect(AppDateUtils.tryParse('not a date', 'dd/MM/yyyy'), isNull);
    });
  });
}
