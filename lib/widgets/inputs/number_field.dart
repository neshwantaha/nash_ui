import 'package:flutter/material.dart' hide TextField;
import 'package:flutter/services.dart';

import '../../icons/app_icons.dart';
import 'text_field.dart';

/// A numeric input field with an optional currency/unit prefix.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.initialValue,
    this.icon,
    this.prefix,
    this.decimals = 0,
    this.min,
    this.max,
    this.textInputAction,
    this.onFieldSaved,
    this.suffixIcon,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Label text.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Form validator.
  final String? Function(String?)? validator;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Whether editing is allowed.
  final bool enabled;

  /// Initial value.
  final String? initialValue;

  /// Leading icon.
  final IconData? icon;

  /// Prefix such as `\$` or `kg`.
  final String? prefix;

  /// Maximum decimal places allowed.
  final int decimals;

  /// Minimum value.
  final double? min;

  /// Maximum value.
  final double? max;

  /// Keyboard action.
  final TextInputAction? textInputAction;

  /// Called when the form saves the value.
  final ValueChanged<String?>? onFieldSaved;

  /// Trailing widget.
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final String decimalsPattern =
        decimals > 0 ? r'^\d*\.?\d{0,' '$decimals' r'}$' : r'^\d*$';
    final RegExp pattern = RegExp(decimalsPattern);
    return TextField(
      controller: controller,
      label: label,
      hint: hint,
      icon: icon ?? AppIcons.bolt,
      prefixText: prefix,
      keyboardType: TextInputType.numberWithOptions(decimal: decimals > 0),
      textInputAction: textInputAction ?? TextInputAction.done,
      enabled: enabled,
      initialValue: initialValue,
      onFieldSaved: onFieldSaved,
      suffixIcon: suffixIcon,
      inputFormatters: <TextInputFormatter>[
        TextInputFormatter.withFunction(
          (TextEditingValue oldValue, TextEditingValue newValue) =>
              pattern.hasMatch(newValue.text) ? newValue : oldValue,
        ),
      ],
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) return null;
        final double? number = double.tryParse(value);
        if (number == null) return 'Enter a valid number';
        if (min != null && number < min!) return 'Minimum is $min';
        if (max != null && number > max!) return 'Maximum is $max';
        return validator?.call(value);
      },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
