import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: Theme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(child: child),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('buttons render', (WidgetTester tester) async {
    await pump(
      tester,
      Column(
        children: <Widget>[
          PrimaryButton(label: 'Primary', onPressed: () {}),
          SecondaryButton(label: 'Secondary', onPressed: () {}),
          OutlineButton(label: 'Outline', onPressed: () {}),
          TextButton(label: 'Text', onPressed: () {}),
          IconButton(icon: Icons.favorite, onPressed: () {}),
        ],
      ),
    );
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Outline'), findsOneWidget);
    expect(find.text('Text'), findsOneWidget);
  });

  testWidgets('chips and tags render', (WidgetTester tester) async {
    await pump(
      tester,
      Wrap(
        children: <Widget>[
          Chip(label: 'Filter', onPressed: () {}),
          const Chip(label: 'Selected', selected: true),
          Tag(label: 'Tag', onRemoved: () {}),
          const Tag(label: 'Outlined', outlined: true),
        ],
      ),
    );
    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('Selected'), findsOneWidget);
    expect(find.text('Tag'), findsOneWidget);
    expect(find.text('Outlined'), findsOneWidget);
  });

  testWidgets('charts render', (WidgetTester tester) async {
    await pump(
      tester,
      const Column(
        children: <Widget>[
          LineChart(
              points: [ChartPoint(0, 1), ChartPoint(1, 2), ChartPoint(2, 3)],
              labels: <String>['a', 'b', 'c']),
          BarChart(bars: [
            BarData(label: 'a', value: 1),
            BarData(label: 'b', value: 2),
            BarData(label: 'c', value: 3)
          ]),
          PieChart(
            segments: <PieSegment>[
              PieSegment(value: 1, label: 'One', color: Colors.red),
              PieSegment(value: 2, label: 'Two', color: Colors.blue),
            ],
          ),
          Sparkline(data: <double>[1, 3, 2, 4]),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading widgets render', (WidgetTester tester) async {
    await pump(
      tester,
      const Column(
        children: <Widget>[
          Skeleton(width: 100),
          SizedBox(height: 8),
          SkeletonList(itemCount: 2),
          LoadingScreen(title: 'Loading', subtitle: 'Please wait'),
        ],
      ),
    );
    expect(find.text('Loading'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ux states render', (WidgetTester tester) async {
    await pump(
      tester,
      const Column(
        children: <Widget>[
          EmptyState(title: 'Nothing here', message: 'Empty'),
          ErrorState(title: 'Oops'),
          OfflineState(),
        ],
      ),
    );
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Oops'), findsOneWidget);
  });

  testWidgets('form helpers render', (WidgetTester tester) async {
    await pump(
      tester,
      const FormSection(
        title: 'Details',
        children: <Widget>[
          LabeledField(
            label: 'Name',
            child: TextField(label: 'Full name'),
          ),
        ],
      ),
    );
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
  });

  testWidgets('templates render', (WidgetTester tester) async {
    await pump(
      tester,
      ProfileHeader(
        name: 'Ada',
        bio: 'Builder',
        stats: const <ProfileStat>[
          ProfileStat(label: 'Posts', value: '10'),
        ],
        onFollow: () {},
      ),
    );
    expect(find.text('Ada'), findsOneWidget);
  });

  testWidgets('theme extension exposes app bar colors',
      (WidgetTester tester) async {
    await pump(tester, const SizedBox.shrink());
    final BuildContext context = tester.element(find.byType(SizedBox));
    expect(AppThemeExtension.of(context).appBar, isNotNull);
    expect(AppColors.forFeedback(AppFeedbackType.success), AppColors.success);
  });
}
