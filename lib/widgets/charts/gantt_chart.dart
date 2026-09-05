import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A task or milestone item in a [GanttChart].
class GanttTask {
  const GanttTask({
    required this.name,
    required this.start,
    required this.end,
    this.color,
    this.progress = 1.0,
    this.subtitle,
  });

  /// Task label or title.
  final String name;

  /// Start date.
  final DateTime start;

  /// End date.
  final DateTime end;

  /// Bar color for this task.
  final Color? color;

  /// Completion percentage (0.0 to 1.0).
  final double progress;

  /// Optional subtitle.
  final String? subtitle;

  /// Duration in days (minimum 1).
  int get durationDays => end.difference(start).inDays.clamp(1, 3650);
}

/// A horizontal timeline roadmap / Gantt chart widget.
///
/// ```dart
/// GanttChart(
///   tasks: [
///     GanttTask(
///       name: 'UI Design',
///       start: DateTime(2026, 9, 1),
///       end: DateTime(2026, 9, 15),
///       progress: 0.8,
///     ),
///     GanttTask(
///       name: 'Frontend Development',
///       start: DateTime(2026, 9, 10),
///       end: DateTime(2026, 9, 30),
///       progress: 0.4,
///     ),
///   ],
/// )
/// ```
class GanttChart extends StatelessWidget {
  const GanttChart({
    super.key,
    required this.tasks,
    this.barHeight = 28,
    this.rowHeight = 52,
    this.dayWidth = 24,
    this.taskLabelWidth = 140,
    this.onTaskTap,
  });

  /// The list of tasks to render.
  final List<GanttTask> tasks;

  /// Height of each task bar.
  final double barHeight;

  /// Total height of each task row.
  final double rowHeight;

  /// Width per day on the horizontal timeline.
  final double dayWidth;

  /// Width allocated for task labels on the left.
  final double taskLabelWidth;

  /// Callback when a task bar is tapped.
  final void Function(GanttTask task)? onTaskTap;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No tasks to display')),
      );
    }

    // Determine overall timeline range
    DateTime earliest = tasks.first.start;
    DateTime latest = tasks.first.end;
    for (final GanttTask t in tasks) {
      if (t.start.isBefore(earliest)) earliest = t.start;
      if (t.end.isAfter(latest)) latest = t.end;
    }

    final int totalDays = latest.difference(earliest).inDays + 1;
    final double timelineWidth = totalDays * dayWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Left column: Task names
          SizedBox(
            width: taskLabelWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header spacer
                const SizedBox(height: 36),
                for (final GanttTask task in tasks)
                  Container(
                    height: rowHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          task.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        if (task.subtitle != null)
                          Text(
                            task.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Timeline & Bars
          SizedBox(
            width: timelineWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Timeline header (day or week markers)
                SizedBox(
                  height: 36,
                  child: Row(
                    children: <Widget>[
                      for (int d = 0; d < totalDays; d += 7)
                        Container(
                          width: ((totalDays - d) < 7 ? (totalDays - d) : 7) *
                              dayWidth,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '${earliest.add(Duration(days: d)).month}/${earliest.add(Duration(days: d)).day}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Task rows
                for (final GanttTask task in tasks)
                  Container(
                    height: rowHeight,
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[
                        // Row background guideline
                        Positioned.fill(
                          child: Divider(
                            height: 1,
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        // Task Bar
                        Positioned(
                          left:
                              task.start.difference(earliest).inDays * dayWidth,
                          width: task.durationDays * dayWidth,
                          top: (rowHeight - barHeight) / 2,
                          height: barHeight,
                          child: InkWell(
                            onTap: onTaskTap != null
                                ? () => onTaskTap!(task)
                                : null,
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                            child: Container(
                              decoration: BoxDecoration(
                                color: (task.color ?? AppColors.primary)
                                    .withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.medium),
                                border: Border.all(
                                  color: task.color ?? AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppRadius.medium - 1.5),
                                child: Stack(
                                  children: <Widget>[
                                    // Progress fill
                                    FractionallySizedBox(
                                      widthFactor:
                                          task.progress.clamp(0.0, 1.0),
                                      child: Container(
                                        color: task.color ?? AppColors.primary,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Text(
                                          '${(task.progress * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: task.progress > 0.4
                                                ? Colors.white
                                                : (task.color ??
                                                    AppColors.primary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
