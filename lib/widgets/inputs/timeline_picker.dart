import 'package:flutter/material.dart';

/// A horizontal scrollable timeline date picker.
/// Allows users to pick a date by scrolling through a horizontal timeline.
class TimelinePicker extends StatefulWidget {
  const TimelinePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.itemWidth = 56,
    this.selectedColor,
    this.todayColor,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final double itemWidth;
  final Color? selectedColor;
  final Color? todayColor;

  @override
  State<TimelinePicker> createState() => _TimelinePickerState();
}

class _TimelinePickerState extends State<TimelinePicker> {
  late DateTime _selected;
  late DateTime _first;
  late DateTime _last;
  late ScrollController _scrollController;

  static const List<String> _weekdays = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa'
  ];
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = widget.initialDate ?? now;
    _first = widget.firstDate ?? now.subtract(const Duration(days: 30));
    _last = widget.lastDate ?? now.add(const Duration(days: 60));
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _dayCount => _last.difference(_first).inDays + 1;

  DateTime _dateAt(int index) => _first.add(Duration(days: index));

  void _scrollToSelected() {
    final index = _selected.difference(_first).inDays;
    final offset = (index * widget.itemWidth) - 100;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = widget.selectedColor ?? theme.colorScheme.primary;
    final todayColor = widget.todayColor ?? theme.colorScheme.tertiary;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month/year header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            '${_months[_selected.month - 1]} ${_selected.year}',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 84,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _dayCount,
            itemBuilder: (context, i) {
              final date = _dateAt(i);
              final isSelected = date.year == _selected.year &&
                  date.month == _selected.month &&
                  date.day == _selected.day;
              final isToday = date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              final isWeekend = date.weekday == DateTime.saturday ||
                  date.weekday == DateTime.sunday;

              return GestureDetector(
                onTap: () {
                  setState(() => _selected = date);
                  widget.onDateSelected?.call(date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.itemWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor
                        : isToday
                            ? todayColor.withAlpha(30)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: isToday && !isSelected
                        ? Border.all(color: todayColor, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekdays[date.weekday % 7],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : isWeekend
                                  ? theme.colorScheme.error.withAlpha(180)
                                  : theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (i < _dayCount - 1 &&
                          _dateAt(i + 1).month != date.month)
                        Text(
                          _months[_dateAt(i + 1).month - 1],
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? theme.colorScheme.onPrimary.withAlpha(160)
                                : theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
