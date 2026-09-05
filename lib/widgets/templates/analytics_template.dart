import '../../nash_ui.dart';

/// A single KPIs row inside a [AnalyticsTemplate].
class AnalyticsKpi {
  const AnalyticsKpi({
    required this.label,
    required this.value,
    this.delta,
    this.deltaUp = true,
    this.icon = Icons.insights_rounded,
    this.color,
    this.gradient,
  });

  /// KPI label.
  final String label;

  /// KPI value.
  final String value;

  /// Trend text (e.g. `+12%`).
  final String? delta;

  /// Whether the trend is positive.
  final bool deltaUp;

  /// Leading icon.
  final IconData icon;

  /// Icon color.
  final Color? color;

  /// Icon gradient.
  final Gradient? gradient;
}

/// A complete analytics dashboard template.
///
/// Combines KPI tiles, sparklines, a line chart and a pie chart. The layout
/// reflows automatically on wide screens.
class AnalyticsTemplate extends StatelessWidget {
  const AnalyticsTemplate({
    super.key,
    required this.kpis,
    this.title = 'Analytics',
    this.rangeLabel = 'Last 30 days',
    this.onRangeTap,
    this.onExport,
    this.onRefresh,
    this.lineTitle = 'Visitors',
    this.lineData = const <double>[],
    this.lineLabels = const <String>[],
    this.sparkData = const <double>[],
    this.pieSegments = const <PieSegment>[],
    this.pieTitle = 'Traffic sources',
    this.pieCenterLabel,
    this.pieCenterSubLabel,
    this.appBar,
  });

  /// KPI tiles.
  final List<AnalyticsKpi> kpis;

  /// App bar title.
  final String title;

  /// Range label shown in the app bar (e.g. "Last 30 days").
  final String rangeLabel;

  /// Range selector callback.
  final VoidCallback? onRangeTap;

  /// Export callback.
  final VoidCallback? onExport;

  /// Refresh callback.
  final VoidCallback? onRefresh;

  /// Line chart card title.
  final String lineTitle;

  /// Line chart data.
  final List<double> lineData;

  /// Line chart x labels.
  final List<String> lineLabels;

  /// Sparkline data.
  final List<double> sparkData;

  /// Pie chart segments.
  final List<PieSegment> pieSegments;

  /// Pie chart card title.
  final String pieTitle;

  /// Pie center label.
  final String? pieCenterLabel;

  /// Pie center sub label.
  final String? pieCenterSubLabel;

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
              if (onRefresh != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                ),
              if (onExport != null)
                IconButton(
                  onPressed: onExport,
                  icon: const Icon(Icons.download_rounded),
                  tooltip: 'Export',
                ),
            ],
          ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: ActionChip(
              avatar: const Icon(Icons.calendar_today_rounded, size: 16),
              label: Text(rangeLabel),
              onPressed: onRangeTap,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 700;
              if (!wide) {
                return Column(
                  children: <Widget>[
                    for (int i = 0; i < kpis.length; i++) ...<Widget>[
                      _KpiTile(kpi: kpis[i]),
                      if (i != kpis.length - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  for (int i = 0; i < kpis.length; i++) ...<Widget>[
                    Expanded(child: _KpiTile(kpi: kpis[i])),
                    if (i != kpis.length - 1)
                      const SizedBox(width: AppSpacing.md),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          DashboardCard(
            title: lineTitle,
            icon: Icons.show_chart_rounded,
            child: lineData.length < 2
                ? Text(
                    'Add data to see the chart.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  )
                : LineChart.fromData(
                    data: lineData, labels: lineLabels, height: 220),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget sparkline = DashboardCard(
                title: 'Trend',
                icon: Icons.bolt_rounded,
                child: sparkData.length < 2
                    ? Text(
                        'Add data to see the trend.',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      )
                    : Sparkline(data: sparkData, height: 64),
              );
              final Widget pie = DashboardCard(
                title: pieTitle,
                icon: Icons.pie_chart_outline_rounded,
                child: pieSegments.isEmpty
                    ? Text(
                        'Add segments to see the chart.',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      )
                    : PieChart(
                        segments: pieSegments,
                        centerLabel: pieCenterLabel,
                        centerSubLabel: pieCenterSubLabel,
                      ),
              );
              if (constraints.maxWidth >= 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: sparkline),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: pie),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  sparkline,
                  const SizedBox(height: AppSpacing.md),
                  pie,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.kpi});

  final AnalyticsKpi kpi;

  @override
  Widget build(BuildContext context) {
    final Color accent = kpi.color ?? AppColors.info;
    return StatTile(
      label: kpi.label,
      value: kpi.value,
      icon: kpi.icon,
      delta: kpi.delta,
      deltaUp: kpi.deltaUp,
      color: kpi.color,
      gradient: kpi.gradient,
      valueStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: AppFontWeight.bold,
            color: accent,
          ),
    );
  }
}
