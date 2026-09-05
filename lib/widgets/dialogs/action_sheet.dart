import 'package:flutter/material.dart' hide BottomSheet, showBottomSheet;

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import 'bottom_sheet.dart';

/// An action sheet item with icon, label, color and optional trailing.
class ActionSheetItem {
  const ActionSheetItem({
    required this.label,
    this.icon,
    this.color,
    this.trailing,
    this.destructive = false,
    this.enabled = true,
  });

  /// Item label.
  final String label;

  /// Leading icon.
  final IconData? icon;

  /// Icon/label color.
  final Color? color;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether the action is destructive.
  final bool destructive;

  /// Whether the action is enabled.
  final bool enabled;
}

/// Shows an action sheet with a list of actions.
Future<int?> showActionSheet({
  required BuildContext context,
  required List<ActionSheetItem> items,
  String? title,
  String? subtitle,
  String? cancelLabel = 'Cancel',
}) =>
    showBottomSheet<int>(
      context: context,
      child: BottomSheet(
        title: title,
        subtitle: subtitle,
        content: Column(
          children: <Widget>[
            for (int i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ActionSheetTile(
                  item: items[i],
                  onTap: items[i].enabled
                      ? () => Navigator.of(context).pop(i)
                      : null,
                ),
              ),
          ],
        ),
        actions: cancelLabel == null
            ? null
            : <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(cancelLabel),
                  ),
                ),
              ],
      ),
    );

class _ActionSheetTile extends StatelessWidget {
  const _ActionSheetTile({required this.item, required this.onTap});

  final ActionSheetItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color =
        item.destructive ? AppColors.error : (item.color ?? scheme.onSurface);

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: <Widget>[
              if (item.icon != null) ...<Widget>[
                Icon(item.icon, size: 22, color: color),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (item.trailing != null) item.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
