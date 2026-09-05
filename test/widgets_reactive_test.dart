import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

import 'helpers.dart';

void main() {
  setUpAll(initDateFormats);

  group('AppMasonry', () {
    testWidgets('renders the requested number of items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: Theme.light(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: AppMasonry(
                itemCount: 10,
                columnCount: 2,
                itemBuilder: (_, index) => SizedBox(
                  height: 100.0,
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AppMasonry), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Item 9'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('Item 9'), findsOneWidget);
    });

    testWidgets('throws when columnCount is not positive', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppMasonry(
              itemCount: 3,
              columnCount: 0,
              itemBuilder: (_, index) => const SizedBox(),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isA<ArgumentError>());
    });
  });

  group('ReactiveField', () {
    test('reports value and re-validates on update', () {
      final ReactiveField<String> email =
          ReactiveField<String>('a@b.com', validators: [V.email]);
      expect(email.isValid, isTrue);
      expect(email.currentError, isNull);

      email.update('not-an-email');
      expect(email.isValid, isFalse);
      expect(email.currentError, isNotNull);
    });

    test('isEmpty reflects blank input', () {
      final field = ReactiveField<String>('   ', validators: []);
      expect(field.isEmpty, isTrue);
      field.update('x');
      expect(field.isEmpty, isFalse);
    });
  });

  group('ReactiveFormController', () {
    test('tracks overall validity across fields', () {
      final email =
          ReactiveField<String>('a@b.com', validators: [V.required, V.email]);
      final password = ReactiveField<String>('', validators: [V.required]);
      final controller = ReactiveFormController()
        ..add('email', email)
        ..add('password', password);

      expect(controller.isValid, isFalse);
      expect(controller.valid.value, isFalse);

      password.update('secret123');
      expect(controller.isValid, isTrue);
      expect(controller.valid.value, isTrue);

      email.update('bad');
      expect(controller.isValid, isFalse);
    });

    test('collects typed values and rejects duplicates', () {
      final controller = ReactiveFormController()
        ..add('name', ReactiveField<String>('Nash'))
        ..add('age', ReactiveField<String>('30'));

      expect(controller.values, <String, dynamic>{'name': 'Nash', 'age': '30'});
      expect(
        () => controller.add('name', ReactiveField<String>('dup')),
        throwsArgumentError,
      );
    });

    test('submit blocks invalid while reset restores initials', () {
      final controller = ReactiveFormController();
      final email = ReactiveField<String>('a@b.com', validators: [V.email]);
      controller.add('email', email);

      final submitted = controller.submit();
      expect(submitted, isTrue);

      email.update('broken');
      expect(controller.submit(), isFalse);

      controller.reset();
      expect(email.value.value, 'a@b.com');
    });
  });
}
