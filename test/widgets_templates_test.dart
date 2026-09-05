import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

import 'helpers.dart';

Future<void> pump(WidgetTester tester, Widget child,
    {double width = 900, double height = 800}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: Theme.light(),
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  setUpAll(initDateFormats);
  testWidgets('SettingsTemplate renders groups and tiles', (tester) async {
    await pump(
      tester,
      const SettingsTemplate(
        title: 'Settings',
        groups: <SettingsGroup>[
          SettingsGroup(
            title: 'Preferences',
            tiles: <SettingsTile>[
              SettingsTile(
                  title: 'Notifications', icon: Icons.notifications_outlined),
              SettingsTile(title: 'Dark mode', icon: Icons.dark_mode_outlined),
            ],
          ),
        ],
      ),
    );
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
  });

  testWidgets('ChatTemplate renders bubbles and sends messages',
      (tester) async {
    String? sent;
    await pump(
      tester,
      ChatTemplate(
        title: 'Sarah',
        messages: <ChatMessage>[
          ChatMessage(text: 'Hey there!', time: DateTime(2026, 8, 3, 9)),
          ChatMessage(
              text: 'Hi!', time: DateTime(2026, 8, 3, 9, 1), isMine: true),
        ],
        onSend: (String text) => sent = text,
      ),
    );
    expect(find.text('Sarah'), findsOneWidget);
    expect(find.text('Hey there!'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).last, 'Great!');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
    expect(sent, 'Great!');
  });

  testWidgets('LearningTemplate renders courses', (tester) async {
    await pump(
      tester,
      const LearningTemplate(
        title: 'Learning',
        courses: <Course>[
          Course(
              title: 'Flutter Basics', subtitle: '40 lessons', progress: 0.5),
        ],
      ),
    );
    expect(find.text('Learning'), findsOneWidget);
    expect(find.text('Flutter Basics'), findsOneWidget);
  });

  testWidgets('FinanceTemplate renders balance and transactions',
      (tester) async {
    await pump(
      tester,
      const FinanceTemplate(
        balance: '12,400',
        transactions: <Transaction>[
          Transaction(
            title: 'Salary',
            amount: r'+$2,000',
            time: 'Today',
            isCredit: true,
          ),
        ],
      ),
    );
    expect(find.text('Finance'), findsOneWidget);
    expect(find.text(r'$12,400'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
  });

  testWidgets('MedicalTemplate renders appointments', (tester) async {
    await pump(
      tester,
      const MedicalTemplate(
        appointments: <Appointment>[
          Appointment(
              title: 'Dr. Smith', subtitle: 'Cardiology', time: '09:30'),
        ],
      ),
    );
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Dr. Smith'), findsOneWidget);
    expect(find.text('09:30'), findsOneWidget);
  });

  testWidgets('EcommerceTemplate renders products', (tester) async {
    await pump(
      tester,
      const EcommerceTemplate(
        title: 'Store',
        products: <Product>[
          Product(title: 'Headphones', price: r'$99', rating: 4.5),
        ],
      ),
      height: 2000,
    );
    expect(find.text('Store'), findsOneWidget);
    expect(find.text('Headphones'), findsOneWidget);
  });

  testWidgets('SocialTemplate renders posts', (tester) async {
    await pump(
      tester,
      const SocialTemplate(
        posts: <SocialPost>[
          SocialPost(author: 'Ada', time: '2h', text: 'Hello world!'),
        ],
      ),
    );
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('Hello world!'), findsOneWidget);
  });

  testWidgets('AdminTemplate renders stats and table', (tester) async {
    await pump(
      tester,
      const AdminTemplate(
        stats: <Widget>[
          StatisticCard(title: 'Users', value: '1,234'),
        ],
        columns: <String>['Name', 'Status'],
        rows: <AdminRow>[
          AdminRow(cells: <Widget>[Text('Ada'), Text('Active')]),
        ],
      ),
      height: 2000,
    );
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('AnalyticsTemplate renders KPIs and charts', (tester) async {
    await pump(
      tester,
      const AnalyticsTemplate(
        kpis: <AnalyticsKpi>[
          AnalyticsKpi(label: 'Visitors', value: '8,420', delta: '+12%'),
        ],
        lineData: <double>[1, 2, 3],
        lineLabels: <String>['a', 'b', 'c'],
      ),
    );
    expect(find.textContaining('Visitors'), findsWidgets);
    expect(find.text('8,420'), findsOneWidget);
    expect(find.text('+12%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('auth templates render', (tester) async {
    await pump(
      tester,
      LoginTemplate(
        onSubmit: (String _, String __) async {},
      ),
    );
    expect(find.text('Welcome back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
