import '../../nash_ui.dart';

/// A single course inside a [LearningTemplate].
class Course {
  const Course({
    required this.title,
    required this.subtitle,
    this.icon = Icons.school_outlined,
    this.gradient,
    this.progress,
    this.lessons,
    this.duration,
    this.rating,
    this.onTap,
    this.onContinue,
  });

  /// Course title.
  final String title;

  /// Course subtitle.
  final String subtitle;

  /// Leading icon.
  final IconData icon;

  /// Icon tile gradient.
  final Gradient? gradient;

  /// Completion progress (0–1).
  final double? progress;

  /// Lessons count text.
  final String? lessons;

  /// Course duration text.
  final String? duration;

  /// Rating (0–5).
  final double? rating;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Continue action.
  final VoidCallback? onContinue;
}

/// A complete learning-app template.
///
/// Shows a greeting header, an "in progress" summary and a list of courses
/// built from [LearningCard].
class LearningTemplate extends StatelessWidget {
  const LearningTemplate({
    super.key,
    required this.courses,
    this.title = 'Learn',
    this.greeting = 'Good day, learner!',
    this.continueTitle = 'Continue learning',
    this.continueSubtitle,
    this.stats = const <Widget>[],
    this.onSearch,
    this.onNotifications,
    this.header,
    this.appBar,
  });

  /// Courses to display.
  final List<Course> courses;

  /// App bar title.
  final String title;

  /// Greeting shown in the header.
  final String greeting;

  /// Title of the "continue" section.
  final String continueTitle;

  /// Subtitle of the "continue" section.
  final String? continueSubtitle;

  /// Extra widgets (e.g. [StatisticCard]s) below the greeting.
  final List<Widget> stats;

  /// Search action.
  final VoidCallback? onSearch;

  /// Notification action.
  final VoidCallback? onNotifications;

  /// Custom header widget (overrides the default greeting block).
  final Widget? header;

  /// Custom app bar.
  final PreferredSizeWidget? appBar;

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
              if (onNotifications != null)
                IconButton(
                  onPressed: onNotifications,
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
                gradient: AppGradients.violet,
                borderRadius: BorderRadius.circular(20),
              ),
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
                    'You are ${_summary(courses)} lessons from a new milestone.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (stats.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                for (int i = 0; i < stats.length; i++) ...<Widget>[
                  Expanded(child: stats[i]),
                  if (i != stats.length - 1)
                    const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          DashboardCard(
            title: continueTitle,
            subtitle: continueSubtitle,
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                for (final Course course in courses)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: LearningCard(
                      title: course.title,
                      subtitle: course.subtitle,
                      icon: course.icon,
                      gradient: course.gradient,
                      progress: course.progress,
                      lessons: course.lessons,
                      duration: course.duration,
                      onTap: course.onTap,
                      onContinue: course.onContinue,
                    ),
                  ),
              ],
            ),
          ),
          if (courses.any((Course c) => c.rating != null)) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Top rated',
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: AppFontWeight.semibold),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final Course course
                in courses.where((Course c) => c.rating != null)) ...<Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: course.gradient ?? AppGradients.brand,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(course.icon, size: 20, color: Colors.white),
                ),
                title: Text(course.title,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: AppFontWeight.medium)),
                subtitle: Text(course.subtitle,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                trailing: Rating(value: course.rating!, size: 16),
                onTap: course.onTap,
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _summary(List<Course> courses) {
    int inProgress = 0;
    int completed = 0;
    for (final Course course in courses) {
      final double p = course.progress ?? 0;
      if (p <= 0) continue;
      if (p >= 1) {
        completed++;
      } else {
        inProgress++;
      }
    }
    return '${inProgress + completed}';
  }
}
