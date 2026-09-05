import 'package:flutter/material.dart' hide TextField;

import '../../icons/app_icons.dart';
import 'text_field.dart';

/// A password field with a show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autovalidateMode,
    this.initialValue,
    this.icon,
    this.textInputAction,
    this.onFieldSaved,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Label text.
  final String label;

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

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) => TextField(
        controller: widget.controller,
        label: widget.label,
        hint: widget.hint,
        icon: widget.icon ?? AppIcons.lock,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        enabled: widget.enabled,
        autovalidateMode: widget.autovalidateMode,
        initialValue: widget.initialValue,
        textInputAction: widget.textInputAction,
        onFieldSaved: widget.onFieldSaved,
        obscureText: _obscured,
        autofillHints: const <String>[AutofillHints.password],
        suffixIcon: IconButton(
          icon: Icon(
            _obscured ? AppIcons.visibility : AppIcons.visibilityOff,
            size: 20,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
          tooltip: _obscured ? 'Show password' : 'Hide password',
        ),
      );
}
