import 'package:flutter/material.dart';

import '../../spacing/app_spacing.dart';

/// A vertical timeline of events.
class Timeline extends StatelessWidget {
  const Timeline({
    super.key,
    required this.items,
    this.lineColor,
    this.iconColor,
    this.lineWidth = 2,
    this.leadingWidth = 44,
  });

  /// Timeline items.
  final List<TimelineItem> items;

  /// Connecting line color.
  final Color? lineColor;

  /// Dot icon color.
  final Color? iconColor;

  /// Connecting line width.
  final double lineWidth;

  /// Leading column width.
  final double leadingWidth;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color line = lineColor ?? scheme.outlineVariant;

    return Column(
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          _TimelineRow(
            item: items[i],
            lineColor: line,
            iconColor: iconColor ?? scheme.primary,
            lineWidth: lineWidth,
            leadingWidth: leadingWidth,
            isFirst: i == 0,
            isLast: i == items.length - 1,
          ),
        ],
      ],
    );
  }
}

/// A single timeline entry.
class TimelineItem {
  const TimelineItem({
    required this.title,
    required this.time,
    this.description,
    this.icon,
    this.color,
    this.trailing,
  });

  /// Event title.
  final String title;

  /// Event time/label.
  final String time;

  /// Event description.
  final String? description;

  /// Dot icon (defaults to a filled dot).
  final IconData? icon;

  /// Dot color.
  final Color? color;

  /// Optional trailing widget.
  final Widget? trailing;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.lineColor,
    required this.iconColor,
    required this.lineWidth,
    required this.leadingWidth,
    required this.isFirst,
    required this.isLast,
  });

  final TimelineItem item;
  final Color lineColor;
  final Color iconColor;
  final double lineWidth;
  final double leadingWidth;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color dotColor = item.color ?? iconColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: leadingWidth,
            child: Column(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.35),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: item.icon == null
                      ? null
                      : Icon(
                          item.icon,
                          size: 5,
                          color: Colors.white,
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: lineWidth,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.title,
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        item.time,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      if (item.trailing != null) ...<Widget>[
                        const SizedBox(width: 8),
                        item.trailing!,
                      ],
                    ],
                  ),
                  if (item.description != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
