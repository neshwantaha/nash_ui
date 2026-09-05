import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Responsive',
      icon: Icons.devices_rounded,
      sections: [
        // ── NashResponsiveGrid ─────────────────────────────────────────────
        ShowcaseSection(
          title: 'Responsive Grid (resize window to see columns change)',
          children: [
            ResponsiveGrid(
              mobile: 1,
              tablet: 2,
              desktop: 3,
              spacing: 12,
              runSpacing: 12,
              children: [
                _GridCard(
                    'Analytics', Icons.bar_chart_rounded, AppColors.primary),
                _GridCard(
                    'Revenue', Icons.attach_money_rounded, AppColors.emerald),
                _GridCard('Users', Icons.people_rounded, AppColors.violet),
                _GridCard(
                    'Orders', Icons.shopping_bag_rounded, AppColors.amber),
                _GridCard('Sessions', Icons.timer_rounded, AppColors.cyan),
                _GridCard('Errors', Icons.bug_report_rounded, AppColors.rose),
              ],
            ),
          ],
        ),

        // ── Adaptive Layout ────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Adaptive Layout (changes based on available width)',
          children: [
            LayoutBuilder(builder: (ctx, constraints) {
              final width = constraints.maxWidth;
              if (width < AppBreakpoint.phone) {
                return _MobileLayout();
              } else if (width < AppBreakpoint.tablet) {
                return _TabletLayout();
              } else {
                return _DesktopLayout();
              }
            }),
          ],
        ),

        // ── Breakpoints Info ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'Current Breakpoint',
          children: [
            LayoutBuilder(builder: (ctx, constraints) {
              final width = constraints.maxWidth;
              final String bp;
              final Color color;
              final IconData icon;
              if (width < AppBreakpoint.phone) {
                bp = 'Mobile (<${AppBreakpoint.phone.toInt()}px)';
                color = AppColors.rose;
                icon = Icons.phone_android_rounded;
              } else if (width < AppBreakpoint.tablet) {
                bp =
                    'Tablet (${AppBreakpoint.phone.toInt()}–${AppBreakpoint.tablet.toInt()}px)';
                color = AppColors.amber;
                icon = Icons.tablet_mac_rounded;
              } else {
                bp = 'Desktop (>${AppBreakpoint.tablet.toInt()}px)';
                color = AppColors.emerald;
                icon = Icons.desktop_windows_rounded;
              }
              return Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          bp,
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${width.toStringAsFixed(0)}px wide',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}

// ── Grid card widget ─────────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Layout variants ──────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.rose.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.rose.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.phone_android_rounded, color: AppColors.rose, size: 18),
            const SizedBox(width: 8),
            Text('Mobile Layout',
                style: TextStyle(
                    color: AppColors.rose, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          const Text(
            'Stacked, single-column layout optimized for small screens.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.tablet_mac_rounded, color: AppColors.amber, size: 18),
            const SizedBox(width: 8),
            Text('Tablet Layout',
                style: TextStyle(
                    color: AppColors.amber, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          const Text(
            'Two-column grid with a sidebar — ideal for medium-sized screens.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.desktop_windows_rounded,
                color: AppColors.emerald, size: 18),
            const SizedBox(width: 8),
            Text('Desktop Layout',
                style: TextStyle(
                    color: AppColors.emerald, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          const Text(
            'Full multi-column dashboard layout for wide desktop screens.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
