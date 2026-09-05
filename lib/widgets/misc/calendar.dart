import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../animation/duration.dart';
import '../../spacing/app_spacing.dart';

/// A month calendar widget with selection, range and events support.
class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    this.initialMonth,
    this.initialSelected,
    this.onSelected,
    this.initialRange,
    this.onRangeSelected,
    this.mode = CalendarMode.single,
    this.locale,
    this.monthFormat,
    this.weekdayLabels,
    this.firstDayOfWeek = DateTime.monday,
    this.markerDates = const <DateTime>{},
    this.markerColor,
    this.selectedColor,
    this.todayColor,
    this.dayBuilder,
    this.monthTextStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
    this.showOutsideDays = true,
    this.showTrailingOutsideDays = true,
  });

  /// Initially displayed month.
  final DateTime? initialMonth;

  /// Initially selected date(s).
  final DateTime? initialSelected;

  /// Single-selection callback.
  final ValueChanged<DateTime>? onSelected;

  /// Initial range.
  final DateTimeRange? initialRange;

  /// Range-selection callback.
  final ValueChanged<DateTimeRange>? onRangeSelected;

  /// Selection mode.
  final CalendarMode mode;

  /// Calendar locale (used for month names).
  final String? locale;

  /// Month title format.
  final DateFormat? monthFormat;

  /// Custom weekday headers (7 entries, starting from [firstDayOfWeek]).
  final List<String>? weekdayLabels;

  /// First day of the week.
  final int firstDayOfWeek;

  /// Dates to highlight with a dot.
  final Set<DateTime> markerDates;

  /// Marker dot color.
  final Color? markerColor;

  /// Selected day background color.
  final Color? selectedColor;

  /// Today outline color.
  final Color? todayColor;

  /// Custom day cell builder.
  final Widget Function(BuildContext, DateTime)? dayBuilder;

  /// Month title style.
  final TextStyle? monthTextStyle;

  /// Weekday header style.
  final TextStyle? weekdayTextStyle;

  /// Day number style.
  final TextStyle? dayTextStyle;

  /// Show days from the previous month in the leading cells.
  final bool showOutsideDays;

  /// Show days from the next month in the trailing cells.
  final bool showTrailingOutsideDays;

  @override
  State<Calendar> createState() => _CalendarState();
}

/// Selection mode for [Calendar].
enum CalendarMode {
  /// Pick a single day.
  single,

  /// Pick a start and end day.
  range,
}

class _CalendarState extends State<Calendar> {
  late DateTime _month;
  DateTime? _selected;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _tempEnd;

