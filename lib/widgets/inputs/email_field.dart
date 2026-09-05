import 'package:flutter/material.dart' hide TextField;

import '../../icons/app_icons.dart';
import '../../utils/validators.dart';
import 'text_field.dart';

/// An email input field with built-in validation and autofill.
class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    this.controller,
    this.label = 'Email',
    this.hint = 'name@example.com',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autovalidateMode,
    this.initialValue,
    this.icon,
    this.textInputAction,
    this.onFieldSaved,
    this.required = false,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Label text.
  final String label;

  /// Hint text.
  final String? hint;

  /// Additional validator combined with the email check.
  final String? Function(String?)? validator;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Whether editing is allowed.
  final bool enabled;

  /// Autovalidate mode.
  final AutovalidateMode? autovalidateMode;

  /// Initial value.
  final String? initialValue;

  /// Leading icon.
  final IconData? icon;

  /// Keyboard action.
  final TextInputAction? textInputAction;

  /// Called when the form saves the value.
  final ValueChanged<String?>? onFieldSaved;

  /// When true an empty value is reported as invalid.
  final bool required;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        label: label,
        hint: hint,
        icon: icon ?? AppIcons.email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: textInputAction ?? TextInputAction.next,
        autofillHints: const <String>[AutofillHints.email],
        enabled: enabled,
        autovalidateMode: autovalidateMode,
        initialValue: initialValue,
        onFieldSaved: onFieldSaved,
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            if (!required) return null;
            return 'Email is required';
          }
          if (!value.isEmail) return 'Enter a valid email address';
          return validator?.call(value);
        },
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      );
}
