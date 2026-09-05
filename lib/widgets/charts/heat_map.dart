import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A GitHub-style contribution heat map widget.
///
/// Displays daily intensity levels in a responsive grid grouped by weeks and months.
///
/// ```dart
/// HeatMap(
///   data: {
///     DateTime(2026, 8, 1): 5,
///     DateTime(2026, 8, 2): 12,
///   },
///   onDayTap: (date, count) {
///     print('$date had $count activities');
///   },
/// )
/// ```
class HeatMap extends StatelessWidget {
  const HeatMap({
    super.key,
    required this.data,
    this.startDate,
    this.endDate,
    this.cellSize = 14,
    this.cellSpacing = 3,
    this.borderRadius = AppRadius.small,
    this.colorRange,
    this.emptyColor,
    this.showMonthLabels = true,
    this.showDayLabels = true,
    this.onDayTap,
  });

  /// Map of [DateTime] to activity count / intensity.
  final Map<DateTime, int> data;

  /// Start date of the heatmap (defaults to 90 days ago).
  final DateTime? startDate;

  /// End date of the heatmap (defaults to today).
  final DateTime? endDate;

  /// Width and height of each day cell.
  final double cellSize;

  /// Spacing between cells.
  final double cellSpacing;

  /// Border radius of each cell.
  final double borderRadius;

  /// Color gradient steps from low to high activity (4 levels).
  final List<Color>? colorRange;

  /// Color for cells with 0 activity.
  final Color? emptyColor;

  /// Whether to render month headers.
  final bool showMonthLabels;

  /// Whether to render day-of-week labels (Mon, Wed, Fri).
  final bool showDayLabels;

  /// Callback when a day cell is tapped.
  final void Function(DateTime date, int count)? onDayTap;

  DateTime _normalize(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    final DateTime end = _normalize(endDate ?? DateTime.now());
    final DateTime start =
        _normalize(startDate ?? end.subtract(const Duration(days: 90)));

    // Default color range: shades of primary
    final List<Color> colors = colorRange ??
        <Color>[
          const Color(0xFFC7D2FE),
          const Color(0xFF818CF8),
          const Color(0xFF4F46E5),
          const Color(0xFF312E81),
        ];

    final Color inactiveColor = emptyColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : const Color(0xFFF1F5F9));

    // Group dates into weeks (7 days each, starting Sunday=7 or Monday=1)
    // Find previous Monday or start of week
    int daysOffset = start.weekday - DateTime.monday;
    if (daysOffset < 0) daysOffset += 7;
    final DateTime gridStart = start.subtract(Duration(days: daysOffset));

    final int totalDays = end.difference(gridStart).inDays + 1;
    final int totalWeeks = (totalDays / 7).ceil();

    final Map<DateTime, int> normalizedData = <DateTime, int>{};
    for (final MapEntry<DateTime, int> entry in data.entries) {
      normalizedData[_normalize(entry.key)] = entry.value;
    }

    // Determine max value for auto scaling
    int maxVal = 1;
    for (final int v in normalizedData.values) {
      if (v > maxVal) maxVal = v;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showDayLabels) ...<Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (showMonthLabels) SizedBox(height: cellSize + 4),
                for (int d = 0; d < 7; d++)
                  SizedBox(
                    height: cellSize + cellSpacing,
                    child: Center(
                      child: Text(
                        d == 1
                            ? 'Mon'
                            : (d == 3 ? 'Wed' : (d == 5 ? 'Fri' : '')),
                        style: TextStyle(
                          fontSize: cellSize * 0.7,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: cellSpacing * 2),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(
                  totalWeeks,
                  (int weekIndex) => Padding(
                    padding: EdgeInsets.only(right: cellSpacing),
                    child: Column(
                      children: List<Widget>.generate(7, (int dayIndex) {
                        final DateTime currentDay = gridStart.add(
                          Duration(days: weekIndex * 7 + dayIndex),
                        );
                        if (currentDay.isAfter(end) ||
                            currentDay.isBefore(start)) {
                          return SizedBox(
                              width: cellSize, height: cellSize + cellSpacing);
                        }

                        final int count = normalizedData[currentDay] ?? 0;
                        Color cellColor = inactiveColor;
                        if (count > 0) {
                          final double intensity =
                              (count / maxVal).clamp(0.0, 1.0);
                          final int colorIdx = (intensity * (colors.length - 1))
                              .round()
                              .clamp(0, colors.length - 1);
                          cellColor = colors[colorIdx];
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: cellSpacing),
                          child: InkWell(
                            onTap: onDayTap != null
                                ? () => onDayTap!(currentDay, count)
                                : null,
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Tooltip(
                              message:
                                  '${currentDay.year}-${currentDay.month.toString().padLeft(2, '0')}-${currentDay.day.toString().padLeft(2, '0')}: $count',
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
