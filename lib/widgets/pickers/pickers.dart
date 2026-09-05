import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// A styled time picker following the design system.
///
/// ```dart
/// final TimeOfDay? time = await showStyledTimePicker(
///   context: context,
///   initialTime: TimeOfDay.now(),
/// )
/// ```
Future<TimeOfDay?> showStyledTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  String? helpText,
}) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: helpText ?? 'SELECT TIME',
    builder: (BuildContext context, Widget? child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: scheme,
        timePickerTheme: TimePickerThemeData(
          backgroundColor: scheme.surfaceContainerLow,
          hourMinuteColor: scheme.surfaceContainerHighest,
          dayPeriodColor: scheme.surfaceContainerHighest,
          dialHandColor: scheme.primary,
          dialBackgroundColor: scheme.surfaceContainerHighest,
          entryModeIconColor: scheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
          hourMinuteShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          dayPeriodShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
      child: child!,
    ),
  );
}

/// A styled date range picker following the design system.
///
/// ```dart
/// final DateTimeRange? range = await showDateRangeDialog(
///   context: context,
///   firstDate: DateTime(2024),
///   lastDate: DateTime(2026),
/// )
/// ```
Future<DateTimeRange?> showDateRangeDialog({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  String? helpText,
  String? cancelText,
  String? confirmText,
}) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialDateRange,
    helpText: helpText ?? 'SELECT DATE RANGE',
    cancelText: cancelText,
    confirmText: confirmText,
    builder: (BuildContext context, Widget? child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: scheme,
        datePickerTheme: DatePickerThemeData(
          backgroundColor: scheme.surfaceContainerLow,
          headerBackgroundColor: scheme.primary,
          headerForegroundColor: scheme.onPrimary,
          dayBackgroundColor: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return scheme.primary;
              }
              return null;
            },
          ),
          todayBackgroundColor: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return scheme.primary;
              }
              return scheme.primary.withValues(alpha: 0.12);
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
        ),
      ),
      child: child!,
    ),
  );
}

/// A styled duration picker.
///
/// ```dart
/// final Duration? duration = await showDurationPicker(
///   context: context,
///   initialDuration: Duration(hours: 1),
/// )
/// ```
Future<Duration?> showDurationPicker({
  required BuildContext context,
  Duration initialDuration = Duration.zero,
  String? helpText,
}) async {
  int hours = initialDuration.inHours;
  int minutes = initialDuration.inMinutes.remainder(60);

  final ColorScheme scheme = Theme.of(context).colorScheme;

  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        backgroundColor: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        ),
        title: Text(helpText ?? 'Select Duration'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _DurationColumn(
              label: 'H',
              value: hours,
              onChanged: (int v) => setState(() => hours = v),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(':',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            _DurationColumn(
              label: 'M',
              value: minutes,
              max: 59,
              onChanged: (int v) => setState(() => minutes = v),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );

  if (confirmed == true) {
    return Duration(hours: hours, minutes: minutes);
  }
  return null;
}

class _DurationColumn extends StatelessWidget {
  const _DurationColumn({
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 23,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.keyboard_arrow_up),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

/// A time range picker (start + end time).
///
/// ```dart
/// final TimeRange? range = await showTimeRangePicker(
///   context: context,
///   startTime: TimeOfDay(hour: 9, minute: 0),
///   endTime: TimeOfDay(hour: 17, minute: 0),
/// )
/// ```
class TimeRange {
  const TimeRange({required this.start, required this.end});
  final TimeOfDay start;
  final TimeOfDay end;

  Duration get duration => Duration(
      hours: end.hour - start.hour, minutes: end.minute - start.minute);
}

Future<TimeRange?> showTimeRangePicker({
  required BuildContext context,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
  String? helpText,
}) async {
  final TimeOfDay? start = await showStyledTimePicker(
    context: context,
    initialTime: startTime ?? const TimeOfDay(hour: 9, minute: 0),
    helpText: helpText ?? 'START TIME',
  );
  if (start == null) return null;
  if (!context.mounted) return null;

  final TimeOfDay? end = await showStyledTimePicker(
    context: context,
    initialTime: endTime ?? const TimeOfDay(hour: 17, minute: 0),
    helpText: helpText ?? 'END TIME',
  );
  if (end == null) return null;

  return TimeRange(start: start, end: end);
}
