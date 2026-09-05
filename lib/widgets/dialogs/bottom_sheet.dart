import 'package:flutter/material.dart' hide BottomSheet, showBottomSheet;

import '../../spacing/app_spacing.dart';

/// A backwards-compatible alias for [BottomSheet].
typedef NashBottomSheet = BottomSheet;

/// A modal bottom sheet with a handle, optional title and rounded top corners.
class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.showHandle = true,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
    this.background,
    this.leading,
    this.trailing,
    this.scrollControlled = true,
    this.maxHeight,
  });

  /// Sheet title.
  final String? title;

  /// Sheet subtitle.
  final String? subtitle;

  /// Sheet body content.
  final Widget? content;

  /// Bottom action buttons.
  final List<Widget>? actions;

  /// Whether to show the drag handle.
  final bool showHandle;

  /// Sheet padding.
  final EdgeInsets padding;

  /// Sheet background color.
  final Color? background;

  /// Leading widget.
  final Widget? leading;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether the sheet size follows the content.
  final bool scrollControlled;

  /// Maximum sheet height.
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Widget sheet = Material(
      color: background ?? scheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (showHandle)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.12,
                      child: Container(
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                  ),
                ),
              if (title != null || leading != null || trailing != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                  child: Row(
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        leading!,
                        const SizedBox(width: AppSpacing.md),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (title != null)
                              Text(
                                title!,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ),
              if (content != null) Padding(padding: padding, child: content),
              if (actions != null && actions!.isNotEmpty)
                Padding(
                  padding: padding.copyWith(top: 4),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: actions!,
                  ),
                ),
              SizedBox(
                  height: MediaQuery.paddingOf(context).bottom > 0 ? 8 : 16),
            ],
          ),
        ),
      ),
    );

    return sheet;
  }
}

/// Shows a modal bottom sheet and returns the sheet widget.
Future<T?> showBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useSafeArea = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext context) => child,
    );
