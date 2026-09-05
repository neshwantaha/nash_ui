import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  group('Validators', () {
    test('isEmail accepts valid addresses', () {
      expect(Validators.isEmail('user@example.com'), isTrue);
      expect(Validators.isEmail('first.last@sub.domain.co'), isTrue);
      expect(Validators.isEmail('a+b@example.io'), isTrue);
    });

    test('isEmail rejects invalid addresses', () {
      expect(Validators.isEmail('plain'), isFalse);
      expect(Validators.isEmail('a@b'), isFalse);
      expect(Validators.isEmail('@example.com'), isFalse);
      expect(Validators.isEmail('user@'), isFalse);
      expect(Validators.isEmail('user @example.com'), isFalse);
    });

    test('isPhone accepts digits with optional plus prefix', () {
      expect(Validators.isPhone('+972500000000'), isTrue);
      expect(Validators.isPhone('0550000000'), isTrue);
      expect(Validators.isPhone('+1 555 555 5555'), isTrue);
      expect(Validators.isPhone('12345'), isFalse);
      expect(Validators.isPhone('callme'), isFalse);
    });

    test('isNumber handles ints, decimals and exponents', () {
      expect(Validators.isNumber('42'), isTrue);
      expect(Validators.isNumber('-3.14'), isTrue);
      expect(Validators.isNumber('.5'), isTrue);
      expect(Validators.isNumber('1e3'), isTrue);
      expect(Validators.isNumber('12a'), isFalse);
      expect(Validators.isNumber(''), isFalse);
    });

    test('isURL only accepts http(s) URLs', () {
      expect(Validators.isURL('https://example.com/path'), isTrue);
      expect(Validators.isURL('http://localhost:8080'), isTrue);
      expect(Validators.isURL('ftp://example.com'), isFalse);
      expect(Validators.isURL('not a url'), isFalse);
    });

    test('isStrongPassword enforces length and character classes', () {
      expect(Validators.isStrongPassword('Password1'), isTrue);
      expect(Validators.isStrongPassword('Password!@#'), isFalse);
      expect(Validators.isStrongPassword('password1'), isFalse);
      expect(Validators.isStrongPassword('Password'), isFalse);
      expect(Validators.isStrongPassword('Short1'), isFalse);
    });

    test('isCreditCard uses Luhn', () {
      expect(Validators.isCreditCard('4111 1111 1111 1111'), isTrue);
      expect(Validators.isCreditCard('5500005555555559'), isTrue);
      expect(Validators.isCreditCard('4111111111111112'), isFalse);
      expect(Validators.isCreditCard('1234'), isFalse);
    });

    test('isUsername allows 3-20 word chars', () {
      expect(Validators.isUsername('nashwan_taha'), isTrue);
      expect(Validators.isUsername('ab'), isFalse);
      expect(Validators.isUsername('has space'), isFalse);
      expect(Validators.isUsername('has-dash'), isFalse);
    });

    test('blank helpers', () {
      expect(Validators.isBlank(null), isTrue);
      expect(Validators.isBlank('  '), isTrue);
      expect(Validators.isNotBlank('x'), isTrue);
    });

    test('isIBAN accepts standard shape', () {
      expect(Validators.isIBAN('DE89370400440532013000'), isTrue);
      expect(Validators.isIBAN('DE89'), isFalse);
    });
  });

  group('V helper validators', () {
    test('required returns message for blanks', () {
      expect(V.required(null), isNotNull);
      expect(V.required('   '), isNotNull);
      expect(V.required('ok'), isNull);
    });

    test('email returns null for empty values', () {
      expect(V.email(''), isNull);
      expect(V.email(null), isNull);
      expect(V.email('a@b.com'), isNull);
      expect(V.email('bad'), isNotNull);
    });

    test('minLength and maxLength', () {
      expect(V.minLength('abc', 3), isNull);
      expect(V.minLength('ab', 3), isNotNull);
      expect(V.maxLength('abc', 3), isNull);
      expect(V.maxLength('abcd', 3), isNotNull);
    });

    test('match compares values', () {
      final String? Function(String?) matcher = V.match('secret');
      expect(matcher('secret'), isNull);
      expect(matcher('other'), isNotNull);
    });
  });

  group('StringX extension', () {
    test('validation getters delegate correctly', () {
      expect(Validators.isEmail('a@b.com'), isTrue);
      expect(Validators.isPhone('0550000000'), isTrue);
      expect(Validators.isNumber('42'), isTrue);
      expect(Validators.isURL('https://x.dev'), isTrue);
      expect(Validators.isStrongPassword('Password1'), isTrue);
      expect(Validators.isCreditCard('4111111111111111'), isTrue);
      expect(Validators.isUsername('nashwan_taha'), isTrue);
    });
  });
}
