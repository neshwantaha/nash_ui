import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// An individual item in a [ButtonGroup].
class GroupItem<T> {
  const GroupItem({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The associated value.
  final T value;

  /// Display text label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;
}

/// A connected, unified group of action buttons with seamless borders and active state highlights.
///
/// ```dart
/// ButtonGroup<String>(
///   selectedValue: 'Week',
///   items: const [
///     GroupItem(value: 'Day', label: 'Day'),
///     GroupItem(value: 'Week', label: 'Week'),
///     GroupItem(value: 'Month', label: 'Month'),
///   ],
///   onChanged: (val) => setState(() => view = val),
/// )
/// ```
class ButtonGroup<T> extends StatelessWidget {
  const ButtonGroup({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.selectedColor,
    this.height = 42.0,
    this.radius = AppRadius.medium,
  });

  /// List of items.
  final List<GroupItem<T>> items;

  /// Currently selected item value.
  final T? selectedValue;

  /// Callback when an item is selected.
  final ValueChanged<T> onChanged;

  /// Active button background color.
  final Color? selectedColor;

  /// Height of the button group.
  final double height;

  /// Corner radius of the outer border.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = selectedColor ?? AppColors.primary;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.1);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141422) : const Color(0xFFF3F3F9),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = item.value == selectedValue;
          final isFirst = index == 0;
          final isLast = index == items.length - 1;

          final itemRadius = BorderRadius.horizontal(
            left: isFirst ? Radius.circular(radius - 1) : Radius.zero,
            right: isLast ? Radius.circular(radius - 1) : Radius.zero,
          );

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onChanged(item.value),
                    borderRadius: itemRadius,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? primary : Colors.transparent,
                        borderRadius: itemRadius,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    height: height * 0.6,
                    color: borderColor,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
