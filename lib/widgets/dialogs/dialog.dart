import 'package:flutter/material.dart' hide Dialog, showDialog;
import 'package:flutter/material.dart' as fl;

import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';

/// A themed dialog with gradient header and rounded corners.
///
/// A backwards-compatible alias for [Dialog].
typedef NashDialog = Dialog;

/// A themed dialog with gradient header and rounded corners.
class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.gradient,
    this.showHeader = true,
    this.padding = const EdgeInsets.all(24),
    this.titleStyle,
  });

  /// Dialog title.
  final String? title;

  /// Dialog subtitle.
  final String? subtitle;

  /// Dialog body content.
  final Widget? content;

  /// Action buttons row.
  final List<Widget>? actions;

  /// Header icon.
  final IconData? icon;

  /// Header icon color.
  final Color? iconColor;

  /// Header gradient.
  final Gradient? gradient;

  /// Whether to show the gradient header.
  final bool showHeader;

  /// Dialog padding.
  final EdgeInsets padding;

  /// Title style.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<Color> gradientColors =
        gradient?.colors ?? AppGradients.brand.colors;
    final AlignmentGeometry? gradientBegin =
        gradient is LinearGradient ? (gradient as LinearGradient).begin : null;
    final AlignmentGeometry? gradientEnd =
        gradient is LinearGradient ? (gradient as LinearGradient).end : null;

    final Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (showHeader && (title != null || icon != null))
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: gradientBegin ?? Alignment.topLeft,
                end: gradientEnd ?? Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: iconColor ?? Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (title != null)
                  Text(
                    title!,
                    style: titleStyle ??
                        textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        Flexible(
          child: SingleChildScrollView(
            padding: padding,
            child: content ?? const SizedBox.shrink(),
          ),
        ),
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: actions!,
            ),
          ),
      ],
    );

    return fl.Dialog(
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: body,
    );
  }
}

/// Shows a themed dialog and returns the dialog widget.
Future<T?> showDialog<T>({
  required BuildContext context,
  Widget? child,
  WidgetBuilder? builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  assert(child != null || builder != null,
      'Either child or builder must be provided.');
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondary, Widget child) =>
        FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: child,
      ),
    ),
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondary) =>
        child ?? builder!(context),
  );
}

/// Shows an alert dialog and returns the pressed action.
Future<T?> showNAlertDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  String? confirmLabel = 'OK',
  String? cancelLabel,
  T? confirmValue,
  T? cancelValue,
  VoidCallback? onConfirm,
  Color? confirmColor,
  AppFeedbackType type = AppFeedbackType.info,
  bool barrierDismissible = true,
}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      child: Dialog(
        title: title,
        subtitle: message,
        icon: _iconFor(type),
        actions: <Widget>[
          if (cancelLabel != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(cancelValue),
              child: Text(cancelLabel),
            ),
          FilledButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(confirmValue);
            },
            style: FilledButton.styleFrom(
              backgroundColor: confirmColor ?? AppColors.forFeedback(type),
            ),
            child: Text(confirmLabel ?? 'OK'),
          ),
        ],
      ),
    );

/// Shows a confirmation dialog.
Future<bool?> showNConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  VoidCallback? onConfirm,
  Color? confirmColor,
  AppFeedbackType type = AppFeedbackType.info,
}) =>
    showNAlertDialog<bool>(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmValue: true,
      cancelValue: false,
      onConfirm: onConfirm,
      confirmColor: confirmColor,
      type: type,
    );

/// Shows an input dialog returning the entered text.
Future<String?> showNInputDialog({
  required BuildContext context,
  required String title,
  String? message,
  String? initialText,
  String confirmLabel = 'Save',
  String cancelLabel = 'Cancel',
  String? hintText,
  TextInputType? keyboardType,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  final TextEditingController controller =
      TextEditingController(text: initialText);
  return showDialog<String>(
    context: context,
    child: Dialog(
      title: title,
      subtitle: message,
      content: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.small)),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            if (validator != null) {
              final String? error = validator(controller.text);
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
                return;
              }
            }
            Navigator.of(context).pop(controller.text);
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

IconData _iconFor(AppFeedbackType type) {
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
