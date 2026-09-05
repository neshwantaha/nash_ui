import '../../nash_ui.dart';

/// A single financial transaction.
class Transaction {
  const Transaction({
    required this.title,
    required this.amount,
    required this.time,
    this.icon = Icons.receipt_long_outlined,
    this.isCredit = false,
    this.category,
    this.color,
  });

  /// Transaction title / merchant.
  final String title;

  /// Signed amount as a string (e.g. `-$42.00`).
  final String amount;

  /// Time label.
  final String time;

  /// Leading icon.
  final IconData icon;

  /// Whether this is money received (credit).
  final bool isCredit;

  /// Optional category label.
  final String? category;

  /// Icon tile color.
  final Color? color;
}

/// A complete finance dashboard template.
///
/// Shows a balance hero card, quick stats and a transaction feed. Fully
/// responsive — the hero and stats reflow on wide screens.
class FinanceTemplate extends StatelessWidget {
  const FinanceTemplate({
    super.key,
    required this.balance,
    required this.transactions,
    this.title = 'Finance',
    this.accountLabel = 'Total balance',
    this.balanceSubtitle,
    this.stats = const <Widget>[],
    this.onAdd,
    this.onScan,
    this.onNotification,
    this.headerActions,
    this.appBar,
    this.currencySymbol = r'$',
  });

  /// Balance value as a string.
  final String balance;

  /// App bar title.
  final String title;

  /// Account label above the balance.
  final String accountLabel;

  /// Subtitle below the balance.
  final String? balanceSubtitle;

  /// Transactions to show.
  final List<Transaction> transactions;

  /// Extra stat widgets shown under the hero.
  final List<Widget> stats;

  /// Quick action callback (e.g. add money).
  final VoidCallback? onAdd;

  /// Scan / pay action callback.
  final VoidCallback? onScan;

  /// Notification action callback.
  final VoidCallback? onNotification;

  /// Custom header actions.
  final List<Widget>? headerActions;

  /// Custom app bar.
  final PreferredSizeWidget? appBar;

  /// Currency symbol.
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: title,
            actions: headerActions ??
                <Widget>[
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppGradients.brand,
              borderRadius: BorderRadius.circular(24),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        accountLabel,
                        style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ),
                    if (onAdd != null)
                      IconButton(
                        onPressed: onAdd,
                        icon:
                            const Icon(Icons.add_rounded, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                        ),
                        tooltip: 'Add money',
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$currencySymbol$balance',
                  style: textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                if (balanceSubtitle != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.trending_up_rounded,
                          size: 16, color: Color(0xFF86EFAC)),
                      const SizedBox(width: 4),
                      Text(
                        balanceSubtitle!,
                        style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ],
                if (onScan != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.tonalIcon(
                    onPressed: onScan,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: scheme.primary,
                    ),
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                    label: const Text('Scan & pay'),
                  ),
                ],
              ],
            ),
          ),
          if (stats.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final int columns =
                    constraints.maxWidth >= 600 ? stats.length : 1;
                if (columns > 1) {
                  return Row(
                    children: <Widget>[
                      for (int i = 0; i < stats.length; i++) ...<Widget>[
                        Expanded(child: stats[i]),
                        if (i != stats.length - 1)
                          const SizedBox(width: AppSpacing.md),
                      ],
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    for (int i = 0; i < stats.length; i++) ...<Widget>[
                      stats[i],
                      if (i != stats.length - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          DashboardCard(
            title: 'Recent transactions',
            subtitle: 'Last 30 days',
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                for (final Transaction transaction in transactions)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (transaction.color ??
                                (transaction.isCredit
                                    ? AppColors.success
                                    : AppColors.error))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        transaction.icon,
                        size: 20,
                        color: transaction.color ??
                            (transaction.isCredit
                                ? AppColors.success
                                : AppColors.error),
                      ),
                    ),
                    title: Text(transaction.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: transaction.category == null
                        ? null
                        : Text(transaction.category!,
                            style: textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          transaction.amount,
                          style: textTheme.titleSmall?.copyWith(
                            color: transaction.isCredit
                                ? AppColors.success
                                : scheme.onSurface,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        Text(
                          transaction.time,
                          style: textTheme.labelSmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    shape: const RoundedRectangleBorder(),
                    showDivider: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