  static const List<String> _defaultWeekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _month = _firstOfMonth(widget.initialMonth ?? now);
    _selected = _dateOnly(widget.initialSelected);
    if (widget.initialRange != null) {
      _rangeStart = _dateOnly(widget.initialRange!.start);
      _rangeEnd = _dateOnly(widget.initialRange!.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateFormat fmt =
        widget.monthFormat ?? DateFormat.MMMM(_localeName).addPattern(' yyyy');

    final List<String> weekdays = widget.weekdayLabels ??
        _shiftedWeekdays(_defaultWeekdays, widget.firstDayOfWeek);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => _shiftMonth(-1),
            ),
            Expanded(
              child: Center(
                child: Text(
                  fmt.format(_month),
                  style: widget.monthTextStyle ??
                      textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () => _shiftMonth(1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            for (final String w in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: widget.weekdayTextStyle ??
                        textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildGrid(scheme, textTheme),
      ],
    );
  }

  Widget _buildGrid(ColorScheme scheme, TextTheme textTheme) {
    final int firstWeekday = _month.weekday;
    final int offset = (firstWeekday - widget.firstDayOfWeek) % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);

    final DateTime leadingMonth = DateTime(_month.year, _month.month - 1);
    final int daysInLeading =
        DateUtils.getDaysInMonth(leadingMonth.year, leadingMonth.month);

    final DateTime now = _dateOnly(DateTime.now());
    final int cells = (offset + daysInMonth + 6) ~/ 7 * 7;

    final List<Widget> rows = <Widget>[];
    final List<Widget> row = <Widget>[];

    void pushRow() {
      rows.add(Row(children: <Widget>[...row]));
      row.clear();
    }

    for (int i = 0; i < cells; i++) {
      final int cellDay = i - offset + 1;
      final bool isLeading = cellDay <= 0;
      final bool isTrailing = cellDay > daysInMonth;

      final DateTime date;
      if (isLeading) {
        date = DateTime(
            leadingMonth.year, leadingMonth.month, daysInLeading + cellDay);
      } else if (isTrailing) {
        final DateTime trailing =
            DateTime(_month.year, _month.month, cellDay - daysInMonth);
        date = DateTime(trailing.year, trailing.month + 1, trailing.day);
      } else {
        date = DateTime(_month.year, _month.month, cellDay);
      }

      final bool show = isLeading
          ? widget.showOutsideDays
          : isTrailing
              ? widget.showTrailingOutsideDays
              : true;
      final bool sameMonth = !isLeading && !isTrailing;
      final bool isToday = date == now;
      final bool isSelected = _isInSelection(date);

      row.add(Expanded(
        child: SizedBox(
          height: 48,
          child: widget.dayBuilder != null && sameMonth
              ? widget.dayBuilder!(context, date)
              : _DayCell(
                  date: date,
                  visible: show,
                  inMonth: sameMonth,
                  isToday: isToday,
                  isSelected: isSelected,
                  isRangeStart: _isRangeStart(date),
                  isRangeEnd: _isRangeEnd(date),
                  isRange: _isRangeBetween(date),
                  hasMarker: widget.markerDates.contains(date),
                  markerColor: widget.markerColor ?? scheme.primary,
                  selectedColor: widget.selectedColor ?? scheme.primary,
                  todayColor: widget.todayColor ?? scheme.primary,
                  textStyle: widget.dayTextStyle,
                  scheme: scheme,
                  textTheme: textTheme,
                  onTap: () => _handleTap(date),
                ),
        ),
      ));

      if (row.length == 7) pushRow();
    }
    if (row.isNotEmpty) pushRow();

    return Column(children: rows);
  }

  bool _isInSelection(DateTime date) {
    if (widget.mode == CalendarMode.single) return _selected == date;
    final DateTime? rangeStart = _rangeStart;
    if (rangeStart == null) return false;
    final DateTime end = _tempEnd ?? _rangeEnd ?? rangeStart;
    final DateTime lo = rangeStart.isBefore(end) ? rangeStart : end;
    final DateTime hi = rangeStart.isBefore(end) ? end : rangeStart;
    return !date.isBefore(lo) && !date.isAfter(hi);
  }

  bool _isRangeStart(DateTime date) {
    if (widget.mode != CalendarMode.range || _rangeStart == null) {
      return false;
    }
    return date == _rangeStart;
  }

  bool _isRangeEnd(DateTime date) {
    if (widget.mode != CalendarMode.range) return false;
    return date == (_tempEnd ?? _rangeEnd);
  }

  bool _isRangeBetween(DateTime date) {
    final DateTime? rangeStart = _rangeStart;
    if (widget.mode != CalendarMode.range || rangeStart == null) {
      return false;
    }
    final DateTime? end = _tempEnd ?? _rangeEnd;
    if (end == null) return false;
    final DateTime lo = rangeStart.isBefore(end) ? rangeStart : end;
    final DateTime hi = rangeStart.isBefore(end) ? end : rangeStart;
    return date.isAfter(lo) && date.isBefore(hi);
  }

  void _handleTap(DateTime date) {
    setState(() {
      if (widget.mode == CalendarMode.single) {
        _selected = date;
        widget.onSelected?.call(date);
      } else {
        if (_rangeStart == null || (_rangeEnd != null && _tempEnd == null)) {
          _rangeStart = date;
          _rangeEnd = null;
          _tempEnd = null;
        } else if (_tempEnd == null) {
          _tempEnd = date;
        } else {
          final DateTime start = _rangeStart!;
          final DateTime end = _tempEnd!;
          final DateTime lo = start.isBefore(end) ? start : end;
          final DateTime hi = start.isBefore(end) ? end : start;
          _rangeStart = lo;
          _rangeEnd = hi;
          _tempEnd = null;
          widget.onRangeSelected?.call(DateTimeRange(start: lo, end: hi));
        }
      }
    });
  }

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
  }

  String get _localeName => widget.locale ?? 'en';

  static DateTime _firstOfMonth(DateTime d) => DateTime(d.year, d.month);

  static DateTime _dateOnly(DateTime? d) =>
      d == null ? _dateOnly(DateTime.now()) : DateTime(d.year, d.month, d.day);

  static List<String> _shiftedWeekdays(List<String> labels, int firstDay) {
    final int index = firstDay - DateTime.monday;
    return <String>[
      for (int i = 0; i < 7; i++) labels[(index + i) % 7],
    ];
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.visible,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isRange,
    required this.hasMarker,
    required this.markerColor,
    required this.selectedColor,
    required this.todayColor,
    required this.textStyle,
    required this.scheme,
    required this.textTheme,
    required this.onTap,
  });

  final DateTime date;
  final bool visible;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isRange;
  final bool hasMarker;
  final Color markerColor;
  final Color selectedColor;
  final Color todayColor;
  final TextStyle? textStyle;
  final ColorScheme scheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color numberColor = !inMonth
        ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
        : scheme.onSurface;

    Color bg = Colors.transparent;
    if (isSelected) bg = selectedColor;

    final Widget dot = hasMarker
        ? Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
            ),
          )
        : const SizedBox(height: 7);

    final Widget day = AnimatedContainer(
      duration: AppDuration.fast,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: todayColor, width: 1.5) : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${date.day}',
              style: textStyle ??
                  textTheme.bodySmall?.copyWith(
                    color: isSelected ? Colors.white : numberColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
            ),
            dot,
          ],
        ),
      ),
    );

    if (!visible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isRange && !isRangeStart && !isRangeEnd
                    ? selectedColor.withValues(alpha: 0.18)
                    : Colors.transparent,
              ),
              child: day,
            ),
          ),
        ],
      ),
    );
  }
}
