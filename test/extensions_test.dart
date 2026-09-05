import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

import 'helpers.dart';

void main() {
  setUpAll(initDateFormats);
  group('StringX', () {
    test('blank and case helpers', () {
      expect('  '.isBlank, isTrue);
      expect('hello'.capitalize, 'Hello');
      expect('hello world'.capitalizeWords, 'Hello World');
      expect('hello world'.toCamelCase, 'helloWorld');
      expect('Hello World'.toSnakeCase, 'hello_world');
      expect('Hello World'.toKebabCase, 'hello-world');
    });

    test('content checks', () {
      expect('abc123'.isAlphanumeric, isTrue);
      expect('abc'.isAlpha, isTrue);
      expect('123'.isDigits, isTrue);
      expect('abc123'.isAlpha, isFalse);
    });

    test('numeric parsing', () {
      expect('42'.toIntOr(), 42);
      expect('x'.toIntOr(-1), -1);
      expect('3.5'.toDoubleOr(), 3.5);
      expect('true'.toBoolOrNull(), isTrue);
      expect('yes'.toBoolOrNull(), isTrue);
      expect('0'.toBoolOrNull(), isFalse);
      expect('nope'.toBoolOrNull(), isNull);
    });

    test('cleaning helpers', () {
      expect('+1 (555) 123-4567'.onlyDigits, '15551234567');
      expect('a b\tc'.removeWhitespace, 'abc');
      expect('hello world'.truncate(5), 'hello…');
      expect('1234567890'.mask(), '••••••7890');
      expect('  '.toNullIfBlank, isNull);
      expect('x'.toNullIfBlank, 'x');
    });

    test('nullable helpers', () {
      expect((null as String?).isNullOrBlank, isTrue);
      expect(('' as String?).orEmpty, '');
    });
  });

  group('ColorX', () {
    const Color base = Color(0xFF4F46E5);

    test('withOpacity stays in range', () {
      // ignore: deprecated_member_use
      expect(base.withOpacity(0.5).a, closeTo(0.5, 0.01));
      // ignore: deprecated_member_use
      expect(base.withOpacity(1.0).a, 1);
    });

    test('lighten / darken / mix', () {
      expect(base.lighten(), isNot(base));
      expect(base.darken(), isNot(base));
      final Color half =
          const Color(0xFF000000).mixWith(const Color(0xFFFFFFFF));
      expect(half.r, closeTo(0.5, 0.01));
      expect(half.g, closeTo(0.5, 0.01));
      expect(half.b, closeTo(0.5, 0.01));
    });

    test('hex conversion round-trips', () {
      expect(base.toHex(), '#ff4f46e5');
      expect(base.toHex(withAlpha: false), '#4f46e5');
      expect('#4F46E5'.toColor(), base);
      expect('nothex'.toColor(), isNull);
    });

    test('hue helpers', () {
      expect(base.complementary, isNot(base));
      expect(base.rotateHue(180), base.complementary);
    });

    test('contrastText picks a readable color', () {
      expect(const Color(0xFFFFFFFF).contrastText, const Color(0xFF000000));
      expect(const Color(0xFF000000).contrastText, const Color(0xFFFFFFFF));
    });

    test('toMaterialColor produces a swatch', () {
      final MaterialColor swatch = base.toMaterialColor();
      expect(swatch.shade500, isNotNull);
      expect(swatch.toARGB32(), base.toARGB32());
    });

    test('colorFromString is deterministic', () {
      expect('alice'.colorFromString(), 'alice'.colorFromString());
      expect('alice'.colorFromString(), isNot('bob'.colorFromString()));
    });
  });

  group('DateX', () {
    final DateTime now = DateTime(2026, 8, 3, 14, 30);

    test('relative flags', () {
      expect(now.isToday, isFalse);
      expect(now.isSameDay(DateTime(2026, 8, 3)), isTrue);
      expect(now.isBeforeDay(DateTime(2026, 8, 4)), isTrue);
      expect(now.isAfterDay(DateTime(2026, 8, 2)), isTrue);
    });

    test('start/end boundaries', () {
      expect(now.startOfDay, DateTime(2026, 8, 3));
      expect(now.endOfDay.hour, 23);
      expect(now.startOfMonth, DateTime(2026, 8));
      expect(now.endOfMonth.day, 31);
      expect(now.startOfWeek.weekday, DateTime.monday);
      expect(now.endOfWeek.weekday, DateTime.sunday);
    });

    test('day math', () {
      expect(now.daysUntil(DateTime(2026, 8, 10)), 7);
      expect(
          now.isInRange(DateTimeRange(
              start: DateTime(2026, 8), end: DateTime(2026, 8, 31))),
          isTrue);
    });

    test('formatting', () {
      expect(now.formatDate, 'Aug 3, 2026');
      expect(now.monthName, 'August');
      expect(now.monthNameShort, 'Aug');
      expect(now.weekdayName, 'Monday');
      expect(now.toIsoDate, '2026-08-03');
      expect(now.age, isA<int>());
    });
  });

  group('AppDurationX', () {
    test('toClockTime', () {
      expect(const Duration(hours: 1, minutes: 2, seconds: 3).toClockTime,
          '01:02:03');
      expect(const Duration(minutes: 5, seconds: 7).toClockTime, '05:07');
    });

    test('toHuman', () {
      expect(const Duration(days: 2, hours: 3).toHuman, '2d 3h');
      expect(const Duration(hours: 1, minutes: 30).toHuman, '1h 30m');
      expect(const Duration(seconds: 45).toHuman, '45s');
    });
  });
}
