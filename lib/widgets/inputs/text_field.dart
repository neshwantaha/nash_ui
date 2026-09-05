import 'package:flutter/material.dart' hide TextField;
import 'package:flutter/material.dart' as flutter show TextField;
import 'package:flutter/services.dart';

import '../../radius/app_radius.dart';

/// A themed text field with full form integration (validator + saved value).
///
/// A backwards-compatible alias for [TextField].
typedef NashTextField = TextField;

/// A themed text field with full form integration (validator + saved value).
///
/// Wraps [TextField] inside a [FormField] so it validates like a normal
/// `TextFormField`.
class TextField extends StatelessWidget {
  const TextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.icon,
    this.prefixText,
    this.suffixIcon,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.initialValue,
    this.autofocus = false,
    this.autofillHints,
    this.inputFormatters,
    this.capitalization = TextCapitalization.none,
    this.autovalidateMode,
    this.filled = true,
    this.focusBorderColor,
    this.borderRadius = AppRadius.medium,
    this.onFieldSaved,
    this.textAlign = TextAlign.start,
    this.cursorColor,
    this.textStyle,
    this.decoration,
  });

  /// Explicit InputDecoration override (for Flutter compatibility).
  final InputDecoration? decoration;

  /// Optional external controller.
  final TextEditingController? controller;

  /// Label text.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Leading icon.
  final IconData? icon;

  /// Text shown before the input value.
  final String? prefixText;

  /// Trailing widget.
  final Widget? suffixIcon;

  /// Static error text.
  final String? errorText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Keyboard action.
  final TextInputAction? textInputAction;

  /// Mask the input.
  final bool obscureText;

  /// Character used for masking.
  final String obscuringCharacter;

  /// Whether editing is allowed.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Maximum lines.
  final int maxLines;

  /// Minimum lines.
  final int? minLines;

  /// Maximum input length.
  final int? maxLength;

  /// Form validator.
  final String? Function(String?)? validator;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Called on tap.
  final VoidCallback? onTap;

  /// External focus node.
  final FocusNode? focusNode;

  /// Initial value.
  final String? initialValue;

  /// Whether to focus on mount.
  final bool autofocus;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Text capitalization.
  final TextCapitalization capitalization;

  /// Autovalidate mode.
  final AutovalidateMode? autovalidateMode;

  /// Background fill.
  final bool filled;

  /// Focused border color.
  final Color? focusBorderColor;

  /// Corner radius.
  final double borderRadius;

  /// Called when the form saves the value.
  final ValueChanged<String?>? onFieldSaved;

  /// Text alignment.
  final TextAlign textAlign;

  /// Cursor color.
  final Color? cursorColor;

  /// Input text style.
  final TextStyle? textStyle;

  /// Builds the [InputDecoration] used by this field.
  InputDecoration buildDecoration(BuildContext context, {String? error}) {
    if (decoration != null) {
      if (error != null) {
        return decoration!.copyWith(errorText: error);
      }
      return decoration!;
    }
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error ?? errorText,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      filled: filled,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide:
            BorderSide(color: focusBorderColor ?? scheme.primary, width: 2),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onFieldSaved,
      builder: (FormFieldState<String> field) => flutter.TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        autofocus: autofocus,
        autofillHints: autofillHints,
        inputFormatters: inputFormatters,
        textCapitalization: capitalization,
        textAlign: textAlign,
        cursorColor: cursorColor ?? theme.colorScheme.primary,
        style: textStyle,
        decoration: buildDecoration(context, error: field.errorText),
        onChanged: (String value) {
          field.didChange(value);
          onChanged?.call(value);
        },
        onSubmitted: onSubmitted,
        onTap: onTap,
      ),
    );
  }
}
