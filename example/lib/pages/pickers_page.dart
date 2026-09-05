import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class PickersPage extends StatefulWidget {
  const PickersPage({super.key});

  @override
  State<PickersPage> createState() => _PickersPageState();
}

class _PickersPageState extends State<PickersPage> {
  TimeOfDay? _selectedTime;
  DateTimeRange? _selectedDateRange;
  Duration? _selectedDuration;
  TimeRange? _selectedTimeRange;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Pickers',
      icon: Icons.schedule_rounded,
      sections: [
        // ── Time Picker ─────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Time Picker',
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pick Time',
                    icon: Icons.access_time_rounded,
                    onPressed: () async {
                      final time = await showStyledTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null && mounted) {
                        setState(() => _selectedTime = time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _selectedTime != null
                    ? 'Selected: ${_selectedTime!.format(context)}'
                    : 'No time selected',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        // ── Date Range Picker ───────────────────────────────────────────
        ShowcaseSection(
          title: 'Date Range Picker',
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pick Date Range',
                    icon: Icons.date_range_rounded,
                    onPressed: () async {
                      final range = await showDateRangeDialog(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2026),
                      );
                      if (range != null && mounted) {
                        setState(() => _selectedDateRange = range);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _selectedDateRange != null
                    ? 'Range: ${_selectedDateRange!.start.month}/${_selectedDateRange!.start.day}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.month}/${_selectedDateRange!.end.day}/${_selectedDateRange!.end.year}'
                    : 'No range selected',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        // ── Duration Picker ─────────────────────────────────────────────
        ShowcaseSection(
          title: 'Duration Picker',
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pick Duration',
                    icon: Icons.timer_rounded,
                    onPressed: () async {
                      final duration = await showDurationPicker(
                        context: context,
                        initialDuration: const Duration(hours: 1),
                      );
                      if (duration != null && mounted) {
                        setState(() => _selectedDuration = duration);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _selectedDuration != null
                    ? 'Duration: ${_selectedDuration!.inHours}h ${_selectedDuration!.inMinutes.remainder(60)}m'
                    : 'No duration selected',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        // ── Time Range Picker ───────────────────────────────────────────
        ShowcaseSection(
          title: 'Time Range Picker',
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pick Time Range',
                    icon: Icons.timelapse_rounded,
                    onPressed: () async {
                      final range = await showTimeRangePicker(
                        context: context,
                      );
                      if (range != null && mounted) {
                        setState(() => _selectedTimeRange = range);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _selectedTimeRange != null
                    ? 'Range: ${_selectedTimeRange!.start.format(context)} - ${_selectedTimeRange!.end.format(context)}'
                    : 'No time range selected',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
