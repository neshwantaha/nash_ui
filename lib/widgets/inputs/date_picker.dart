import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';
import '../buttons/outline_button.dart';
import '../buttons/primary_button.dart';
import '../misc/calendar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. HorizontalDatePicker (Timeline / Strip style)
// ─────────────────────────────────────────────────────────────────────────────

/// A horizontal date strip / timeline date picker widget.
///
/// Ideal for booking, scheduling, habit tracking, and fitness applications.
///
/// ```dart
/// HorizontalDatePicker(
///   initialDate: DateTime.now(),
///   startDate: DateTime.now().subtract(const Duration(days: 7)),
///   endDate: DateTime.now().add(const Duration(days: 30)),
///   onDateSelected: (date) => print('Selected: $date'),
/// )
/// ```
class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.startDate,
    this.endDate,
    this.itemWidth = 62.0,
    this.height = 92.0,
    this.selectedColor,
    this.selectedGradient,
    this.locale,
    this.markedDates = const <DateTime>{},
    this.disabledDates = const <DateTime>{},
    this.showHeader = true,
  });

  /// Called when a date is tapped.
  final ValueChanged<DateTime> onDateSelected;

  /// The initially selected date (defaults to today).
  final DateTime? initialDate;

  /// The start of the date range (defaults to 14 days before today).
  final DateTime? startDate;

  /// The end of the date range (defaults to 60 days after today).
  final DateTime? endDate;

  /// Width of each date pill item.
  final double itemWidth;

  /// Overall height of the picker strip.
  final double height;

  /// Background color for the selected day card.
  final Color? selectedColor;

  /// Optional gradient for the selected day card.
  final Gradient? selectedGradient;

  /// Locale string (e.g. 'en', 'ar').
  final String? locale;

  /// Set of dates that have an indicator dot.
  final Set<DateTime> markedDates;

  /// Set of dates that cannot be selected.
  final Set<DateTime> disabledDates;

  /// Whether to show the month / year header above the strip.
  final bool showHeader;

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime _selected;
  late DateTime _start;
  late DateTime _end;
  late final ScrollController _scrollController;
  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selected = widget.initialDate != null
        ? DateTime(widget.initialDate!.year, widget.initialDate!.month,
            widget.initialDate!.day)
        : today;
    _start = widget.startDate != null
        ? DateTime(widget.startDate!.year, widget.startDate!.month,
            widget.startDate!.day)
        : today.subtract(const Duration(days: 7));
    _end = widget.endDate != null
        ? DateTime(
            widget.endDate!.year, widget.endDate!.month, widget.endDate!.day)
        : today.add(const Duration(days: 60));

    _days = [];
    DateTime cur = _start;
    while (!cur.isAfter(_end)) {
      _days.add(cur);
      cur = cur.add(const Duration(days: 1));
    }

    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final idx = _days.indexWhere((d) =>
        d.year == _selected.year &&
        d.month == _selected.month &&
        d.day == _selected.day);
    if (idx != -1 && _scrollController.hasClients) {
      final offset = (idx * (widget.itemWidth + 8.0)) -
          (MediaQuery.of(context).size.width / 2) +
          (widget.itemWidth / 2);
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: AppDuration.normal,
        curve: Curves.easeOutCubic,
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.selectedColor ?? AppColors.primary;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMM(widget.locale).format(_selected),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final today = DateTime(now.year, now.month, now.day);
                    setState(() => _selected = today);
                    _scrollToSelected();
                    widget.onDateSelected(today);
                  },
                  icon: const Icon(Icons.today_rounded, size: 16),
                  label: const Text('Today', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: widget.height,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = _days[index];
              final isSelected = _isSameDay(day, _selected);
              final isToday = _isSameDay(day, now);
              final isMarked =
                  widget.markedDates.any((d) => _isSameDay(d, day));
              final isDisabled =
                  widget.disabledDates.any((d) => _isSameDay(d, day));

              final weekday = DateFormat.E(widget.locale).format(day);
              final dayNumber = day.day.toString();

              return Opacity(
                opacity: isDisabled ? 0.4 : 1.0,
                child: GestureDetector(
                  onTap: isDisabled
                      ? null
                      : () {
                          setState(() => _selected = day);
                          widget.onDateSelected(day);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: widget.itemWidth,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? (widget.selectedGradient ?? AppGradients.primary)
                          : null,
                      color: isSelected
                          ? primary
                          : (isDark
                              ? const Color(0xFF1B1B2F)
                              : const Color(0xFFF3F4F8)),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isToday
                                ? primary.withValues(alpha: 0.6)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.06))),
                        width: isToday && !isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekday.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : (isDark ? Colors.white54 : Colors.black45),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        if (isMarked) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ] else if (isToday && !isSelected) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// 2. WheelDatePicker (Cupertino / Spinner style)
