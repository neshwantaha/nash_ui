import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// Generic application helpers and utilities.
abstract class AppHelpers {
  const AppHelpers._();

  static int _uidCounter = 0;
  static final Random _random = Random();

  /// Shows the system keyboard for [focusNode].
  static void focus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// Unfocuses the currently focused field.
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Pushes a new route and ignores duplicate pushes.
  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pushes a named route.
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Pops to the root route.
  static void popUntilFirst(BuildContext context) {
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
  }

  /// Debounces [action] calls.
  static Timer debounce(Duration delay, VoidCallback action) =>
      Timer(delay, action);

  /// Returns a copy of [list] with [value] removed.
  static List<T> without<T>(List<T> list, T value) =>
      <T>[...list]..remove(value);

  /// Wraps [value] in a [Tween] range clamp helper.
  static double clamp01(double value) => value.clamp(0.0, 1.0);

  /// Returns `true` when the given index is even and non-negative.
  static bool isEven(int index) => index >= 0 && index.isEven;

  /// Generates a short unique id.
  static String uid() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_uidCounter++}-${_random.nextInt(0xFFFF)}';
}
