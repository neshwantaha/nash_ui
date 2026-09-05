import '../../nash_ui.dart';

/// A group of [SettingsTile]s inside a [SettingsTemplate].
class SettingsGroup {
  const SettingsGroup({
    required this.title,
    this.tiles = const <SettingsTile>[],
  });

  /// Group title shown above the tiles.
  final String title;

  /// Settings rows in this group.
  final List<SettingsTile> tiles;
}

/// A complete settings screen template.
///
/// Renders a scrollable list of [SettingsGroup]s inside a [Scaffold] with an
/// optional app bar, search action and footer. Rows are standard
/// [SettingsTile]s so switches, sliders and pickers can be placed in the
/// `trailing` slot.
///
/// ```dart
/// SettingsTemplate(
///   title: 'Settings',
///   onSearch: () {},
///   groups: <SettingsGroup>[
///     SettingsGroup(
///       title: 'Preferences',
///       tiles: <SettingsTile>[
///         SettingsTile(
///           title: 'Notifications',
///           icon: Icons.notifications_outlined,
///           trailing: Switch(value: true, onChanged: (_) {}),
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class SettingsTemplate extends StatelessWidget {
  const SettingsTemplate({
    super.key,
    required this.title,
    this.groups = const <SettingsGroup>[],
    this.subtitle,
    this.onBack,
    this.onSearch,
    this.header,
    this.footer,
    this.appBar,
    this.backgroundColor,
  });

  /// App bar title.
  final String title;

  /// Settings groups.
  final List<SettingsGroup> groups;

  /// Optional app bar subtitle.
  final String? subtitle;

  /// Shows a back button and pops the navigator when tapped.
  final VoidCallback? onBack;

  /// Shows a search action in the app bar.
  final VoidCallback? onSearch;

  /// Widget shown below the app bar (banner / account header).
  final Widget? header;

  /// Widget shown at the bottom of the list.
  final Widget? footer;

  /// Custom app bar (overrides the default one).
  final PreferredSizeWidget? appBar;

  /// Scaffold background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ??
          AppBar(
            titleSpacing: 0,
            leading: onBack == null
                ? null
                : IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: AppFontWeight.semibold)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
            actions: <Widget>[
              if (onSearch != null)
                IconButton(
                  onPressed: onSearch,
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search',
                ),
            ],
          ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          if (header != null) ...<Widget>[
            header!,
            const SizedBox(height: AppSpacing.md),
          ],
          for (final SettingsGroup group in groups) ...<Widget>[
            ListGroup(
              header: group.title,
              children: group.tiles,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
