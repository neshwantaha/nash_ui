import 'package:flutter/material.dart' hide TextButton;

import '../../radius/app_radius.dart';
import 'outline_button.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'text_button.dart';

/// A button that shows a loading spinner while [loading] is true.
///
/// The underlying visual is chosen by [variant].
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.expanded = false,
    this.width,
    this.height = 48,
    this.radius = AppRadius.medium,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback onPressed;

  /// When true a spinner replaces the icon/label.
  final bool loading;

  /// Optional leading icon.
  final IconData? icon;

  /// Visual style.
  final ButtonVariant variant;

  /// When true the button fills the available width.
  final bool expanded;

  /// Fixed width (ignored when [expanded]).
  final double? width;

  /// Button height.
  final double height;

  /// Corner radius.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = PrimaryButton(
          label: label,
          icon: icon,
          onPressed: onPressed,
          loading: loading,
          expanded: expanded,
          width: width,
          height: height,
          radius: radius,
        );
      case ButtonVariant.secondary:
        button = SecondaryButton(
          label: label,
          icon: icon,
          onPressed: onPressed,
          loading: loading,
          expanded: expanded,
          width: width,
          height: height,
          radius: radius,
        );
      case ButtonVariant.outline:
        button = OutlineButton(
          label: label,
          icon: icon,
          onPressed: onPressed,
          loading: loading,
          expanded: expanded,
          width: width,
          height: height,
          radius: radius,
        );
      case ButtonVariant.text:
        button = TextButton(
          label: label,
          icon: icon,
          onPressed: onPressed,
          loading: loading,
          expanded: expanded,
          width: width,
          height: height,
          radius: radius,
        );
    }
    return button;
  }
}

/// Visual variants supported by [LoadingButton].
enum ButtonVariant {
  /// Brand gradient.
  primary,

  /// Secondary container.
  secondary,

  /// Outlined.
  outline,

  /// Text only.
  text,
}
