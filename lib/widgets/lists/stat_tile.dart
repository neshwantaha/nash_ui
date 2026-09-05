import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../icons/app_icons.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A compact statistics tile with icon, label and value.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon = AppIcons.analytics,
    this.gradient,
    this.delta,
    this.deltaUp = true,
    this.onTap,
    this.color,
    this.valueStyle,
    this.labelStyle,
  });

  /// Statistic label.
  final String label;

  /// Statistic value.
  final String value;

  /// Leading icon.
  final IconData icon;

  /// Icon tile gradient.
  final Gradient? gradient;

  /// Optional delta text (e.g. `+12%`).
  final String? delta;

  /// Whether the delta is an increase.
  final bool deltaUp;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Icon tile color (when no gradient).
  final Color? color;

  /// Value text style.
  final TextStyle? valueStyle;

  /// Label text style.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color accent = color ?? AppColors.forFeedback(AppFeedbackType.info);

    final Widget content = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                      colors: <Color>[accent, accent.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: valueStyle ??
                      textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  label,
                  style: labelStyle ??
                      textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (delta != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  deltaUp
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: deltaUp ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 2),
                Text(
                  delta!,
                  style: textTheme.labelMedium?.copyWith(
                    color: deltaUp ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    return onTap == null
        ? content
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: content,
          );
  }
}
