import 'package:flutter/material.dart' hide TextField;

import '../../icons/app_icons.dart';
import '../../utils/date_utils.dart';
import 'date_picker.dart' as dp;
import 'text_field.dart';

/// Style of date picker dialog / sheet to present.
enum DateFieldPickerStyle {
  /// Nash UI styled modal bottom sheet calendar.
  nash,

  /// iOS Cupertino spinner wheel sheet.
  wheel,

  /// Platform default (Material showDatePicker).
  platform,
}

/// A date picker field that opens a styled date picker.
class DateField extends StatefulWidget {
  const DateField({
    super.key,
    this.label = 'Date',
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.icon,
    this.mode = DateMode.date,
    this.pickerStyle = DateFieldPickerStyle.nash,
    this.locale,
  });

  /// Label text.
  final String label;

  /// Hint text.
  final String? hint;

  /// Initially selected date.
  final DateTime? initialDate;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Validator receiving the selected date.
  final String? Function(DateTime?)? validator;

  /// Called with the selected date.
  final ValueChanged<DateTime>? onChanged;

  /// Whether the field is interactive.
  final bool enabled;

  /// Leading icon.
  final IconData? icon;

  /// Picker mode.
  final DateMode mode;

  /// Presentation style of the picker modal.
  final DateFieldPickerStyle pickerStyle;

  /// Picker locale (e.g. `en` or `ar`).
  final String? locale;

  @override
  State<DateField> createState() => _DateFieldState();
}

/// Picker variants for [DateField].
enum DateMode {
  /// Date only.
  date,

  /// Date and time.
  dateTime,
}

class _DateFieldState extends State<DateField> {
  late final TextEditingController _controller;
  late DateTime? _selected;
  FormFieldState<DateTime>? _fieldState;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _controller = TextEditingController(
      text: _selected == null ? '' : _format(_selected!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTime date) => AppDateUtils.format(
        date,
        widget.mode == DateMode.date ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm',
      );

  Future<void> _pick() async {
    DateTime? picked;

    if (widget.pickerStyle == DateFieldPickerStyle.nash &&
        widget.mode == DateMode.date) {
      picked = await dp.showDatePicker(
        context,
        initialDate: _selected ?? DateTime.now(),
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        title: widget.label,
        locale: widget.locale,
      );
    } else if (widget.pickerStyle == DateFieldPickerStyle.wheel) {
      DateTime temp = _selected ?? DateTime.now();
      picked = await showModalBottomSheet<DateTime>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131F) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(temp),
                      child: const Text('Done',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                dp.WheelDatePicker(
                  initialDate: temp,
                  minDate: widget.firstDate,
                  maxDate: widget.lastDate,
                  locale: widget.locale,
                  onDateChanged: (DateTime d) => temp = d,
                ),
              ],
            ),
          );
        },
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: _selected ?? DateTime.now(),
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2100),
        helpText: widget.label,
        locale: widget.locale == null ? null : Locale(widget.locale!),
      );
    }

    if (picked == null) return;

    DateTime result = picked;
    if (widget.mode == DateMode.dateTime) {
      if (!mounted) return;
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(picked),
      );
      if (time == null) return;
      result = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
    }
    if (!mounted) return;
    setState(() {
      _selected = result;
      _controller.text = _format(result);
    });
    _fieldState?.didChange(result);
    _fieldState?.validate();
    widget.onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) => FormField<DateTime>(
        initialValue: _selected,
        validator: widget.validator,
        builder: (FormFieldState<DateTime> field) {
          _fieldState = field;
          return TextField(
            controller: _controller,
            label: widget.label,
            hint: widget.hint,
            icon: widget.icon ?? AppIcons.calendar,
            enabled: widget.enabled,
            readOnly: true,
            suffixIcon: const Icon(Icons.expand_more, size: 20),
            errorText: field.errorText,
            onTap: widget.enabled ? _pick : null,
          );
        },
      );
}
