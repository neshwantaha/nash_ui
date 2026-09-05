import 'package:flutter/material.dart';

import '../../icons/app_icons.dart';
import '../../radius/app_radius.dart';

/// A themed dropdown form field.
class Dropdown<T> extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.items,
    this.value,
    this.label,
    this.hint,
    this.icon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.isExpanded = true,
    this.onFieldSaved,
    this.borderRadius = AppRadius.medium,
    this.autovalidateMode,
    this.dropdownColor,
  });

  /// Available options.
  final List<DropdownItem<T>> items;

  /// Current value.
  final T? value;

  /// Label text.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Leading icon.
  final IconData? icon;

  /// Form validator.
  final String? Function(T?)? validator;

  /// Called when a value is selected.
  final ValueChanged<T?>? onChanged;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the selected item fills the width.
  final bool isExpanded;

  /// Called when the form saves the value.
  final ValueChanged<T?>? onFieldSaved;

  /// Corner radius.
  final double borderRadius;

  /// Autovalidate mode.
  final AutovalidateMode? autovalidateMode;

  /// Menu background color.
  final Color? dropdownColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: isExpanded,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      onSaved: onFieldSaved,
      autovalidateMode: autovalidateMode,
      dropdownColor: dropdownColor,
      icon: const Icon(AppIcons.chevronDown, size: 20),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        filled: true,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      items: items
          .map(
            (DropdownItem<T> item) => DropdownMenuItem<T>(
              value: item.value,
              child: item.builder?.call(context) ?? Text(item.label),
            ),
          )
          .toList(),
    );
  }
}

/// A single dropdown option.
class DropdownItem<T> {
  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.builder,
  });

  /// Option value.
  final T value;

  /// Display label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Custom child builder.
  final Widget Function(BuildContext context)? builder;
}
