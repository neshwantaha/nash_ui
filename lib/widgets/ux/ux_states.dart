import 'package:flutter/material.dart';

import '../../spacing/app_spacing.dart';
import '../../typography/font_weight.dart';
import '../buttons/primary_button.dart';

/// A friendly empty-state placeholder with icon, title, message and action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.iconColor,
    this.background,
  });

  /// Leading icon.
  final IconData? icon;

  /// Main heading.
  final String title;

  /// Supporting description.
  final String? message;

  /// Action button label.
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Whether to render in a compact (inline) layout.
  final bool compact;

  /// Icon tint.
  final Color? iconColor;

  /// Icon badge background.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color tint = iconColor ?? scheme.primary;

    final Widget icoBadge = Container(
      width: compact ? 56 : 80,
      height: compact ? 56 : 80,
      decoration: BoxDecoration(
        color: background ?? tint.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.inbox_outlined,
        size: compact ? 28 : 40,
        color: tint,
      ),
    );

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icoBadge,
        SizedBox(height: compact ? AppSpacing.sm : AppSpacing.lg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: (compact ? textTheme.titleMedium : textTheme.titleLarge)
              ?.copyWith(
            fontWeight: AppFontWeight.semibold,
            color: scheme.onSurface,
          ),
        ),
        if (message != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        if (actionLabel != null && onAction != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    );

    if (compact) return content;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: content,
      ),
    );
  }
}

/// A full error state with icon, title, message and a retry action.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.retryLabel = 'Try again',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Heading text.
  final String title;

  /// Optional details.
  final String? message;

  /// Retry button label.
  final String retryLabel;

  /// Retry callback.
  final VoidCallback? onRetry;

  /// Error icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: scheme.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}

/// A "no internet" state shown when the device is offline.
class OfflineState extends StatelessWidget {
  const OfflineState({
    super.key,
    this.title = 'You are offline',
    this.message = 'Check your internet connection and try again.',
    this.retryLabel = 'Retry',
    this.onRetry,
  });

  /// Heading text.
  final String title;

  /// Supporting message.
  final String? message;

  /// Retry button label.
  final String retryLabel;

  /// Retry callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: 44,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: AppFontWeight.semibold,
              color: scheme.onSurface,
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (onRetry != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: retryLabel, onPressed: onRetry),
          ],
        ],
      ),
    );
  }
}

/// A success state screen (e.g. after form submission).
class SuccessState extends StatelessWidget {
  const SuccessState({
    super.key,
    this.title = 'Success!',
    this.message,
    this.actionLabel,
    this.onAction,
  });

  /// Heading text.
  final String title;

  /// Supporting message.
  final String? message;

  /// Action button label.
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 44, color: scheme.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// A permission-request state with icon, explanation and actions.
class PermissionState extends StatelessWidget {
  const PermissionState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.shield_outlined,
    this.allowLabel = 'Allow',
    this.denyLabel = 'Not now',
    this.onAllow,
    this.onDeny,
  });

  /// Heading text.
  final String title;

  /// Explanation text.
  final String? message;

  /// Permission icon.
  final IconData icon;

  /// Allow button label.
  final String allowLabel;

  /// Deny button label.
  final String denyLabel;

  /// Allow callback.
  final VoidCallback? onAllow;

  /// Deny callback.
  final VoidCallback? onDeny;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: scheme.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onAllow != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: allowLabel, onPressed: onAllow),
            ],
            if (onDeny != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: onDeny,
                child: Text(denyLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A maintenance / under-construction state.
class MaintenanceState extends StatelessWidget {
  const MaintenanceState({
    super.key,
    this.title = 'Under maintenance',
    this.message = 'We are working on things. Please check back soon.',
    this.estimatedTime,
  });

  /// Heading text.
  final String title;

  /// Supporting message.
  final String? message;

  /// Optional estimated completion time.
  final String? estimatedTime;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: scheme.tertiary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_rounded,
                size: 44,
                color: scheme.tertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (estimatedTime != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Chip(label: Text('Back at $estimatedTime')),
            ],
          ],
        ),
      ),
    );
  }
}

/// An "update required" state prompting the user to update the app.
class UpdateState extends StatelessWidget {
  const UpdateState({
    super.key,
    this.title = 'Update required',
    this.message =
        'A newer version of the app is available. Update to continue.',
    this.updateLabel = 'Update now',
    this.laterLabel = 'Later',
    this.onUpdate,
    this.onLater,
  });

  /// Heading text.
  final String title;

  /// Supporting message.
  final String? message;

  /// Update button label.
  final String updateLabel;

  /// "Later" button label.
  final String laterLabel;

  /// Update callback.
  final VoidCallback? onUpdate;

  /// "Later" callback.
  final VoidCallback? onLater;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.system_update_alt_rounded,
                size: 44,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onUpdate != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: updateLabel, onPressed: onUpdate),
            ],
            if (onLater != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: onLater,
                child: Text(laterLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A 404 / page-not-found state.
class NotFoundState extends StatelessWidget {
  const NotFoundState({
    super.key,
    this.title = 'Page not found',
    this.message = 'The page you are looking for does not exist.',
    this.actionLabel = 'Go back home',
    this.onAction,
  });

  /// Heading text.
  final String title;

  /// Supporting message.
  final String? message;

  /// Action button label.
  final String actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '404',
              style: textTheme.displayMedium?.copyWith(
                fontWeight: AppFontWeight.black,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.semibold,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: actionLabel, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
