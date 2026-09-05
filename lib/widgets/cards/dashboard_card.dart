import 'package:flutter/material.dart' hide Card;

import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';
import '../../icons/app_icons.dart';
import '../../spacing/app_spacing.dart';
import 'card.dart';

/// A statistic card with icon, value, label and an optional trend.
class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    this.icon = AppIcons.analytics,
    this.iconColor,
    this.gradient,
    this.trend,
    this.trendUp = true,
    this.subtitle,
    this.onTap,
    this.prefix,
    this.suffix,
  });

  /// Card title.
  final String title;

  /// Main numeric value.
  final String value;

  /// Leading icon.
  final IconData icon;

  /// Icon color.
  final Color? iconColor;

  /// Background gradient for the icon tile.
  final Gradient? gradient;

  /// Optional trend perceTage text (e.g. `+12%`).
  final String? trend;

  /// Whether the trend is positive.
  final bool trendUp;

  /// Optional subtitle.
  final String? subtitle;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Prefix shown before the value.
  final String? prefix;

  /// Suffix shown after the value.
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient ?? AppGradients.brand,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (trendUp ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        trendUp ? AppIcons.trendingUp : AppIcons.trendingDown,
                        size: 14,
                        color: trendUp ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: textTheme.labelSmall?.copyWith(
                          color: trendUp ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style:
                textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            '${prefix ?? ''}$value${suffix ?? ''}',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style:
                  textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// A dashboard card with an optional header and body.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  /// Card body.
  final Widget child;

  /// Optional header title.
  final String? title;

  /// Optional header subtitle.
  final String? subtitle;

  /// Header trailing widget.
  final Widget? trailing;

  /// Header leading icon.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool hasHeader = title != null || trailing != null || icon != null;
    return Card(
      onTap: onTap,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (hasHeader) ...<Widget>[
            Row(
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title != null)
                        Text(
                          title!,
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );
  }
}
