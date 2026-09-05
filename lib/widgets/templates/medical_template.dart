import '../../nash_ui.dart';

/// A medical appointment.
class Appointment {
  const Appointment({
    required this.title,
    required this.subtitle,
    required this.time,
    this.doctorName,
    this.avatarUrl,
    this.status,
    this.statusColor,
    this.onTap,
  });

  /// Appointment title (e.g. "Cardiology check-up").
  final String title;

  /// Subtitle (e.g. department / doctor).
  final String subtitle;

  /// Time label (e.g. "Today, 10:30 AM").
  final String time;

  /// Doctor name.
  final String? doctorName;

  /// Doctor avatar URL.
  final String? avatarUrl;

  /// Status label.
  final String? status;

  /// Status color.
  final Color? statusColor;

  /// Tap callback.
  final VoidCallback? onTap;
}

/// A complete medical-app template.
///
/// Shows a greeting header with a wellness ring, upcoming appointments and a
/// list of doctors.
class MedicalTemplate extends StatelessWidget {
  const MedicalTemplate({
    super.key,
    required this.appointments,
    this.title = 'Health',
    this.greeting = 'Good morning, Sarah',
    this.subtitle = 'You look great today',
    this.healthValue = '82',
    this.healthLabel = 'Wellness score',
    this.onSearch,
    this.onNotification,
    this.onAddAppointment,
    this.onCall,
    this.doctors = const <String>[],
    this.header,
    this.appBar,
    this.doctorTitle = 'Your doctors',
  });

  /// Appointments to show.
  final List<Appointment> appointments;

  /// App bar title.
  final String title;

  /// Greeting text.
  final String greeting;

  /// Greeting subtitle.
  final String subtitle;

  /// Wellness score value.
  final String healthValue;

  /// Wellness score label.
  final String healthLabel;

  /// Search action.
  final VoidCallback? onSearch;

  /// Notification action.
  final VoidCallback? onNotification;

  /// Add-appointment action.
  final VoidCallback? onAddAppointment;

  /// Call action.
  final VoidCallback? onCall;

  /// Doctor names for the quick-access row.
  final List<String> doctors;

  /// Custom header widget.
  final Widget? header;

  /// Custom app bar.
  final PreferredSizeWidget? appBar;

  /// Doctors section title.
  final String doctorTitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: title,
            actions: <Widget>[
              if (onSearch != null)
                IconButton(
                  onPressed: onSearch,
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search',
                ),
              if (onNotification != null)
                IconButton(
                  onPressed: onNotification,
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: 'Notifications',
                ),
            ],
          ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          if (header != null)
            header!
          else ...<Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppGradients.success,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          greeting,
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        if (onAddAppointment != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.md),
                          FilledButton.tonalIcon(
                            onPressed: onAddAppointment,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.success,
                            ),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: const Text('Book appointment'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _WellnessRing(value: healthValue, label: healthLabel),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (doctors.isNotEmpty) ...<Widget>[
            Text(
              doctorTitle,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: AppFontWeight.semibold),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (final String doctor in doctors) ...<Widget>[
                    Column(
                      children: <Widget>[
                        Avatar(initials: doctor, radius: 26),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 72,
                          child: Text(
                            doctor,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    if (doctor != doctors.last)
                      const SizedBox(width: AppSpacing.md),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          DashboardCard(
            title: 'Upcoming appointments',
            subtitle: appointments.isEmpty ? 'Nothing scheduled' : 'This week',
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                if (appointments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'No upcoming appointments.',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  )
                else
                  for (final Appointment appointment in appointments)
                    MedicalCard(
                      title: appointment.title,
                      subtitle: appointment.subtitle,
                      time: appointment.time,
                      icon: appointment.doctorName == null
                          ? AppIcons.medical
                          : Icons.local_hospital_outlined,
                      status: appointment.status,
                      statusColor: appointment.statusColor,
                      onTap: appointment.onTap,
                      onDetails: appointment.onTap,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WellnessRing extends StatelessWidget {
  const _WellnessRing({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CircularProgressIndicator(
            value: (double.tryParse(value) ?? 0) / 100,
            strokeWidth: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  value,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 9,
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
