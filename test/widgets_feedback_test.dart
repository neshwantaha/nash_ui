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
  group('Snackbar', () {
    testWidgets('shows a snackbar via ScaffoldMessenger', (tester) async {
      await pump(
        tester,
        Builder(
          builder: (BuildContext context) => Center(
            child: PrimaryButton(
              label: 'Go',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(Snackbar.success(context, 'Saved!'));
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pump();
      expect(find.text('Saved!'), findsOneWidget);
    });
  });

  group('Toast', () {
    testWidgets('shows an overlay toast', (tester) async {
      await pump(
        tester,
        Builder(
          builder: (BuildContext context) => Center(
            child: PrimaryButton(
              label: 'Notify',
              onPressed: () => Toast.show(context, 'Hello toast'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Notify'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Hello toast'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });

  group('Banner', () {
    testWidgets('renders a banner message', (tester) async {
      await pump(tester, const Banner(message: 'Sale ends soon'));
      expect(find.text('Sale ends soon'), findsOneWidget);
    });
  });

  group('Tooltip', () {
    testWidgets('wraps a child and shows tooltip text', (tester) async {
      await pump(
        tester,
        const Tooltip(
          message: 'Tip text',
          child: Text('Target'),
        ),
      );
      expect(find.text('Target'), findsOneWidget);
      final Tooltip tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Tip text');
    });
  });
}
