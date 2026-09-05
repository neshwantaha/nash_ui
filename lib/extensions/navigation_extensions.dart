import 'package:flutter/material.dart';

/// Named navigation helpers that return the resulting [Future].
extension NavigationX on BuildContext {
  /// Pushes a new route and awaits the result.
  Future<T?> push<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute<T>(builder: (_) => page));

  /// Replaces the current route with [page].
  Future<T?> pushReplacement<T, TO>(Widget page) => Navigator.of(this)
      .pushReplacement<T, TO>(MaterialPageRoute<T>(builder: (_) => page));

  /// Pushes [page] and removes every route until [predicate].
  Future<T?> pushAndRemoveUntil<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute<T>(builder: (_) => page),
        predicate,
      );

  /// Pushes [page] and clears the entire navigation stack.
  Future<T?> pushAndClear<T>(Widget page) =>
      pushAndRemoveUntil<T>(page, (_) => false);

  /// Pops the current route.
  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);

  /// Pops until the first route.
  void popUntilFirst() => Navigator.of(this).popUntil((route) => route.isFirst);

  /// Pops up to [count] routes.
  void popCount(int count) {
    final NavigatorState navigator = Navigator.of(this);
    for (int i = 0; i < count; i++) {
      if (!navigator.canPop()) break;
      navigator.pop();
    }
  }

  /// Whether it is possible to pop.
  bool get canPop => Navigator.of(this).canPop();
}
