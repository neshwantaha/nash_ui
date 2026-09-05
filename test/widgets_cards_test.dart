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
  group('StatisticCard', () {
    testWidgets('renders value and trend', (tester) async {
      await pump(
        tester,
        const StatisticCard(
          title: 'Revenue',
          value: '\$12,400',
          trend: '+12%',
        ),
      );
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('\$12,400'), findsOneWidget);
      expect(find.text('+12%'), findsOneWidget);
    });
  });

  group('DashboardCard', () {
    testWidgets('renders title and child', (tester) async {
      await pump(
        tester,
        const DashboardCard(
          title: 'Overview',
          child: Text('Content'),
        ),
      );
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('Card', () {
    testWidgets('renders children', (tester) async {
      await pump(tester, const Card(child: Text('Card body')));
      expect(find.text('Card body'), findsOneWidget);
    });
  });

  group('GradientCard', () {
    testWidgets('renders children on a gradient', (tester) async {
      await pump(tester, const GradientCard(child: Text('Gradient')));
      expect(find.text('Gradient'), findsOneWidget);
    });
  });

  group('ProductCard', () {
    testWidgets('renders price and fires actions', (tester) async {
      bool added = false;
      await pump(
        tester,
        ProductCard(
          title: 'Headphones',
          price: '\$99',
          oldPrice: '\$129',
          discount: '-20%',
          rating: 4.5,
          onAddToCart: () => added = true,
        ),
      );
      expect(find.text('Headphones'), findsOneWidget);
      expect(find.text('-20%'), findsOneWidget);

      await tester.ensureVisible(find.byTooltip('Add to cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Add to cart'));
      await tester.pump();
      expect(added, isTrue);
    });
  });

  group('UserCard', () {
    testWidgets('renders a user row', (tester) async {
      await pump(
          tester, const UserCard(name: 'Ada Lovelace', subtitle: 'Engineer'));
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
    });
  });

  group('MedicalCard', () {
    testWidgets('renders appointment info', (tester) async {
      await pump(
        tester,
        const MedicalCard(
          title: 'Dr. Smith',
          subtitle: 'Cardiology',
          time: '09:30',
          status: 'Confirmed',
        ),
      );
      expect(find.text('Dr. Smith'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
    });
  });

  group('LearningCard', () {
    testWidgets('renders course info', (tester) async {
      await pump(
        tester,
        const LearningCard(
          title: 'Flutter Basics',
          subtitle: '40 lessons',
          progress: 0.5,
        ),
      );
      expect(find.text('Flutter Basics'), findsOneWidget);
    });
  });

  group('DataTable', () {
    testWidgets('renders headers and rows', (tester) async {
      await pump(
        tester,
        const DataTable(
          columns: <String>['Name', 'Role'],
          rows: <List<DataCell>>[
            <DataCell>[
              DataCell(Text('Ada')),
              DataCell(Text('Engineer')),
            ],
          ],
        ),
      );
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
    });
  });

  group('ListTile', () {
    testWidgets('renders content and fires tap', (tester) async {
      bool tapped = false;
      await pump(
        tester,
        ListTile(
          title: const Text('Settings'),
          subtitle: const Text('Tap to open'),
          leading: const Icon(Icons.settings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => tapped = true,
        ),
      );
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('Avatar', () {
    testWidgets('renders initials fallback', (tester) async {
      await pump(tester, const Avatar(initials: 'NT'));
      expect(find.text('NT'), findsOneWidget);
    });
  });

  group('Rating', () {
    testWidgets('renders a value', (tester) async {
      await pump(tester, const Rating(value: 4.5));
      expect(tester.takeException(), isNull);
    });
  });

  group('Tag', () {
    testWidgets('renders label', (tester) async {
      await pump(tester, const Tag(label: 'Urgent'));
      expect(find.text('Urgent'), findsOneWidget);
    });
  });
}
