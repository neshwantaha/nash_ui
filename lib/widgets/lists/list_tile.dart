import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter/material.dart' as fl show ListTile;

import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A configurable list tile with leading/trailing widgets and tap feedback.
///
/// A backwards-compatible alias for [ListTile].
typedef NashListTile = ListTile;

/// A configurable list tile with leading/trailing widgets and tap feedback.
class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.dense = false,
    this.selected = false,
    this.selectedColor,
    this.backgroundColor,
    this.padding,
    this.contentPadding,
    this.iconColor,
    this.textColor,
    this.shape,
    this.titleStyle,
    this.subtitleStyle,
    this.showDivider = false,
    this.dividerColor,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget (icon or [Avatar]).
  final Widget? leading;

  /// Trailing widget.
  final Widget? trailing;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Whether the tile is enabled.
  final bool enabled;

  /// Dense layout.
  final bool dense;

  /// Selected state.
  final bool selected;

  /// Selected background color.
  final Color? selectedColor;

  /// Tile background color.
  final Color? backgroundColor;

  /// Inner content padding.
  final EdgeInsetsGeometry? padding;

  /// Content padding (Flutter compatibility).
  final EdgeInsetsGeometry? contentPadding;

  /// Icon color for leading/trailing.
  final Color? iconColor;

  /// Text color.
  final Color? textColor;

  /// Tile shape.
  final ShapeBorder? shape;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Show a divider below the tile.
  final bool showDivider;

  /// Divider color.
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Widget tile = fl.ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      enabled: enabled,
      dense: dense,
      selected: selected,
      selectedTileColor: selectedColor,
      tileColor: backgroundColor,
      contentPadding: contentPadding ?? padding,
      iconColor: iconColor,
      textColor: textColor,
      shape: shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.small)),
      titleTextStyle: titleStyle,
      subtitleTextStyle: subtitleStyle,
    );

    if (!showDivider) return tile;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        tile,
        Divider(
          height: 1,
          thickness: 1,
          color: dividerColor ?? scheme.outlineVariant.withValues(alpha: 0.4),
          indent: leading == null ? AppSpacing.md : 0,
          endIndent: AppSpacing.md,
        ),
      ],
    );
  }
}

/// A group of list tiles with optional header.
class ListGroup extends StatelessWidget {
  const ListGroup({
    super.key,
    this.header,
    this.children,
    this.divider = true,
    this.background,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
  });

  /// Optional group header.
  final String? header;

  /// Tiles in the group.
  final List<Widget>? children;

  /// Whether to show dividers between tiles.
  final bool divider;

  /// Group background color.
  final Color? background;

  /// Group padding.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (children == null || children!.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (header != null) ...<Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 6),
            child: Text(
              header!,
              style: textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
        Container(
          padding: padding,
          decoration: BoxDecoration(
            color: background ?? scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border:
                Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < children!.length; i++) ...<Widget>[
                children![i],
                if (divider && i != children!.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
