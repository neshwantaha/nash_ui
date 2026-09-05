import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A reactive, observable form field that exposes its current value, error
/// message and validity through [ValueNotifier]s.
///
/// Unlike the imperative [Form]/[FormTextField] wrappers, [ReactiveField]
/// is fully reactive: listeners react to value and error changes without
/// manual `setState` calls.
class ReactiveField<T> {
  ReactiveField(this.initial,
      {List<FormFieldValidator<String>> validators = const []})
      : _value = ValueNotifier<T>(initial),
        _error = ValueNotifier<String?>(null) {
    this.validators.addAll(validators);
    _validate();
  }

  /// Initial value of the field.
  final T initial;

  /// Validation rules applied to the raw string value.
  final List<FormFieldValidator<String>> validators = [];

  final ValueNotifier<T> _value;
  final ValueNotifier<String?> _error;

  /// Observable stream of the current value.
  ValueListenable<T> get value => _value;

  /// Observable error message, or null when the field has no error.
  ValueListenable<String?> get error => _error;

  /// Whether the field currently satisfies all validators.
  bool get isValid => validators.every((v) => v(_asString) == null);

  /// Whether the field is non-empty (value is not whitespace).
  bool get isEmpty => _asString.trim().isEmpty;

  /// The current field error, or null.
  String? get currentError => _error.value;

  String get _asString => _value.value?.toString() ?? '';

  /// Sets the field value and re-validates.
  void update(T next) {
    _value.value = next;
    _validate();
  }

  /// Sets the error without touching the value (e.g. from a server response).
  void setError(String? message) => _error.value = message;

  /// Re-runs the validators against the current value.
  void _validate() {
    String? result;
    for (final v in validators) {
      result = v(_asString);
      if (result != null) break;
    }
    _error.value = result;
  }

  void dispose() {
    _value.dispose();
    _error.dispose();
  }
}

/// A convenience builder that creates and validates a string field.
ReactiveField<String> reactiveText({
  String initial = '',
  List<FormFieldValidator<String>> validators = const [],
}) =>
    ReactiveField<String>(initial, validators: validators);

/// A smart, fully-reactive form controller.
///
/// Manages a collection of [ReactiveField]s, tracks form-level validity and
/// computes the submitted value map.
///
/// ```dart
/// final form = ReactiveFormController();
/// final email = reactiveText(validators: [Validators.email()]);
/// final password = reactiveText(validators: [Validators.password()]);
///
/// form.add('email', email);
/// form.add('password', password);
///
/// // In builder:
/// ValueListenableBuilder(
///   valueListenable: form.valid,
///   builder: (context, valid, _) => PrimaryButton(
///     label: 'Submit', onPressed: valid ? () => form.submit() : null,
///   ),
/// )
/// ```
class ReactiveFormController extends ChangeNotifier {
  ReactiveFormController() {
    _valid = ValueNotifier<bool>(false);
    _refreshing = false;
  }

  final Map<String, ReactiveField<dynamic>> _fields = {};
  final List<ReactiveField<dynamic>> _order = [];
  late final ValueNotifier<bool> _valid;
  late bool _refreshing;

  /// Observable form-level validity.
  ValueNotifier<bool> get valid => _valid;

  /// Adds a field under [name] and registers listeners.
  void add(String name, ReactiveField<dynamic> field) {
    if (_fields.containsKey(name)) {
      throw ArgumentError('A field named "$name" already exists.');
    }
    _fields[name] = field;
    _order.add(field);
    field.value.addListener(_refresh);
    field.error.addListener(_refresh);
    _refresh();
  }

  /// Returns the field registered under [name].
  ReactiveField<dynamic> field(String name) => _fields[name]!;

  /// Returns a typed view of a field registered under [name].
  ReactiveField<T> fieldOf<T>(String name) =>
      _fields[name]! as ReactiveField<T>;

  /// Re-validates every field and refreshes form validity.
  void validate() {
    for (final f in _order) {
      f._validate();
    }
    _refresh();
  }

  /// Whether all fields are currently valid.
  bool get isValid => _order.isNotEmpty && _order.every((f) => f.isValid);

  /// Collects the current values keyed by field name.
  Map<String, dynamic> get values => Map.unmodifiable(
        _fields.map((name, f) => MapEntry(name, f.value.value)),
      );

  /// Validates every field. Returns true when valid, otherwise false.
  bool submit() {
    validate();
    return isValid;
  }

  void _refresh() {
    if (_refreshing) return;
    _refreshing = true;
    _valid.value = isValid;
    _refreshing = false;
  }

  /// Resets every field to its initial value.
  void reset() {
    for (final f in _order) {
      f.update(f.initial as dynamic);
    }
    _refresh();
  }

  @override
  void dispose() {
    for (final f in _order) {
      f.value.removeListener(_refresh);
      f.error.removeListener(_refresh);
      f.dispose();
    }
    _valid.dispose();
    super.dispose();
  }
}

/// Alias so consumers can use the shorter idiomatic name.
typedef FormController = ReactiveFormController;
