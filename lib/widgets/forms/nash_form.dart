import 'package:flutter/material.dart' hide Form, FormState;
import 'package:flutter/material.dart' as fl show FormState;
import '../../colors/colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '_form_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Validators — Collection of common form validators
// ─────────────────────────────────────────────────────────────────────────────

/// A collection of reusable field validators for use with [Form] or
/// Flutter's built-in [Form] widget.
class Validators {
  Validators._();

  /// Validates that the field is not empty.
  static FormFieldValidator<String> required([String? message]) =>
      (value) => (value == null || value.trim().isEmpty)
          ? (message ?? 'This field is required')
          : null;

  /// Validates email format.
  static FormFieldValidator<String> email([String? message]) => (value) {
        if (value == null || value.trim().isEmpty) return null;
        final regex = RegExp(r'^[\w._%+\-]+@[\w.\-]+\.[a-zA-Z]{2,}$');
        if (!regex.hasMatch(value.trim())) {
          return message ?? 'Please enter a valid email address';
        }
        return null;
      };

  /// Validates phone number (international format).
  static FormFieldValidator<String> phone([String? message]) => (value) {
        if (value == null || value.trim().isEmpty) return null;
        final regex = RegExp(r'^\+?[\d\s\-().]{7,15}$');
        if (!regex.hasMatch(value.trim())) {
          return message ?? 'Please enter a valid phone number';
        }
        return null;
      };

  /// Validates password strength.
  static FormFieldValidator<String> password({
    int minLength = 8,
    bool requireUppercase = false,
    bool requireSymbol = false,
    String? message,
  }) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        if (value.length < minLength) {
          return message ?? 'Password must be at least $minLength characters';
        }
        if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
          return 'Password must contain at least one uppercase letter';
        }
        if (requireSymbol &&
            !value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
          return 'Password must contain at least one symbol';
        }
        return null;
      };

  /// Validates minimum character length.
  static FormFieldValidator<String> minLength(int min, [String? message]) =>
      (value) => (value != null && value.length < min)
          ? (message ?? 'Must be at least $min characters')
          : null;

  /// Validates maximum character length.
  static FormFieldValidator<String> maxLength(int max, [String? message]) =>
      (value) => (value != null && value.length > max)
          ? (message ?? 'Must be no more than $max characters')
          : null;

  /// Validates URL format.
  static FormFieldValidator<String> url([String? message]) => (value) {
        if (value == null || value.trim().isEmpty) return null;
        final uri = Uri.tryParse(value.trim());
        if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
          return message ?? 'Please enter a valid URL (https://...)';
        }
        return null;
      };

  /// Validates that the value is numeric.
  static FormFieldValidator<String> numeric([String? message]) => (value) {
        if (value == null || value.trim().isEmpty) return null;
        if (double.tryParse(value.trim()) == null) {
          return message ?? 'Please enter a valid number';
        }
        return null;
      };

  /// Validates that the value matches another field's value.
  static FormFieldValidator<String> match(
    String Function() getOther, [
    String? message,
  ]) =>
      (value) =>
          value != getOther() ? (message ?? 'Fields do not match') : null;

  /// Combines multiple validators — returns the first error found.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) =>
      (value) {
        for (final v in validators) {
          final result = v(value);
          if (result != null) return result;
        }
        return null;
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Form — Smart form wrapper with auto-validation and submit management
// ─────────────────────────────────────────────────────────────────────────────

/// A smart form wrapper that manages validation state, loading state,
/// and focus traversal automatically.
///
/// ```dart
/// Form(
///   onSubmit: (values) async {
///     await api.login(values['email']!, values['password']!);
///   },
///   builder: (key, isLoading) => Column(
///     children: [
///       FormTextField(name: 'email', validators: [Validators.email()]),
///       FormTextField(name: 'password', validators: [Validators.password()]),
///       LoadingButton(label: 'Sign In', isLoading: isLoading, onPressed: () => key.currentState?.submit()),
///     ],
///   ),
/// )
/// A declarative, type-safe Form wrapper with automatic validation,
/// loading state management, and field value collection.
///
/// A backwards-compatible alias for [Form].
typedef NashForm = Form;

/// A backwards-compatible alias for [FormTextField].
typedef NashFormTextField = FormTextField;

class Form extends StatefulWidget {
  const Form({
    super.key,
    this.builder,
    this.child,
    this.onSubmit,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  /// Builds the form content. Receives the form key and a loading boolean.
  final Widget Function(GlobalKey<FormState> key, {required bool isLoading})?
      builder;

  /// Direct child widget (Flutter compatibility).
  final Widget? child;

  /// Called when the form is submitted and all validations pass.
  /// Receives a map of field `name` → `value`.
  final Future<void> Function(Map<String, String> values)? onSubmit;

  /// When to trigger validation.
  final AutovalidateMode autovalidateMode;

  @override
  State<Form> createState() => FormState();
}

class FormState extends State<Form> {
  final GlobalKey<fl.FormState> _formKey = GlobalKey<fl.FormState>();
  final GlobalKey<FormState> _selfKey = GlobalKey<FormState>();
  final Map<String, String> _values = {};
  bool _isLoading = false;

  /// Register a field value (called internally by [FormTextField]).
  void registerValue(String name, String value) {
    _values[name] = value;
  }

  /// Validates all fields and calls [Form.onSubmit] if valid.
  Future<void> submit() async {
    if (_formKey.currentState?.validate() != true) return;
    _formKey.currentState?.save();
    if (widget.onSubmit == null) return;
    setState(() => _isLoading = true);
    try {
      await widget.onSubmit!(Map.unmodifiable(_values));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = widget.child ??
        widget.builder?.call(_selfKey, isLoading: _isLoading) ??
        const SizedBox.shrink();
    return buildFormWidget(
      formKey: _formKey,
      autovalidateMode: widget.autovalidateMode,
      child: content,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FormTextField — Named field that integrates with Form
// ─────────────────────────────────────────────────────────────────────────────

/// A [TextFormField] that participates in [Form]'s value collection.
///
/// Wrap each input in the form with this widget and give it a unique [name].
class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.icon,
    this.validators = const [],
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
  });

  /// Unique field name used as key in the values map.
  final String name;
  final String? label;
  final String? hint;
  final IconData? icon;
  final List<FormFieldValidator<String>> validators;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? initialValue;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      initialValue: widget.initialValue,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onSaved: (v) {
        final form = context.findAncestorStateOfType<FormState>();
        form?.registerValue(widget.name, v ?? '');
      },
      validator: widget.validators.isEmpty
          ? null
          : Validators.compose(widget.validators),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
      ),
    );
  }
}
