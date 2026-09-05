import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../animation/scale.dart';

/// A bottom navigation bar with icons, optional badges and centered FAB.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.color,
    this.activeColor,
    this.inactiveColor,
    this.elevation = 8,
    this.showLabels = true,
    this.floatingAction,
    this.iconSize = 22,
    this.selectedIconSize = 24,
    this.backgroundColor,
  });

  /// Navigation items.
  final List<BottomNavItem> items;

  /// Currently selected index.
  final int currentIndex;

  /// Selection callback.
  final ValueChanged<int>? onTap;

  /// Active item color.
  final Color? activeColor;

  /// Inactive item color.
  final Color? inactiveColor;

  /// Navigation bar color.
  final Color? color;

  /// Background color.
  final Color? backgroundColor;

  /// Elevation.
  final double elevation;

  /// Whether to show item labels.
  final bool showLabels;

  /// Center floating action button.
  final Widget? floatingAction;

  /// Icon size.
  final double iconSize;

  /// Selected icon size.
  final double selectedIconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color navColor = color ?? scheme.surface;

    return Material(
      color: backgroundColor ?? navColor,
      elevation: elevation,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                if (items[i].center) ...<Widget>[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: floatingAction ?? _DefaultFab(icon: items[i].icon),
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else ...<Widget>[
                  Expanded(
                    child: _NavItem(
                      item: items[i],
                      selected: currentIndex == i,
                      onTap: onTap == null ? null : () => onTap!(i),
                      activeColor: activeColor ?? scheme.primary,
                      inactiveColor: inactiveColor ?? scheme.onSurfaceVariant,
                      showLabel: showLabels,
                      iconSize: iconSize,
                      selectedIconSize: selectedIconSize,
                    ),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A bottom navigation item.
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    this.selectedIcon,
    this.label,
    this.badge,
    this.center = false,
    this.iconBackground,
  });

  /// Icon.
  final IconData icon;

  /// Icon shown when selected.
  final IconData? selectedIcon;

  /// Item label.
  final String? label;

  /// Badge text.
  final String? badge;

  /// Whether this is the centered FAB slot.
  final bool center;

  /// Icon tile background (for the centered FAB).
  final Color? iconBackground;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.showLabel,
    required this.iconSize,
    required this.selectedIconSize,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback? onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool showLabel;
  final double iconSize;
  final double selectedIconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              AnimatedScale(
                scale: selected ? 1.1 : 1.0,
                duration: AppDuration.fast,
                child: AnimatedSwitcher(
                  duration: AppDuration.fast,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          FadeTransition(opacity: animation, child: child),
                  child: Icon(
                    selected ? (item.selectedIcon ?? item.icon) : item.icon,
                    key: ValueKey<String>(
                      '${item.icon.codePoint}_$selected',
                    ),
                    size: selected ? selectedIconSize : iconSize,
                    color: selected ? activeColor : inactiveColor,
                  ),
                ),
              ),
              if (item.badge != null)
                Positioned(
                  top: -4,
                  right: -8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: scheme.error,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (showLabel && item.label != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              item.label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? activeColor : inactiveColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DefaultFab extends StatelessWidget {
  const _DefaultFab({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ScaleAnimation(
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              scheme.primary,
              scheme.primary.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
