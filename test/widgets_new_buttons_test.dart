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
  group('GlassButton', () {
    testWidgets('renders label and icon and responds to tap', (tester) async {
      bool tapped = false;
      await pump(
        tester,
        GlassButton(
          label: 'Glass Action',
          icon: Icons.auto_awesome,
          onPressed: () => tapped = true,
        ),
      );
      expect(find.text('Glass Action'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

      await tester.tap(find.text('Glass Action'));
      expect(tapped, isTrue);
    });
  });

  group('GradientBorderButton', () {
    testWidgets('renders gradient border and text', (tester) async {
      bool tapped = false;
      await pump(
        tester,
        GradientBorderButton(
          label: 'Upgrade Pro',
          icon: Icons.bolt,
          onPressed: () => tapped = true,
        ),
      );
      expect(find.text('Upgrade Pro'), findsOneWidget);
      expect(find.byIcon(Icons.bolt), findsOneWidget);

      await tester.tap(find.text('Upgrade Pro'));
      expect(tapped, isTrue);
    });
  });

  group('SlideButton', () {
    testWidgets('renders initial label', (tester) async {
      await pump(
        tester,
        SlideButton(
          label: 'Slide to pay',
          onCompleted: () async {},
        ),
      );
      expect(find.text('Slide to pay'), findsOneWidget);
    });
  });

  group('SplitButton', () {
    testWidgets('renders main button and opens menu', (tester) async {
      bool mainTapped = false;
      bool optionTapped = false;

      await pump(
        tester,
        SplitButton(
          label: 'Publish',
          onPressed: () => mainTapped = true,
          actions: [
            SplitAction(
              label: 'Draft',
              onTap: () => optionTapped = true,
            ),
          ],
        ),
      );

      expect(find.text('Publish'), findsOneWidget);
      await tester.tap(find.text('Publish'));
      expect(mainTapped, isTrue);

      await tester.tap(find.byIcon(Icons.arrow_drop_down_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Draft'), findsOneWidget);

      await tester.tap(find.text('Draft'));
      await tester.pumpAndSettle();
      expect(optionTapped, isTrue);
    });
  });

  group('SocialButton', () {
    testWidgets('renders provider labels and fires taps', (tester) async {
      bool googleTapped = false;
      await pump(
        tester,
        SocialButton(
          provider: SocialProvider.google,
          onPressed: () => googleTapped = true,
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      await tester.tap(find.text('Continue with Google'));
      expect(googleTapped, isTrue);
    });
  });

  group('HoldButton', () {
    testWidgets('renders hold label', (tester) async {
      await pump(
        tester,
        HoldButton(
          label: 'Hold to Delete',
          onCompleted: () {},
        ),
      );

      expect(find.text('Hold to Delete'), findsOneWidget);
    });
  });

  group('ButtonGroup', () {
    testWidgets('renders all items and fires selection', (tester) async {
      String selected = 'Day';
      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => ButtonGroup<String>(
            selectedValue: selected,
            items: const [
              GroupItem(value: 'Day', label: 'Day'),
              GroupItem(value: 'Week', label: 'Week'),
              GroupItem(value: 'Month', label: 'Month'),
            ],
            onChanged: (v) => setState(() => selected = v),
          ),
        ),
      );

      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);

      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();
      expect(selected, 'Week');
    });
  });
}
