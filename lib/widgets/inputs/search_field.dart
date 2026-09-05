import 'package:flutter/material.dart' hide TextField;

import '../../icons/app_icons.dart';
import 'text_field.dart';

/// A search field with a clear button and submit callback.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.hint = 'Search…',
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.enabled = true,
    this.autofocus = false,
    this.label,
    this.borderRadius,
    this.suffixIcon,
    this.focusNode,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Hint text.
  final String? hint;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is cleared.
  final VoidCallback? onCleared;

  /// Whether editing is allowed.
  final bool enabled;

  /// Whether to focus on mount.
  final bool autofocus;

  /// Optional label.
  final String? label;

  /// Corner radius.
  final double? borderRadius;

  /// Trailing widget (appears after the clear button).
  final Widget? suffixIcon;

  /// External focus node.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        label: label,
        hint: hint,
        icon: AppIcons.search,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        borderRadius: borderRadius ?? 1000,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
      );
}
