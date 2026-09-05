import 'package:flutter/material.dart' hide NavigationRail;
import 'package:flutter/material.dart' as fl show NavigationRail;

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A single destination in a [NavigationRail].
class NavRailDestination {
  const NavRailDestination({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.tooltip,
    this.badge,
  });

  /// Destination label.
  final String label;

  /// Unselected icon.
  final IconData icon;

  /// Selected icon (defaults to [icon]).
  final IconData? selectedIcon;

  /// Tooltip shown when the rail is collapsed.
  final String? tooltip;

  /// Optional badge text (e.g. a notification count).
  final String? badge;
}

/// A themed Material 3 [NavigationRail] wrapper.
///
/// Use it for persistent top-level navigation on tablets and desktops.
/// The rail can be [extended] to show labels next to the icons, or collapsed
/// to icon-only (recommended for narrow windows).
///
/// ```dart
/// NavigationRail(
///   selectedIndex: _index,
///   onDestinationSelected: (int i) => setState(() => _index = i),
///   destinations: <NavRailDestination>[
///     NavRailDestination(label: 'Home', icon: Icons.home_outlined),
///     NavRailDestination(label: 'Inbox', icon: Icons.mail_outline, badge: '3'),
///   ],
/// )
/// A backwards-compatible alias for [NavigationRail].
typedef NashNavigationRail = NavigationRail;

class NavigationRail extends StatelessWidget {
  const NavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = false,
    this.leading,
    this.trailing,
    this.labelType,
    this.backgroundColor,
    this.minWidth,
    this.groupAlignment = -1,
  });

  /// Index of the selected destination.
  final int selectedIndex;

  /// Called when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Rail destinations.
  final List<NavRailDestination> destinations;

  /// When true the rail expands and shows labels beside the icons.
  final bool extended;

  /// Widget shown above the destinations (logo / avatar).
  final Widget? leading;

  /// Widget shown below the destinations (theme switch / avatar).
  final Widget? trailing;

  /// Label display policy (overrides [extended] when provided).
  final NavigationRailLabelType? labelType;

  /// Rail background color.
  final Color? backgroundColor;

  /// Rail width when collapsed.
  final double? minWidth;

  /// Vertical alignment of the destination group.
  final double groupAlignment;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return fl.NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      leading: leading,
      trailing: trailing,
      backgroundColor: backgroundColor ?? scheme.surface,
      groupAlignment: groupAlignment,
      labelType: labelType,
      minWidth: minWidth,
      indicatorColor: scheme.primary.withValues(alpha: 0.12),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        color: scheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
      destinations: <NavigationRailDestination>[
        for (final NavRailDestination d in destinations)
          NavigationRailDestination(
            icon: _railIcon(d, selected: false),
            selectedIcon: _railIcon(d, selected: true),
            label: Text(d.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }

  Widget _railIcon(NavRailDestination d, {required bool selected}) {
    final IconData icon = selected ? (d.selectedIcon ?? d.icon) : d.icon;
    if (d.badge == null) return Icon(icon);
    return _BadgedIcon(icon: icon, badge: d.badge!);
  }
}

class _BadgedIcon extends StatelessWidget {
  const _BadgedIcon({required this.icon, required this.badge});

  final IconData icon;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(icon),
        Positioned(
          top: -6,
          right: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 9,
                height: 1,
                fontWeight: FontWeight.w700,
                color: scheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single item in a [Sidebar].
class SidebarItem {
  const SidebarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badge,
    this.trailing,
    this.enabled = true,
  });

  /// Item label.
  final String label;

  /// Unselected icon.
  final IconData icon;

  /// Selected icon (defaults to [icon]).
  final IconData? selectedIcon;

  /// Optional badge text.
  final String? badge;

  /// Optional trailing widget (e.g. a chevron).
  final Widget? trailing;

  /// When false the item is disabled.
  final bool enabled;
}

/// A section header inside a [Sidebar].
class SidebarSection {
  const SidebarSection({
    this.title,
    this.items = const <SidebarItem>[],
  });

  /// Section title.
  final String? title;

  /// Items in this section.
  final List<SidebarItem> items;
}

/// A persistent desktop sidebar with sections, selection and collapse.
///
/// Use on wide screens where a [NavigationRail] would be too compact and a
/// [NavDrawer] would be too transient.
///
/// ```dart
/// Sidebar(
///   selectedIndex: _index,
///   onSelected: (int i) => setState(() => _index = i),
///   header: const Text('Nash'),
///   sections: <SidebarSection>[
///     SidebarSection(
///       title: 'General',
///       items: <SidebarItem>[
///         SidebarItem(label: 'Home', icon: Icons.home_outlined),
///         SidebarItem(label: 'Inbox', icon: Icons.mail_outline, badge: '3'),
///       ],
///     ),
///   ],
/// )
/// ```
class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.sections,
    this.header,
    this.footer,
    this.width = 280,
    this.collapsedWidth = 72,
    this.collapsible = true,
    this.showHeader = true,
    this.background,
    this.borderColor,
  });

  /// Index of the selected item across all sections (sequential).
  final int selectedIndex;

  /// Called with the sequential index of the tapped item.
  final ValueChanged<int> onSelected;

  /// Sidebar sections.
  final List<SidebarSection> sections;

  /// Header widget (logo / branding).
  final Widget? header;

  /// Footer widget.
  final Widget? footer;

  /// Width when expanded.
  final double width;

  /// Width when collapsed.
  final double collapsedWidth;

  /// When true a collapse toggle is shown.
  final bool collapsible;

  /// Whether to render the [header].
  final bool showHeader;

  /// Background color.
  final Color? background;

  /// Border color (defaults to the theme outline variant).
  final Color? borderColor;

  @override
  State<Sidebar> createState() => _NSidebarState();
}

