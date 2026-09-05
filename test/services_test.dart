import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  group('Storage', () {
    setUp(() {
      Storage.backend = MemoryBackend();
    });

    test('round-trips strings, ints, doubles and bools', () {
      Storage.writeString('name', 'nash');
      Storage.writeInt('age', 30);
      Storage.writeDouble('score', 9.5);
      Storage.writeBool('active', value: true);

      expect(Storage.readString('name'), 'nash');
      expect(Storage.readInt('age'), 30);
      expect(Storage.readDouble('score'), 9.5);
      expect(Storage.readBool('active'), isTrue);
    });

    test('readers return null for missing keys', () {
      expect(Storage.readString('missing'), isNull);
      expect(Storage.readInt('missing'), isNull);
      expect(Storage.readBool('missing'), isNull);
      expect(Storage.readJson('missing'), isNull);
    });

    test('round-trips JSON and bytes', () {
      Storage.writeJson('user', <String, Object>{
        'id': 1,
        'tags': <String>['a']
      });
      expect(Storage.readJson('user'), <String, Object>{
        'id': 1,
        'tags': <String>['a']
      });

      final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3, 250]);
      Storage.writeBytes('blob', bytes);
      expect(Storage.readBytes('blob'), bytes);
    });

    test('removes and clears', () {
      Storage.writeString('a', '1');
      Storage.writeString('b', '2');
      Storage.remove('a');
      expect(Storage.readString('a'), isNull);
      Storage.clear();
      expect(Storage.readString('b'), isNull);
    });

    test('invalid JSON decodes to null', () {
      Storage.backend.write('bad', 'not json{{');
      expect(Storage.readJson('bad'), isNull);
    });
  });

  group('Logger', () {
    setUp(() {
      Logger.enabled = true;
      Logger.level = LogLevel.debug;
    });

    test('logs through the sink', () {
      final StringBuffer buffer = StringBuffer();
      Logger.sink = buffer.writeln;
      Logger.i('hello');
      expect(buffer.toString(), contains('hello'));
    });

    test('levels filter output', () {
      final StringBuffer buffer = StringBuffer();
      Logger.sink = buffer.writeln;
      Logger.level = LogLevel.error;
      Logger.d('debug line');
      Logger.e('error line');
      expect(buffer.toString(), isNot(contains('debug line')));
      expect(buffer.toString(), contains('error line'));
    });

    test('disabled logger emits nothing', () {
      final StringBuffer buffer = StringBuffer();
      Logger.sink = buffer.writeln;
      Logger.enabled = false;
      Logger.w('nope');
      expect(buffer.toString(), isEmpty);
    });
  });

  group('Debouncer', () {
    test('only calls after the debounce window', () async {
      int calls = 0;
      final Debouncer debouncer = Debouncer(
        duration: const Duration(milliseconds: 50),
      );
      for (int i = 0; i < 3; i++) {
        debouncer.run(() => calls++);
      }
      expect(calls, 0);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(calls, 1);
      debouncer.dispose();
    });
  });
}
