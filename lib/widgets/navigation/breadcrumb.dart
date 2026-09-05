import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A breadcrumb navigation trail.
class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    super.key,
    required this.items,
    this.onTap,
    this.color,
    this.separator = '/',
    this.maxItems,
  });

  /// Breadcrumb labels.
  final List<String> items;

  /// Item tap callback (receives index).
  final ValueChanged<int>? onTap;

  /// Active item color.
  final Color? color;

  /// Separator text.
  final String separator;

  /// Max visible items (middle items collapse to `...`).
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color accent = color ?? scheme.primary;

    final List<String> shown = _collapse(items, maxItems);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: <Widget>[
        for (int i = 0; i < shown.length; i++) ...<Widget>[
          if (i > 0)
            Text(
              separator,
              style:
                  textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          if (shown[i] == '...')
            Text(
              '...',
              style:
                  textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            )
          else
            GestureDetector(
              onTap: onTap == null ? null : () => onTap!(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: i == shown.length - 1
                      ? accent.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  shown[i],
                  style: textTheme.bodyMedium?.copyWith(
                    color: i == shown.length - 1
                        ? accent
                        : scheme.onSurfaceVariant,
                    fontWeight: i == shown.length - 1
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  static List<String> _collapse(List<String> items, int? maxItems) {
    if (maxItems == null || items.length <= maxItems) return items;
    if (maxItems < 3) return items.sublist(0, maxItems);
    final List<String> result = <String>[
      items.first,
      '...',
      ...items.sublist(items.length - (maxItems - 2)),
    ];
    return result;
  }
}
