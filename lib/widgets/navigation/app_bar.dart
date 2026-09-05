import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/material.dart' as fl show AppBar;

import '../../icons/app_icons.dart';
import '../../spacing/app_spacing.dart';
import '../../theme/theme_extension.dart';

/// A modern app bar with title, subtitle, actions and optional scroll effects.
///
/// A backwards-compatible alias for [AppBar].
typedef NashAppBar = AppBar;

/// A modern app bar with title, subtitle, actions and optional scroll effects.
class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.pinned = true,
    this.titleSpacing = AppSpacing.sm,
    this.toolbarHeight,
    this.bottom,
    this.onBack,
    this.scrolledUnderElevation = 2,
    this.titleStyle,
    this.backIcon,
  });

  /// App bar title (accepts String or Widget).
  final dynamic title;

  /// App bar subtitle (accepts String or Widget).
  final dynamic subtitle;

  /// Trailing action widgets.
  final List<Widget>? actions;

  /// Custom leading widget.
  final Widget? leading;

  /// Whether to add the default back button.
  final bool automaticallyImplyLeading;

  /// Whether to center the title.
  final bool centerTitle;

  /// Background color.
  final Color? backgroundColor;

  /// Foreground (icon/text) color.
  final Color? foregroundColor;

  /// Elevation.
  final double elevation;

  /// Whether the app bar is pinned during scroll.
  final bool pinned;

  /// Title horizontal spacing.
  final double titleSpacing;

  /// Toolbar height.
  final double? toolbarHeight;

  /// Bottom widget (e.g. tabs).
  final PreferredSizeWidget? bottom;

  /// Custom back callback.
  final VoidCallback? onBack;

  /// Scrolled under elevation.
  final double scrolledUnderElevation;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Back button icon.
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    final AppThemeExtension theme = AppThemeExtension.of(context);
    final Widget? resolvedLeading = leading ??
        (automaticallyImplyLeading &&
                Navigator.maybeOf(context)?.canPop() == true
            ? IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                icon: Icon(backIcon ?? AppIcons.back, size: 22),
              )
            : null);

    final PreferredSizeWidget? resolvedBottom = bottom;
    final double height = toolbarHeight ??
        kToolbarHeight +
            (subtitle == null ? 0 : 16) +
            (resolvedBottom?.preferredSize.height ?? 0);

    return fl.AppBar(
      toolbarHeight: height,
      backgroundColor: backgroundColor ?? theme.appBar.background,
      foregroundColor: foregroundColor ?? theme.appBar.foreground,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: resolvedLeading,
      titleSpacing: titleSpacing,
      bottom: resolvedBottom,
      title: () {
        final Widget? titleWidget = title is Widget
            ? (title as Widget)
            : (title is String
                ? Text(
                    title as String,
                    style: titleStyle ??
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: foregroundColor ?? theme.appBar.foreground,
                              fontWeight: FontWeight.w700,
                            ),
                  )
                : null);
        final Widget? subtitleWidget = subtitle is Widget
            ? (subtitle as Widget)
            : (subtitle is String
                ? Text(
                    subtitle as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: (foregroundColor ?? theme.appBar.foreground)
                              .withValues(alpha: 0.75),
                        ),
                  )
                : null);

        if (titleWidget == null) return null;
        if (subtitleWidget == null) return titleWidget;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[titleWidget, subtitleWidget],
        );
      }(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ??
            kToolbarHeight +
                (subtitle == null ? 0 : 16) +
                (bottom?.preferredSize.height ?? 0),
      );
}

/// A section header with title, subtitle and optional action.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.titleStyle,
    this.subtitleStyle,
    this.showDivider = false,
  });

  /// Section title.
  final String title;

  /// Section subtitle.
  final String? subtitle;

  /// Action label (e.g. `See all`).
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Outer padding.
  final EdgeInsets padding;

  /// Title style.
  final TextStyle? titleStyle;

  /// Subtitle style.
  final TextStyle? subtitleStyle;

  /// Show a divider below.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: titleStyle ??
                          textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: subtitleStyle ??
                            textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              if (actionLabel != null) ...<Widget>[
                GestureDetector(
                  onTap: onAction,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        actionLabel!,
                        style: textTheme.labelMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded,
                          size: 16, color: scheme.primary),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (showDivider) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ],
        ],
      ),
    );
  }
}

/// A scroll-aware header that fades/slides out on scroll.
class CollapsibleHeader extends StatelessWidget {
  const CollapsibleHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.scrollController,
    this.minHeight = 96,
    this.maxHeight = 200,
  });

  /// Header title.
  final String title;

  /// Header subtitle.
  final String? subtitle;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Scroll controller used to track offset.
  final ScrollController? scrollController;

  /// Collapsed height.
  final double minHeight;

  /// Expanded height.
  final double maxHeight;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: scrollController ?? const AlwaysStoppedAnimation<double>(0),
        builder: (BuildContext context, Widget? child) {
          final double offset = scrollController?.hasClients == true
              ? scrollController!.offset
              : 0;
          final double progress =
              (offset / (maxHeight - minHeight)).clamp(0.0, 1.0);
          final double height = maxHeight - progress * (maxHeight - minHeight);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding:
                const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 0),
            child: Opacity(
              opacity: progress < 0.9 ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      );
}
