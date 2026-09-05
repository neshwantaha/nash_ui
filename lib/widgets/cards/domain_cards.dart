import 'package:flutter/material.dart' hide Card;

import '../../gradients/brand_gradients.dart';
import '../../icons/app_icons.dart';
import '../../spacing/app_spacing.dart';
import 'card.dart';

/// A medical record card with specialty, status and actions.
class MedicalCard extends StatelessWidget {
  const MedicalCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AppIcons.medical,
    this.gradient,
    this.status,
    this.statusColor,
    this.onTap,
    this.onDetails,
    this.time,
  });

  /// Card title (e.g. patient / department).
  final String title;

  /// Card subtitle.
  final String subtitle;

  /// Leading icon.
  final IconData icon;

  /// Icon tile gradient.
  final Gradient? gradient;

  /// Optional status label.
  final String? status;

  /// Status color.
  final Color? statusColor;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Details action.
  final VoidCallback? onDetails;

  /// Time text.
  final String? time;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolvedStatus = statusColor ?? scheme.primary;
    return Card(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: gradient ?? AppGradients.info,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                if (time != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    time!,
                    style: textTheme.labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          if (status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: resolvedStatus.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                status!,
                style: textTheme.labelSmall?.copyWith(
                  color: resolvedStatus,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (onDetails != null) ...<Widget>[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onDetails,
              icon: const Icon(Icons.chevron_right, size: 22),
            ),
          ],
        ],
      ),
    );
  }
}

/// A learning course card with progress.
class LearningCard extends StatelessWidget {
  const LearningCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AppIcons.education,
    this.gradient,
    this.progress,
    this.lessons,
    this.duration,
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

  /// Tap callback.
  final VoidCallback? onTap;

  /// Continue action.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double p = (progress ?? 0).clamp(0, 1);
    return Card(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: gradient ?? AppGradients.violet,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (onContinue != null)
                IconButton(
                  onPressed: onContinue,
                  icon: const Icon(Icons.play_circle_outline, size: 24),
                  tooltip: 'Continue',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: p,
                    minHeight: 6,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${(p * 100).round()}%',
                style:
                    textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              if (lessons != null) ...<Widget>[
                const Icon(AppIcons.list, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(lessons!,
                    style: textTheme.labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
              if (lessons != null && duration != null)
                const SizedBox(width: 12),
              if (duration != null) ...<Widget>[
                const Icon(AppIcons.clock, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(duration!,
                    style: textTheme.labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
