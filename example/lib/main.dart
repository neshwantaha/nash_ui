import 'package:intl/date_symbol_data_local.dart';
import 'package:nash_ui/nash_ui.dart';

import 'pages/accessibility_page.dart';
import 'pages/animations_page.dart';
import 'pages/buttons_page.dart';
import 'pages/cards_page.dart';
import 'pages/charts_advanced_page.dart';
import 'pages/charts_page.dart';
import 'pages/creative_cards_page.dart';
import 'pages/dialogs_page.dart';
import 'pages/drag_drop_page.dart';
import 'pages/feedback_page.dart';
import 'pages/inputs_page.dart';
import 'pages/interactive_media_page.dart';
import 'pages/interactive_widgets_page.dart';
import 'pages/lists_page.dart';
import 'pages/loading_page.dart';
import 'pages/navigation_page.dart';
import 'pages/new_features_page.dart';
import 'pages/pickers_page.dart';
import 'pages/responsive_page.dart';
import 'pages/security_auth_page.dart';
import 'pages/stepper_page.dart';
import 'pages/templates_page.dart';
import 'pages/themes_page.dart';
import 'pages/tokens_page.dart';
import 'pages/ux_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en');
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nash UI Showcase',
      debugShowCheckedModeBanner: false,
      theme: Theme.light(),
      darkTheme: Theme.dark(),
      themeMode: _themeMode,
      home: ShowcaseShell(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  @override
  State<ShowcaseShell> createState() => _ShowcaseShellState();
}

class _ShowcaseShellState extends State<ShowcaseShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    _NavItem(icon: Icons.smart_button_rounded, label: 'Buttons'),
    _NavItem(icon: Icons.credit_card_rounded, label: 'Cards'),
    _NavItem(icon: Icons.style_rounded, label: 'Creative Cards'),
    _NavItem(icon: Icons.text_fields_rounded, label: 'Inputs'),
    _NavItem(icon: Icons.security_rounded, label: 'Security & Auth'),
    _NavItem(icon: Icons.celebration_rounded, label: 'Interactive'),
    _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Media & Audio'),
    _NavItem(icon: Icons.feedback_rounded, label: 'Feedback'),
    _NavItem(icon: Icons.hourglass_top_rounded, label: 'Loading'),
    _NavItem(icon: Icons.navigation_rounded, label: 'Navigation'),
    _NavItem(icon: Icons.animation_rounded, label: 'Animations'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Charts'),
    _NavItem(icon: Icons.pie_chart_outline_rounded, label: 'Advanced Charts'),
    _NavItem(icon: Icons.layers_rounded, label: 'Dialogs'),
    _NavItem(icon: Icons.palette_rounded, label: 'Themes'),
    _NavItem(icon: Icons.token_rounded, label: 'Tokens'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Templates'),
    _NavItem(icon: Icons.table_rows_rounded, label: 'Lists'),
    _NavItem(icon: Icons.widgets_rounded, label: 'UX States'),
    _NavItem(icon: Icons.devices_rounded, label: 'Responsive'),
    _NavItem(icon: Icons.accessibility_new_rounded, label: 'Accessibility'),
    _NavItem(icon: Icons.swap_vert_circle_rounded, label: 'Drag & Drop'),
    _NavItem(icon: Icons.date_range_rounded, label: 'Pickers'),
    _NavItem(icon: Icons.linear_scale_rounded, label: 'Stepper'),
    _NavItem(icon: Icons.new_releases_rounded, label: 'New Features'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;

    final pages = [
      const ButtonsPage(),
      const CardsPage(),
      const CreativeCardsPage(),
      const InputsPage(),
      const SecurityAuthPage(),
      const InteractiveWidgetsPage(),
      const InteractiveMediaPage(),
      const FeedbackPage(),
      const LoadingPage(),
      const NavigationPage(),
      const AnimationsPage(),
      const ChartsPage(),
      const ChartsAdvancedPage(),
      const DialogsPage(),
      const ThemesPage(),
      const TokensPage(),
      const TemplatesPage(),
      const ListsPage(),
      const UxPage(),
      const ResponsivePage(),
      const AccessibilityPage(),
      const DragDropPage(),
      const PickersPage(),
      const StepperPage(),
      const NewFeaturesPage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          // ── Scrollable custom sidebar ──────────────────────────────────
          _ScrollableSidebar(
            isDark: isDark,
            selectedIndex: _selectedIndex,
            navItems: _navItems,
            onSelect: (i) => setState(() => _selectedIndex = i),
            onToggleTheme: widget.onToggleTheme,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// ── Scrollable sidebar ────────────────────────────────────────────────────────

class _ScrollableSidebar extends StatelessWidget {
  const _ScrollableSidebar({
    required this.isDark,
    required this.selectedIndex,
    required this.navItems,
    required this.onSelect,
    required this.onToggleTheme,
  });

  final bool isDark;
  final int selectedIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onSelect;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF4F4FF);
    final Color activeColor = AppColors.primary;

    return Container(
      width: 72,
      color: bg,
      child: Column(
        children: [
          // ── Logo (pinned) ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // ── Scrollable nav items ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  for (int i = 0; i < navItems.length; i++)
                    _SidebarItem(
                      item: navItems[i],
                      selected: selectedIndex == i,
                      isDark: isDark,
                      activeColor: activeColor,
                      onTap: () => onSelect(i),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Theme toggle (pinned) ────────────────────────────────────
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
              onPressed: onToggleTheme,
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.item,
    required this.selected,
    required this.isDark,
    required this.activeColor,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final bool isDark;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.label,
      preferBelow: false,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? activeColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: selected
                    ? activeColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected
                      ? activeColor
                      : (isDark ? Colors.white38 : Colors.black38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
