import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A settings row: icon, title, subtitle, trailing control.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.icon,
    this.iconBackground,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  /// Setting title.
  final String title;

  /// Leading icon.
  final IconData? icon;

  /// Icon tile background.
  final Color? iconBackground;

  /// Optional subtitle.
  final String? subtitle;

  /// Trailing widget.
  final Widget? trailing;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Whether the tile is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg = iconBackground ??
        AppColors.forFeedback(AppFeedbackType.info).withValues(alpha: 0.12);

    return ListTile(
      onTap: onTap,
      enabled: enabled,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon ?? Icons.settings_outlined,
            size: 20, color: scheme.primary),
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ??
          (onTap == null
              ? null
              : const Icon(Icons.chevron_right_rounded, size: 20)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
    );
  }
}

/// A clickable row that opens a sheet of options (theme, language, etc.).
class SelectionTile<T> extends StatelessWidget {
  const SelectionTile({
    super.key,
    required this.title,
    required this.selected,
    this.icon,
    this.subtitle,
    this.onChanged,
    this.enabled = true,
    this.onTap,
  });

  /// Tile title.
  final String title;

  /// Selected value (may be null).
  final T? selected;

  /// Leading icon.
  final IconData? icon;

  /// Optional subtitle.
  final String? subtitle;

  /// Change callback with new selection.
  final ValueChanged<T?>? onChanged;

  /// Whether the tile is enabled.
  final bool enabled;

  /// Tap callback (alternative to [onChanged]).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap ??
            (enabled && onChanged != null ? () => onChanged!(selected) : null),
        enabled: enabled,
        leading: icon == null
            ? null
            : Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: Icon(
          selected == null
              ? Icons.radio_button_unchecked
              : Icons.radio_button_checked,
          size: 22,
          color: selected == null
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small)),
      );
}
