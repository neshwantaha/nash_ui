import 'package:flutter/material.dart' hide ExpansionTile;

import '../../animation/duration.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// An expandable list tile with custom header, body and smooth animations.
///
/// A backwards-compatible alias for [ExpansionTile].
typedef NashExpansionTile = ExpansionTile;

/// An expandable list tile with custom header, body and smooth animations.
class ExpansionTile extends StatefulWidget {
  const ExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.background,
    this.expandedBackground,
    this.iconColor,
    this.textColor,
    this.padding =
        const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
    this.showDivider = false,
  });

  /// Header title.
  final Widget title;

  /// Header subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing widget (defaults to chevron).
  final Widget? trailing;

  /// Expanded content children.
  final List<Widget> children;

  /// Whether expanded initially.
  final bool initiallyExpanded;

  /// Expansion state callback.
  final ValueChanged<bool>? onExpansionChanged;

  /// Collapsed background.
  final Color? background;

  /// Expanded background.
  final Color? expandedBackground;

  /// Leading/trailing icon color.
  final Color? iconColor;

  /// Title text color.
  final Color? textColor;

  /// Tile padding.
  final EdgeInsets padding;

  /// Show a divider under the header when expanded.
  final bool showDivider;

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppDuration.fast,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _expanded
            ? (widget.expandedBackground ?? widget.background ?? scheme.surface)
            : (widget.background ?? scheme.surface),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: widget.padding,
              child: Row(
                children: <Widget>[
                  if (widget.leading != null) ...<Widget>[
                    widget.leading!,
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null)
                          DefaultTextStyle(
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                            child: widget.subtitle!,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  widget.trailing ??
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: AppDuration.fast,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: widget.iconColor ?? scheme.onSurfaceVariant,
                        ),
                      ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Column(
              children: <Widget>[
                if (widget.showDivider)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ...widget.children,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
    widget.onExpansionChanged?.call(_expanded);
  }
}
