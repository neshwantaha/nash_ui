import '../../nash_ui.dart';

/// A single row for the [AdminTemplate] table.
class AdminRow {
  const AdminRow({
    required this.cells,
    this.onTap,
  });

  /// Cell values (String or Widget).
  final List<Widget> cells;

  /// Row tap callback.
  final VoidCallback? onTap;
}

/// A complete admin-dashboard template.
///
/// Shows a stat-card grid, a line chart and a data table. On wide screens the
/// content is laid out side-by-side automatically.
class AdminTemplate extends StatelessWidget {
  const AdminTemplate({
    super.key,
    required this.stats,
    required this.columns,
    required this.rows,
    this.title = 'Admin',
    this.greeting = 'Overview',
    this.chartTitle = 'Revenue',
    this.chartLabels = const <String>[],
    this.chartData = const <double>[],
    this.tableTitle = 'Recent orders',
    this.tableSubtitle,
    this.onAdd,
    this.onExport,
    this.onRefresh,
    this.appBar,
  });

  /// Stat widgets (e.g. [StatisticCard]s).
  final List<Widget> stats;

  /// Data table column headers.
  final List<String> columns;

  /// Data table rows.
  final List<AdminRow> rows;

  /// App bar title.
  final String title;

  /// Greeting shown under the app bar.
  final String greeting;

  /// Chart card title.
  final String chartTitle;

  /// Chart x labels.
  final List<String> chartLabels;

  /// Chart data.
  final List<double> chartData;

  /// Table card title.
  final String tableTitle;

  /// Table card subtitle.
  final String? tableSubtitle;

  /// Add action.
  final VoidCallback? onAdd;

  /// Export action.
  final VoidCallback? onExport;

  /// Refresh action.
  final VoidCallback? onRefresh;

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
              if (onAdd != null)
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded),
                  tooltip: 'Add',
                ),
            ],
          ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          Text(
            greeting,
            style: textTheme.headlineSmall
                ?.copyWith(fontWeight: AppFontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 700;
              if (!wide) {
                return Column(
                  children: <Widget>[
                    for (int i = 0; i < stats.length; i++) ...<Widget>[
                      stats[i],
                      if (i != stats.length - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  for (int i = 0; i < stats.length; i++) ...<Widget>[
                    Expanded(child: stats[i]),
                    if (i != stats.length - 1)
                      const SizedBox(width: AppSpacing.md),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget chart = DashboardCard(
                title: chartTitle,
                icon: Icons.trending_up_rounded,
                child: chartData.length < 2
                    ? Text(
                        'Add data to see the chart.',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      )
                    : LineChart.fromData(
                        data: chartData, labels: chartLabels, height: 220),
              );
              final Widget table = DashboardCard(
                title: tableTitle,
                subtitle: tableSubtitle,
                padding: EdgeInsets.zero,
                child: DataTable(
                  columns: columns,
                  rows: <List<DataCell>>[
                    for (final AdminRow row in rows)
                      <DataCell>[
                        for (final Widget cell in row.cells) DataCell(cell),
                      ],
                  ],
                ),
              );

              if (constraints.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(flex: 2, child: chart),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(flex: 3, child: table),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  chart,
                  const SizedBox(height: AppSpacing.md),
                  table,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
