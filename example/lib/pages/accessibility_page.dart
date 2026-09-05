import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Accessibility',
      icon: Icons.accessibility_new_rounded,
      sections: [
        ShowcaseSection(
          title: 'Focus Ring',
          children: [
            const Text(
              'Tab to the fields below to see the focus ring indicator.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            FocusRing(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Focus me (TextField)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FocusRing(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Focus me (Button)'),
              ),
            ),
          ],
        ),

        // ── Touch Targets ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'Touch Targets',
          children: [
            const Text(
              'TouchTarget enforces a minimum 48dp tap area for icons.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text('Without TouchTarget:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.star, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_up, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('With TouchTarget:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                TouchTarget(
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {},
                  ),
                ),
                TouchTarget(
                  child: IconButton(
                    icon: const Icon(Icons.star, size: 20),
                    onPressed: () {},
                  ),
                ),
                TouchTarget(
                  child: IconButton(
                    icon: const Icon(Icons.thumb_up, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Semantics Announcer ────────────────────────────────────────
        ShowcaseSection(
          title: 'Semantics Announcer',
          children: [
            const Text(
              'Wraps a widget with a live region that announces the message to screen readers.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SemanticsAnnouncer(
              message: 'Status updated: Active',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: 18, color: AppColors.success),
                    SizedBox(width: 8),
                    Text('Status: Active',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Accessible Button ──────────────────────────────────────────
        ShowcaseSection(
          title: 'Accessible Button',
          children: [
            const Text(
              'Combines touch target enforcement with explicit semantics label for screen readers.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            AccessibleButton(
              onPressed: () => context.showSnack('Accessible button pressed!'),
              semanticsLabel: 'Bookmark this item',
              semanticsHint: 'Double-tap to bookmark',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_add_rounded,
                        size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Bookmark',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Accessibility Tokens ───────────────────────────────────────
        ShowcaseSection(
          title: 'Accessibility Tokens',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _TokenCard(
                    label: 'minTouchTarget',
                    value: '${AppAccessibility.minTouchTarget}dp'),
                _TokenCard(
                    label: 'comfortableTouchTarget',
                    value: '${AppAccessibility.comfortableTouchTarget}dp'),
                _TokenCard(
                    label: 'smallTouchTarget',
                    value: '${AppAccessibility.smallTouchTarget}dp'),
                _TokenCard(
                    label: 'focusRingWidth',
                    value: '${AppAccessibility.focusRingWidth}dp'),
                _TokenCard(
                    label: 'focusRingOffset',
                    value: '${AppAccessibility.focusRingOffset}dp'),
                _TokenCard(
                    label: 'focusRingRadius',
                    value: '${AppAccessibility.focusRingRadius}dp'),
                _TokenCard(
                    label: 'contrastRatioAA',
                    value: '${AppAccessibility.contrastRatioAA}'),
                _TokenCard(
                    label: 'contrastRatioAALarge',
                    value: '${AppAccessibility.contrastRatioAALarge}'),
                _TokenCard(
                    label: 'contrastRatioAAA',
                    value: '${AppAccessibility.contrastRatioAAA}'),
                _TokenCard(
                    label: 'contrastRatioAAALarge',
                    value: '${AppAccessibility.contrastRatioAAALarge}'),
                _TokenCard(
                    label: 'maxTextScaleFactor',
                    value: '${AppAccessibility.maxTextScaleFactor}x'),
                _TokenCard(
                    label: 'minTextScaleFactor',
                    value: '${AppAccessibility.minTextScaleFactor}x'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
