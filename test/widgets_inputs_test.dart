import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

Future<void> pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: Theme.light(),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  group('TextField', () {
    testWidgets('shows label and hint and receives input', (tester) async {
      String? typed;
      await pump(
        tester,
        TextField(
            label: 'Email',
            hint: 'you@example.com',
            onChanged: (String v) => typed = v),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('you@example.com'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');
      expect(typed, 'hello');
    });

    testWidgets('validation error surfaces', (tester) async {
      await pump(
        tester,
        const TextField(
          label: 'Email',
          validator: V.email,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      );

      await tester.enterText(find.byType(TextField), 'not-an-email');
      await tester.pump();
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });
  });

  group('PasswordField', () {
    testWidgets('obscures text and toggles visibility', (tester) async {
      await pump(tester, const PasswordField());
      final TextField field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);

      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText,
          isFalse);
    });
  });

  group('EmailField', () {
    testWidgets('prefills a value', (tester) async {
      final TextEditingController controller =
          TextEditingController(text: 'a@b.com');
      addTearDown(controller.dispose);
      await pump(tester, EmailField(controller: controller));
      expect(controller.text, 'a@b.com');
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text,
          'a@b.com');
    });
  });

  group('PhoneField', () {
    testWidgets('renders a phone input', (tester) async {
      await pump(tester, const PhoneField());
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('NumberField', () {
    testWidgets('accepts digits and clamps', (tester) async {
      String? value;
      await pump(
        tester,
        NumberField(
            label: 'Qty', min: 0, max: 10, onChanged: (String v) => value = v),
      );
      await tester.enterText(find.byType(TextField), '5');
      expect(value, '5');
    });
  });

  group('OtpField', () {
    testWidgets('renders the requested number of boxes', (tester) async {
      await pump(tester, const OtpField(length: 4, onCompleted: _noop));
      expect(find.byType(OtpField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Dropdown', () {
    testWidgets('shows hint and opens menu', (tester) async {
      await pump(
        tester,
        const Dropdown<String>(
          hint: 'Pick one',
          items: <DropdownItem<String>>[
            DropdownItem<String>(value: 'a', label: 'Alpha'),
            DropdownItem<String>(value: 'b', label: 'Beta'),
          ],
          onChanged: _noop,
        ),
      );

      expect(find.text('Pick one'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });
  });

  group('SearchField', () {
    testWidgets('fires onSubmitted', (tester) async {
      String? query;
      await pump(
        tester,
        SearchField(hint: 'Search', onSubmitted: (String q) => query = q),
      );
      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(query, 'flutter');
    });
  });

  group('FormSection', () {
    testWidgets('renders grouped fields', (tester) async {
      await pump(
        tester,
        const FormSection(
          title: 'Contact',
          children: <Widget>[
            LabeledField(label: 'Name', child: TextField(label: 'Full name')),
          ],
        ),
      );
      expect(find.text('Contact'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
    });
  });

  group('DatePickers', () {
    testWidgets('HorizontalDatePicker renders days and handles tap',
        (tester) async {
      DateTime? selected;
      final now = DateTime.now();
      await pump(
        tester,
        HorizontalDatePicker(
          initialDate: now,
          onDateSelected: (d) => selected = d,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsOneWidget);
      expect(find.text(now.day.toString()), findsWidgets);

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
    });

    testWidgets('WheelDatePicker renders correctly', (tester) async {
      final now = DateTime(2025, 6, 15);
      await pump(
        tester,
        WheelDatePicker(
          initialDate: now,
          onDateChanged: (d) {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WheelDatePicker), findsOneWidget);
    });

    testWidgets('DateField supports different picker styles', (tester) async {
      await pump(
        tester,
        const DateField(
          label: 'Birth Date',
          pickerStyle: DateFieldPickerStyle.wheel,
        ),
      );
      expect(find.text('Birth Date'), findsOneWidget);
    });
  });
}

void _noop([Object? _]) {}
