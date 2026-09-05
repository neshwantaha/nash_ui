/// Iterable & List utility extensions.
extension IterableX<T> on Iterable<T> {
  /// Splits this iterable into chunks of size [size].
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].chunked(2); // [[1, 2], [3, 4], [5]]
  /// ```
  List<List<T>> chunked(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be greater than 0');
    final List<List<T>> chunks = <List<T>>[];
    final List<T> list = toList();
    for (int i = 0; i < list.length; i += size) {
      final int end = (i + size < list.length) ? i + size : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  /// Returns the sum of values extracted by [selector].
  num sumBy(num Function(T element) selector) {
    num total = 0;
    for (final T element in this) {
      total += selector(element);
    }
    return total;
  }

  /// Returns elements separated by [separator].
  ///
  /// ```dart
  /// [Text('A'), Text('B')].separated(const SizedBox(width: 8));
  /// ```
  List<T> separated(T separator) {
    final List<T> list = toList();
    if (list.length <= 1) return list;
    final List<T> result = <T>[];
    for (int i = 0; i < list.length; i++) {
      result.add(list[i]);
      if (i < list.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  /// Finds first element matching [predicate] or returns `null`.
  T? firstWhereOrNull(bool Function(T element) predicate) {
    for (final T element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// Finds last element matching [predicate] or returns `null`.
  T? lastWhereOrNull(bool Function(T element) predicate) {
    T? result;
    for (final T element in this) {
      if (predicate(element)) result = element;
    }
    return result;
  }

  /// Returns a new list containing distinct elements according to [keySelector].
  List<T> distinctBy<K>(K Function(T element) keySelector) {
    final Set<K> seen = <K>{};
    final List<T> result = <T>[];
    for (final T element in this) {
      if (seen.add(keySelector(element))) {
        result.add(element);
      }
    }
    return result;
  }
}

/// Nullable Iterable utility extensions.
extension NullableIterableX<T> on Iterable<T?> {
  /// Filters out all `null` values from this iterable.
  List<T> get whereNotNull =>
      where((T? element) => element != null).cast<T>().toList();
}
