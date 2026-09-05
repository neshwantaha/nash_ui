import 'package:flutter/material.dart' hide Banner;

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A backwards-compatible alias for [Banner].
typedef NashBanner = Banner;

/// A dismissible banner shown at the top of a page.
class Banner extends StatelessWidget {
  const Banner({
    super.key,
    required this.message,
    this.type = AppFeedbackType.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.padding = const EdgeInsets.all(12),
  });

  /// Banner message.
  final String message;

  /// Banner severity.
  final AppFeedbackType type;

  /// Custom leading icon.
  final IconData? icon;

  /// Optional action label.
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Dismiss callback.
  final VoidCallback? onDismiss;

  /// Inner padding.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Color color = AppColors.forFeedback(type);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon ?? _iconFor(type),
            size: 20,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ),
          if (actionLabel != null) ...<Widget>[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          if (onDismiss != null) ...<Widget>[
            const SizedBox(width: 4),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onDismiss,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child:
                    Icon(Icons.close, size: 16, color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static IconData _iconFor(AppFeedbackType type) {
    switch (type) {
      case AppFeedbackType.info:
        return Icons.info_outline_rounded;
      case AppFeedbackType.success:
        return Icons.check_circle_outline_rounded;
      case AppFeedbackType.warning:
        return Icons.warning_amber_rounded;
      case AppFeedbackType.error:
        return Icons.error_outline_rounded;
    }
  }
}

/// An animated banner widget that appears/disappears with a transition.
class AnimatedBanner extends StatefulWidget {
  const AnimatedBanner({
    super.key,
    required this.message,
    this.type = AppFeedbackType.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.visible = true,
    this.onDismiss,
  });

  /// Banner message.
  final String message;

  /// Banner severity.
  final AppFeedbackType type;

  /// Custom leading icon.
  final IconData? icon;

  /// Optional action label.
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Whether the banner is visible.
  final bool visible;

  /// Dismiss callback.
  final VoidCallback? onDismiss;

  @override
  State<AnimatedBanner> createState() => _NAnimatedBannerState();
}

class _NAnimatedBannerState extends State<AnimatedBanner> {
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: AppDuration.fast,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) =>
            SizeTransition(
          sizeFactor: animation,
          // ignore: deprecated_member_use
          axisAlignment: -1,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: widget.visible
            ? Banner(
                key: ValueKey<String>(widget.message),
                message: widget.message,
                type: widget.type,
                icon: widget.icon,
                actionLabel: widget.actionLabel,
                onAction: widget.onAction,
                onDismiss: widget.onDismiss,
              )
            : const SizedBox.shrink(),
      );
}
