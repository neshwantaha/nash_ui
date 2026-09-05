import 'package:flutter/material.dart' hide Chip;

import '../../icons/app_icons.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '../buttons/primary_button.dart';
import '../selection/controls.dart';
import 'dropdown.dart';

/// A multi-select field built from selectable chips and a bottom-sheet picker.
class MultiSelect<T> extends StatefulWidget {
  const MultiSelect({
    super.key,
    required this.items,
    this.selected = const <Never>[],
    this.label,
    this.hint,
    this.icon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.borderRadius = AppRadius.medium,
    this.maxSelected,
  });

  /// Available options.
  final List<DropdownItem<T>> items;

  /// Currently selected values.
  final List<T> selected;

  /// Label text.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Leading icon.
  final IconData? icon;

  /// Validator receiving the selected values.
  final String? Function(List<T>?)? validator;

  /// Called when the selection changes.
  final ValueChanged<List<T>>? onChanged;

  /// Whether the field is interactive.
  final bool enabled;

  /// Corner radius.
  final double borderRadius;

  /// Maximum number of selectable items.
  final int? maxSelected;

  @override
  State<MultiSelect<T>> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  late List<T> _selected;
  FormFieldState<List<T>>? _fieldState;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.of(widget.selected);
  }

  @override
  void didUpdateWidget(MultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _selected = List<T>.of(widget.selected);
    }
  }

  void _update(List<T> next) {
    setState(() => _selected = next);
    _fieldState?.didChange(next);
    widget.onChanged?.call(next);
  }

  Future<void> _openPicker() async {
    final List<T>? result = await showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.extraLarge)),
      ),
      builder: (BuildContext context) => _MultiSelectSheet<T>(
        items: widget.items,
        initial: _selected,
        maxSelected: widget.maxSelected,
      ),
    );
    if (result != null) _update(result);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Map<T, DropdownItem<T>> byValue = <T, DropdownItem<T>>{
      for (final DropdownItem<T> item in widget.items) item.value: item,
    };
    return FormField<List<T>>(
      initialValue: _selected,
      validator: widget.validator,
      builder: (FormFieldState<List<T>> field) {
        _fieldState = field;
        return InkWell(
          onTap: widget.enabled ? _openPicker : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint ?? 'Select one or more',
              prefixIcon:
                  widget.icon != null ? Icon(widget.icon, size: 20) : null,
              suffixIcon: const Icon(AppIcons.chevronDown, size: 20),
              errorText: field.errorText,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: scheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: scheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: scheme.primary, width: 2),
              ),
            ),
            child: _selected.isEmpty
                ? Text(
                    widget.hint ?? 'Select one or more',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  )
                : Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: _selected
                        .map(
                          (T value) => Chip(
                            label: byValue[value]?.label ?? value.toString(),
                            selected: true,
                            onDeleted: () => _update(
                              List<T>.of(_selected)..remove(value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        );
      },
    );
  }
}

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.items,
    required this.initial,
    this.maxSelected,
  });

  final List<DropdownItem<T>> items;
  final List<T> initial;
  final int? maxSelected;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late final Set<T> _picked;

  @override
  void initState() {
    super.initState();
    _picked = Set<T>.of(widget.initial);
  }

  void _toggle(T value) {
    setState(() {
      if (_picked.contains(value)) {
        _picked.remove(value);
      } else if (widget.maxSelected == null ||
          _picked.length < widget.maxSelected!) {
        _picked.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Select options', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: widget.items
                    .map((DropdownItem<T> item) => CheckboxListTile(
                          value: _picked.contains(item.value),
                          onChanged: (_) => _toggle(item.value),
                          title: Text(item.label),
                          controlAffinity: ListTileControlAffinity.leading,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Done (${_picked.length})',
              onPressed: () => Navigator.of(context).pop(List<T>.of(_picked)),
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
