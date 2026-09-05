import 'package:flutter/material.dart' hide PopupMenuItem;
import 'package:flutter/material.dart' as fl;

import '../../colors/brand_colors.dart';
import '../../spacing/app_spacing.dart';

/// A single popup menu item data model used with [PopupMenu].
///
/// ```dart
/// PopupMenuItem(label: 'Edit', icon: Icons.edit, onTap: _edit)
/// ```
class PopupMenuItem<T> {
  const PopupMenuItem({
    required this.label,
    this.value,
    this.icon,
    this.color,
    this.destructive = false,
    this.enabled = true,
    this.selected = false,
    this.onTap,
  });

  /// Item label.
  final String label;

  /// Item value.
  final T? value;

  /// Leading icon.
  final IconData? icon;

  /// Icon/label color.
  final Color? color;

  /// Whether the action is destructive.
  final bool destructive;

  /// Whether the item is enabled.
  final bool enabled;

  /// Whether the item is selected (shows a check).
  final bool selected;

  /// Tap callback before selection.
  final VoidCallback? onTap;
}

/// Backwards-compatible alias.
typedef NashPopupMenuItem<T> = PopupMenuItem<T>;

/// A themed popup menu with rounded corners and item styling.
class PopupMenu<T> extends StatelessWidget {
  const PopupMenu({
    super.key,
    required this.items,
    required this.child,
    this.onSelected,
    this.offset,
    this.color,
    this.icon,
    this.iconSize = 22,
    this.iconColor,
    this.borderRadius = 14,
  });

  /// Popup items.
  final List<PopupMenuItem<T>> items;

  /// Trigger widget.
  final Widget child;

  /// Selection callback.
  final ValueChanged<T>? onSelected;

  /// Menu offset.
  final Offset? offset;

  /// Menu background color.
  final Color? color;

  /// Optional leading icon (overrides [child]).
  final IconData? icon;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Menu corner radius.
  final double borderRadius;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
        onSelected: onSelected,
        offset: offset ?? Offset.zero,
        color: color ?? Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<T>>[
          for (final PopupMenuItem<T> item in items)
            fl.PopupMenuItem<T>(
              value: item.value,
              height: 44,
              enabled: item.enabled,
              onTap: item.onTap,
              child: Row(
                children: <Widget>[
                  if (item.icon != null) ...<Widget>[
                    Icon(
                      item.icon,
                      size: 18,
                      color: item.destructive
                          ? AppColors.error
                          : (item.color ??
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: item.destructive
                                ? AppColors.error
                                : (item.color ??
                                    Theme.of(context).colorScheme.onSurface),
                            fontWeight: item.destructive
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                    ),
                  ),
                  if (item.selected) ...<Widget>[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          if (items.isEmpty)
            const fl.PopupMenuItem(enabled: false, child: SizedBox.shrink()),
        ],
        child: icon != null
            ? Icon(icon,
                size: iconSize,
                color:
                    iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant)
            : child,
      );
}
