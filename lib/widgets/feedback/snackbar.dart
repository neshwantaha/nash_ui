import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';

/// A themed snackbar with severity colors, icon and action.
class Snackbar {
  const Snackbar._();

  /// Shows an informational snackbar.
  static SnackBar info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      _show(context, message,
          type: AppFeedbackType.info,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows a success snackbar.
  static SnackBar success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      _show(context, message,
          type: AppFeedbackType.success,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows a warning snackbar.
  static SnackBar warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      _show(context, message,
          type: AppFeedbackType.warning,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows an error snackbar.
  static SnackBar error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 5),
  }) =>
      _show(context, message,
          type: AppFeedbackType.error,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  static SnackBar _show(
    BuildContext context,
    String message, {
    required AppFeedbackType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final Color color = AppColors.forFeedback(type);
    final SnackBar snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(_iconFor(type), color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      action: actionLabel == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              onPressed: onAction ?? () {},
              textColor: color,
            ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return snackBar;
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