class _NSidebarState extends State<Sidebar> {
  bool _collapsed = false;

  /// Programmatically expand/collapse the sidebar.
  void setCollapsed({required bool collapsed}) {
    setState(() => _collapsed = collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool collapsed = widget.collapsible && _collapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: collapsed ? widget.collapsedWidth : widget.width,
      decoration: BoxDecoration(
        color: widget.background ?? scheme.surface,
        border: Border(
          right: BorderSide(
            color: widget.borderColor ??
                scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.showHeader && widget.header != null) ...<Widget>[
            SizedBox(height: 64, child: Center(child: widget.header)),
            const Divider(height: 1),
          ],
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: collapsed ? 0 : AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              children: <Widget>[
                for (final SidebarSection section in widget.sections)
                  _buildSection(scheme, section, collapsed: collapsed),
              ],
            ),
          ),
          if (widget.footer != null) ...<Widget>[
            const Divider(height: 1),
            Padding(
              padding:
                  EdgeInsets.all(collapsed ? AppSpacing.sm : AppSpacing.md),
              child: Center(child: widget.footer),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(
    ColorScheme scheme,
    SidebarSection section, {
    required bool collapsed,
  }) {
    final List<Widget> children = <Widget>[];

    if (section.title != null && !collapsed) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, 4),
        child: Text(
          section.title!,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
        ),
      ));
    }

    int offset = 0;
    for (int s = 0; s < widget.sections.length; s++) {
      if (identical(widget.sections[s], section)) break;
      offset += widget.sections[s].items.length;
    }

    for (int i = 0; i < section.items.length; i++) {
      final int index = offset + i;
      children.add(_buildItem(scheme, section.items[i], index, collapsed));
    }

    return Column(children: children);
  }

  Widget _buildItem(
    ColorScheme scheme,
    SidebarItem item,
    int index,
    bool collapsed,
  ) {
    final bool selected = index == widget.selectedIndex;
    final Color accent = scheme.primary;
    final IconData icon =
        selected ? (item.selectedIcon ?? item.icon) : item.icon;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? accent.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.enabled ? () => widget.onSelected(index) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : AppSpacing.md,
              vertical: 10,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: collapsed ? widget.collapsedWidth : 40,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Icon(icon,
                            size: 22,
                            color: selected ? accent : scheme.onSurfaceVariant),
                        if (item.badge != null && collapsed)
                          Positioned(
                            top: -6,
                            right: collapsed ? 8 : 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                item.badge!,
                                style: TextStyle(
                                  fontSize: 9,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onError,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (!collapsed) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: selected ? accent : scheme.onSurface,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                    ),
                  ),
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        item.badge!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                  if (item.trailing != null) ...<Widget>[
                    const SizedBox(width: 4),
                    item.trailing!,
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
