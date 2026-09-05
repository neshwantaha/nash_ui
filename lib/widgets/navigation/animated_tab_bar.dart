import 'package:flutter/material.dart';

/// An animated tab bar with a sliding indicator pill and elastic bounce effect.
///
/// ```dart
/// AnimatedTabBar(
///   tabs: ['All', 'Favorites', 'Recent'],
///   selectedIndex: currentIndex,
///   onTabSelected: (i) => setState(() => currentIndex = i),
/// )
/// ```
class AnimatedTabBar extends StatelessWidget {
  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.icons,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.height = 46,
    this.borderRadius = 23,
    this.padding = const EdgeInsets.all(4),
  }) : assert(icons == null || icons.length == tabs.length);

  final List<String> tabs;
  final List<IconData>? icons;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final indColor = indicatorColor ?? theme.colorScheme.primary;
    final selText = selectedTextColor ?? theme.colorScheme.onPrimary;
    final unselText = unselectedTextColor ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final tabWidth = (constraints.maxWidth) / tabs.length;
        final clampedIndex = selectedIndex.clamp(0, tabs.length - 1);

        return Stack(
          children: [
            // Sliding animated indicator pill
            AnimatedPositioned(
              duration: const Duration(milliseconds: 260),
              curve: Curves.fastOutSlowIn,
              left: clampedIndex * tabWidth,
              top: 0,
              bottom: 0,
              width: tabWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: indColor,
                  borderRadius: BorderRadius.circular(borderRadius - 2),
                  boxShadow: [
                    BoxShadow(
                      color: indColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Tab labels
            Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = index == selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTabSelected(index),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icons != null) ...[
                            Icon(
                              icons![index],
                              size: 18,
                              color: isSelected ? selText : unselText,
                            ),
                            const SizedBox(width: 6),
                          ],
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? selText : unselText,
                            ),
                            child: Text(tabs[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
