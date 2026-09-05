import 'package:flutter/material.dart' hide TextField;

import '../../icons/app_icons.dart';
import 'text_field.dart';

/// A phone number input field with phone keyboard and country prefix.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    this.controller,
    this.label = 'Phone',
    this.hint = '+1 555 000 0000',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.initialValue,
    this.countryCode = '+1',
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

  /// Additional validator combined with the phone check.
  final String? Function(String?)? validator;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Whether editing is allowed.
  final bool enabled;

  /// Initial value.
  final String? initialValue;

  /// Country dial code prefix.
  final String countryCode;

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
        icon: icon ?? AppIcons.phone,
        prefixText: countryCode,
        keyboardType: TextInputType.phone,
        textInputAction: textInputAction ?? TextInputAction.next,
        autofillHints: const <String>[AutofillHints.telephoneNumber],
        enabled: enabled,
        initialValue: initialValue,
        onFieldSaved: onFieldSaved,
        validator: (String? value) {
          final String digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
          if (digits.isEmpty) return required ? 'Phone is required' : null;
          if (digits.length < 7) return 'Enter a valid phone number';
          return validator?.call(value);
        },
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      );
}