// ─────────────────────────────────────────────────────────────────────────────

/// An iOS-style spinner / wheel date picker.
///
/// Clean, scrollable wheel selection for Day, Month, and Year.
///
/// ```dart
/// WheelDatePicker(
///   initialDate: DateTime.now(),
///   onDateChanged: (date) => print(date),
/// )
/// ```
class WheelDatePicker extends StatefulWidget {
  const WheelDatePicker({
    super.key,
    required this.onDateChanged,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.height = 180.0,
    this.locale,
  });

  /// Called when the wheel is scrolled to a new date.
  final ValueChanged<DateTime> onDateChanged;

  /// Selected date.
  final DateTime? initialDate;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Total height of the wheel container.
  final double height;

  /// Locale string.
  final String? locale;

  @override
  State<WheelDatePicker> createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<WheelDatePicker> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final min = widget.minDate ?? DateTime(1900);
    final max = widget.maxDate ?? DateTime(2100);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151522) : const Color(0xFFF9F9FD),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selected.isBefore(min)
              ? min
              : (_selected.isAfter(max) ? max : _selected),
          minimumDate: min,
          maximumDate: max,
          onDateTimeChanged: (date) {
            setState(() => _selected = date);
            widget.onDateChanged(date);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. DatePickerDialog & BottomSheet (Modal Calendar Picker)
// ─────────────────────────────────────────────────────────────────────────────

/// Shows a rich, modern modal bottom sheet date picker styled with Nash UI tokens.
///
/// ```dart
/// final date = await showDatePicker(context);
/// ```
Future<DateTime?> showDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'Select Date',
  String? locale,
}) =>
    showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DatePickerBottomSheet(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(2100),
        title: title,
        locale: locale,
      ),
    );

class _DatePickerBottomSheet extends StatefulWidget {
  const _DatePickerBottomSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.title,
    this.locale,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final String? locale;

  @override
  State<_DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<_DatePickerBottomSheet> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar
          Calendar(
            initialSelected: _selected,
            initialMonth: _selected,
            locale: widget.locale,
            onSelected: (d) => setState(() => _selected = d),
          ),
          const SizedBox(height: 20),

          // Footer buttons
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Apply',
                  onPressed: () => Navigator.of(context).pop(_selected),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. DateRangePicker (Quick Presets + Range Selection)
// ─────────────────────────────────────────────────────────────────────────────

/// Shows a date range picker modal with quick preset chips (Today, This Week, This Month, etc.).
///
/// ```dart
/// final range = await showDateRangePicker(context);
/// ```
Future<DateTimeRange?> showDateRangePicker({
  required BuildContext context,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTimeRange? initialDateRange,
  DateTimeRange? initialRange,
  String title = 'Select Date Range',
}) =>
    showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DateRangeBottomSheet(
        initialRange: initialDateRange ?? initialRange,
        title: title,
      ),
    );

/// Alias for [showDateRangePicker] with positional context.
Future<DateTimeRange?> showNashDateRangePicker(
  BuildContext context, {
  DateTime? firstDate,
  DateTime? lastDate,
  DateTimeRange? initialDateRange,
  DateTimeRange? initialRange,
  String title = 'Select Date Range',
}) =>
    showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialDateRange,
      initialRange: initialRange,
      title: title,
    );

class _DateRangeBottomSheet extends StatefulWidget {
  const _DateRangeBottomSheet({
    this.initialRange,
    required this.title,
  });

  final DateTimeRange? initialRange;
  final String title;

  @override
  State<_DateRangeBottomSheet> createState() => _DateRangeBottomSheetState();
}

class _DateRangeBottomSheetState extends State<_DateRangeBottomSheet> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = widget.initialRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        );
  }

  void _applyPreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime start;
    DateTime end = today;

    switch (preset) {
      case 'Today':
        start = today;
      case 'Yesterday':
        start = today.subtract(const Duration(days: 1));
        end = start;
      case 'Last 7 Days':
        start = today.subtract(const Duration(days: 6));
      case 'Last 30 Days':
        start = today.subtract(const Duration(days: 29));
      case 'This Month':
        start = DateTime(today.year, today.month);
      default:
        return;
    }
    setState(() {
      _range = DateTimeRange(start: start, end: end);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Today',
              'Yesterday',
              'Last 7 Days',
              'Last 30 Days',
              'This Month',
            ]
                .map((p) => ActionChip(
                      label: Text(p, style: const TextStyle(fontSize: 12)),
                      onPressed: () => _applyPreset(p),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),

          // Calendar Range Mode
          Calendar(
            mode: CalendarMode.range,
            initialRange: _range,
            onRangeSelected: (r) => setState(() => _range = r),
          ),
          const SizedBox(height: 20),

          // Footer buttons
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Apply Range',
                  onPressed: _range == null
                      ? null
                      : () => Navigator.of(context).pop(_range),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
