import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A section header inside a navigation drawer.
class NavDrawerSection extends StatelessWidget {
  const NavDrawerSection({
    super.key,
    this.title,
    this.children = const <Widget>[],
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  });

  /// Section title.
  final String? title;

  /// Section tiles.
  final List<Widget> children;

  /// Section padding.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSpacing.md, top: AppSpacing.sm, bottom: 4),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
          ],
          ...children,
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

/// A navigation drawer item with icon, label, badge and selected state.
class NavDrawerItem extends StatelessWidget {
  const NavDrawerItem({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.selected = false,
    this.selectedColor,
    this.trailing,
    this.badge,
  });

  /// Item title.
  final String title;

  /// Leading icon.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Whether this item is selected.
  final bool selected;

  /// Selected background color.
  final Color? selectedColor;

  /// Trailing widget.
  final Widget? trailing;

  /// Badge text.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color accent = selectedColor ?? scheme.primary;
    final bool hasIcon = icon != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? accent.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 10),
            child: Row(
              children: <Widget>[
                if (hasIcon) ...<Widget>[
                  Icon(
                    icon,
                    size: 22,
                    color: selected ? accent : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected ? accent : scheme.onSurface,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A styled navigation drawer with header and sections.
class NavDrawer extends StatelessWidget {
  const NavDrawer({
    super.key,
    this.header,
    this.children,
    this.footer,
    this.background,
    this.width = 280,
    this.showGradient = false,
    this.headerHeight,
  });

  /// Header widget (logo / user info).
  final Widget? header;

  /// Drawer content.
  final List<Widget>? children;

  /// Footer widget.
  final Widget? footer;

  /// Drawer background color.
  final Color? background;

  /// Drawer width.
  final double width;

  /// Whether to use a primary gradient background.
  final bool showGradient;

  /// Header height.
  final double? headerHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget body = SizedBox(
      width: width,
      child: Drawer(
        backgroundColor: background ?? scheme.surface,
        child: Column(
          children: <Widget>[
            if (header != null) ...<Widget>[
              SizedBox(height: headerHeight, child: header),
              const Divider(height: 1, thickness: 1, color: Colors.transparent),
            ],
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: children ?? const <Widget>[],
              ),
            ),
            if (footer != null) ...<Widget>[
              const Divider(height: 1),
              footer!,
            ],
          ],
        ),
      ),
    );

    if (!showGradient) return body;
    return ShaderMask(
      shaderCallback: (Rect bounds) => LinearGradient(
        colors: <Color>[scheme.primary, scheme.primary.withValues(alpha: 0.9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcOver,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              scheme.primary.withValues(alpha: 0.06),
              Colors.transparent
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
