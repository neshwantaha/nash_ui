import 'package:flutter/material.dart' hide TabBar, Tab;
import 'package:flutter/material.dart' as fl
    show TabBar, Tab, TabBarIndicatorSize;

import '../../animation/duration.dart';
import '../../animation/fade.dart';

/// A modern, animated tab bar with sliding indicator and icons.
///
/// A backwards-compatible alias for [TabBar].
typedef NashTabBar = TabBar;

/// A single tab definition.
///
/// A backwards-compatible alias for [Tab].
typedef NashTab = Tab;

/// A swipeable tab view that animates between pages.
///
/// A backwards-compatible alias for [TabView].
typedef NashTabView = TabView;

/// A modern, animated tab bar with sliding indicator and icons.
class TabBar extends StatelessWidget implements PreferredSizeWidget {
  const TabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.isScrollable = false,
    this.pill = false,
    this.labelStyle,
    this.height,
  });

  /// Tab definitions.
  final List<Tab> tabs;

  /// The TabController.
  final TabController controller;

  /// Tab selection callback.
  final ValueChanged<int>? onTap;

  /// Indicator color.
  final Color? indicatorColor;

  /// Selected label color.
  final Color? labelColor;

  /// Unselected label color.
  final Color? unselectedLabelColor;

  /// Tab bar background color.
  final Color? backgroundColor;

  /// Whether tabs scroll horizontally.
  final bool isScrollable;

  /// Whether to render a pill-shaped indicator.
  final bool pill;

  /// Label style.
  final TextStyle? labelStyle;

  /// Tab bar height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color accent = indicatorColor ?? scheme.primary;
    final double resolvedHeight = height ?? (isScrollable ? 44 : 46);

    final fl.TabBar bar = fl.TabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: isScrollable,
      labelColor: labelColor ?? (pill ? Colors.white : accent),
      unselectedLabelColor: unselectedLabelColor ?? scheme.onSurfaceVariant,
      indicatorSize:
          pill ? fl.TabBarIndicatorSize.label : fl.TabBarIndicatorSize.tab,
      indicator: pill
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: accent,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border(
                bottom: BorderSide(color: accent, width: 2.5),
              ),
            ),
      dividerColor: scheme.outlineVariant.withValues(alpha: 0.3),
      indicatorWeight: pill ? 0 : 2.5,
      labelStyle: labelStyle ??
          Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
      unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
      tabs: <Widget>[
        for (final Tab tab in tabs)
          fl.Tab(
            height: resolvedHeight,
            icon: tab.icon == null ? null : Icon(tab.icon, size: 20),
            iconMargin: EdgeInsets.zero,
            text: tab.text ?? tab.label,
            child: tab.child,
          ),
      ],
    );

    return Material(
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: bar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? (isScrollable ? 44 : 46));
}

/// A single tab definition.
class Tab {
  const Tab({
    this.label,
    this.text,
    this.icon,
    this.child,
  });

  /// Tab label (Nash API).
  final String? label;

  /// Tab text (Flutter API).
  final String? text;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional custom child widget.
  final Widget? child;
}

/// A swipeable tab view that animates between pages.
class TabView extends StatelessWidget {
  const TabView({
    super.key,
    required this.controller,
    required this.children,
    this.physics,
    this.animateOnScroll = true,
  });

  /// The TabController (should match the [TabBar] controller).
  final TabController controller;

  /// Tab pages.
  final List<Widget> children;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Whether to animate page transitions.
  final bool animateOnScroll;

  @override
  Widget build(BuildContext context) => TabBarView(
        controller: controller,
        physics: physics,
        children: <Widget>[
          for (int i = 0; i < children.length; i++)
            FadeAnimation(
              duration: AppDuration.fast,
              child: children[i],
            ),
        ],
      );
}
