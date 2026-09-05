import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class DialogsPage extends StatelessWidget {
  const DialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Dialogs & Overlays',
      icon: Icons.layers_rounded,
      sections: [
        ShowcaseSection(
          title: 'Command Palette (Spotlight / Ctrl+K)',
          children: [
            PrimaryButton(
              label: 'Open Command Palette',
              icon: Icons.search_rounded,
              onPressed: () {
                showCommandPalette(
                  context,
                  items: [
                    CommandItem(
                      title: 'Create New Project',
                      subtitle: 'Start a new Flutter design workflow',
                      icon: Icons.add_circle_outline_rounded,
                      category: 'Actions',
                      shortcut: 'Ctrl+N',
                      badge: 'New',
                    ),
                    CommandItem(
                      title: 'Toggle Dark Mode',
                      subtitle: 'Switch theme between light and dark',
                      icon: Icons.palette_outlined,
                      category: 'Preferences',
                      shortcut: 'Ctrl+T',
                    ),
                    CommandItem(
                      title: 'Open Settings',
                      subtitle: 'Manage your profile and API tokens',
                      icon: Icons.settings_outlined,
                      category: 'Navigation',
                    ),
                    CommandItem(
                      title: 'Documentation',
                      subtitle: 'Browse Nash UI component guides',
                      icon: Icons.menu_book_rounded,
                      category: 'Help',
                      shortcut: 'F1',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Anchored Popover (Hover & Click)',
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                Popover(
                  popoverContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nash UI Popover',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This popover anchors intelligently to its trigger button.',
                        style: TextStyle(
                            fontSize: 12,
                            color: context.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Click Popover'),
                      ],
                    ),
                  ),
                ),
                Popover(
                  triggerMode: PopoverTriggerMode.hover,
                  popoverContent: const Text(
                    '⚡ Fast hover card preview',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.violet.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mouse_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Hover Popover'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Draggable Snap Bottom Sheet',
          children: [
            PrimaryButton(
              label: 'Open Snap Bottom Sheet',
              icon: Icons.vertical_align_top_rounded,
              onPressed: () {
                showDraggableSheet(
                  context: context,
                  builder: (ctx, scrollController) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: 20,
                      itemBuilder: (c, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.12),
                          child: Text('${i + 1}'),
                        ),
                        title: Text('Snap Sheet Item ${i + 1}'),
                        subtitle: const Text('Drag up or down to snap height'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Nash Dialog',
          children: [
            PrimaryButton(
              label: 'Open Nash Dialog',
              icon: Icons.info_outline_rounded,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    title: 'Nash UI Dialog',
                    subtitle:
                        'This dialog is styled with Nash UI design tokens.',
                    icon: Icons.auto_awesome_rounded,
                    actions: [
                      TextButton(
                        label: 'Close',
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      PrimaryButton(
                        label: 'Confirm',
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Popup Menu',
          children: [
            PopupMenu<String>(
              items: const [
                PopupMenuItem(value: 'edit', label: 'Edit Document'),
                PopupMenuItem(value: 'duplicate', label: 'Duplicate'),
                PopupMenuItem(value: 'archive', label: 'Archive'),
                PopupMenuItem(value: 'delete', label: 'Delete'),
              ],
              onSelected: (v) {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Actions Menu'),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
