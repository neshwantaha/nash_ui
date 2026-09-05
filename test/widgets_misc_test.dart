import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

import 'helpers.dart';

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
  setUpAll(initDateFormats);

  group('Calendar', () {
    testWidgets('shows month title and selects a day', (tester) async {
      DateTime? selected;
      await pump(
        tester,
        Calendar(
          initialMonth: DateTime(2026, 8),
          initialSelected: DateTime(2026, 8, 3),
          onSelected: (DateTime d) => selected = d,
        ),
      );

      expect(find.textContaining('August'), findsOneWidget);

      await tester.tap(find.text('15'));
      expect(selected, DateTime(2026, 8, 15));
    });
  });

  group('Rating', () {
    testWidgets('shows numeric value', (tester) async {
      await pump(
          tester, const Rating(value: 4.5, showValue: true, count: '120'));
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(120)'), findsOneWidget);
    });
  });

  group('Timeline', () {
    testWidgets('renders timeline entries', (tester) async {
      await pump(
        tester,
        const Timeline(
          items: <TimelineItem>[
            TimelineItem(title: 'Created', time: '08:00'),
            TimelineItem(
                title: 'Shipped', time: '09:30', description: 'Parcel left'),
          ],
        ),
      );
      expect(find.text('Created'), findsOneWidget);
      expect(find.text('Shipped'), findsOneWidget);
      expect(find.text('Parcel left'), findsOneWidget);
    });
  });

  group('Tag', () {
    testWidgets('fires onRemoved', (tester) async {
      bool removed = false;
      await pump(
        tester,
        Tag(label: 'Filter', onRemoved: () => removed = true),
      );
      await tester.tap(find.byIcon(Icons.close));
      expect(removed, isTrue);
    });
  });

  group('Badge', () {
    testWidgets('renders a badge count', (tester) async {
      await pump(
        tester,
        const Badge(
          count: 7,
          child: Icon(Icons.notifications),
        ),
      );
      expect(find.text('7'), findsOneWidget);
    });
  });

  group('Stepper', () {
    testWidgets('renders steps with labels', (tester) async {
      await pump(
        tester,
        const Stepper(
          currentStep: 1,
          steps: <String>['Details', 'Payment', 'Done'],
        ),
      );
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });
  });

  group('NMedia', () {
    const List<int> kTransparentPng = <int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x62,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ];

    testWidgets('Image renders with a memory provider', (tester) async {
      await pump(
        tester,
        Image(image: MemoryImage(Uint8List.fromList(kTransparentPng))),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('NetworkImage handles invalid URLs', (tester) async {
      await pump(tester, const AppNetworkImage(url: 'not-a-url'));
      expect(tester.takeException(), isNull);
    });
  });
}
