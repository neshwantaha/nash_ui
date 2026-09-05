import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

Future<void> pump(WidgetTester tester, Widget child, {Size? size}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: Theme.light(),
      home: Scaffold(
        body: size == null
            ? child
            : SizedBox(width: size.width, height: size.height, child: child),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

void _noop(int index) {}

void main() {
  group('NavigationRail', () {
    testWidgets('renders destinations and fires selection', (tester) async {
      int selected = -1;
      await pump(
        tester,
        NavigationRail(
          selectedIndex: 0,
          onDestinationSelected: (int i) => selected = i,
          destinations: const <NavRailDestination>[
            NavRailDestination(label: 'Home', icon: Icons.home_outlined),
            NavRailDestination(
              label: 'Inbox',
              icon: Icons.mail_outline,
              badge: '3',
            ),
          ],
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(
        find
            .ancestor(
                of: find.text('Inbox'), matching: find.bySubtype<InkResponse>())
            .first,
      );
      expect(selected, 1);
    });

    testWidgets('extended mode keeps labels', (tester) async {
      await pump(
        tester,
        const NavigationRail(
          selectedIndex: 0,
          onDestinationSelected: _noop,
          extended: true,
          destinations: <NavRailDestination>[
            NavRailDestination(label: 'Home', icon: Icons.home),
          ],
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Sidebar', () {
    testWidgets('renders sections, titles and badges', (tester) async {
      int tapped = -1;
      await pump(
        tester,
        Sidebar(
          selectedIndex: 0,
          onSelected: (int i) => tapped = i,
          header: const Text('Nash'),
          sections: const <SidebarSection>[
            SidebarSection(
              title: 'General',
              items: <SidebarItem>[
                SidebarItem(label: 'Home', icon: Icons.home_outlined),
                SidebarItem(
                    label: 'Inbox', icon: Icons.mail_outline, badge: '5'),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Nash'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      await tester.tap(find.text('Inbox'));
      expect(tapped, 1);
    });

    testWidgets('disabled items do not fire selection', (tester) async {
      int tapped = -1;
      await pump(
        tester,
        Sidebar(
          selectedIndex: 0,
          onSelected: (int i) => tapped = i,
          sections: const <SidebarSection>[
            SidebarSection(
              items: <SidebarItem>[
                SidebarItem(
                    label: 'Disabled', icon: Icons.block, enabled: false),
              ],
            ),
          ],
        ),
      );

      await tester.tap(find.text('Disabled'));
      expect(tapped, -1);
    });
  });

  group('BottomNavBar', () {
    testWidgets('renders labels and handles taps', (tester) async {
      int selected = -1;
      await pump(
        tester,
        BottomNavBar(
          currentIndex: 0,
          onTap: (int i) => selected = i,
          items: const <BottomNavItem>[
            BottomNavItem(icon: Icons.home, label: 'Home'),
            BottomNavItem(icon: Icons.settings, label: 'Settings', badge: '2'),
          ],
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      expect(selected, 1);
    });
  });

  group('NavDrawer', () {
    testWidgets('renders drawer with sections', (tester) async {
      await pump(
        tester,
        const SizedBox(
          width: 300,
          child: NavDrawer(
            children: <Widget>[
              NavDrawerSection(
                title: 'Menu',
                children: <Widget>[
                  NavDrawerItem(title: 'Dashboard', icon: Icons.dashboard),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });

  group('AppBar', () {
    testWidgets('renders title and actions', (tester) async {
      await pump(
        tester,
        const Scaffold(
          appBar: AppBar(title: 'Hello', actions: <Widget>[Icon(Icons.search)]),
          body: SizedBox.shrink(),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
