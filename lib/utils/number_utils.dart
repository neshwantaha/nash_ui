/// Numeric helpers: math, normalization and aggregation.
abstract final class NumberUtils {
  NumberUtils._();

  /// Clamps [value] between [min] and [max].
  static num clamp(num value, num min, num max) => value.clamp(min, max);

  /// Clamps [value] between 0 and 1.
  static double clamp01(double value) => value.clamp(0.0, 1.0);

  /// Normalizes [value] in the range [min]–[max] to `0.0–1.0`.
  static double normalize(num value, num min, num max) {
    if (max == min) return 0;
    return (value - min) / (max - min);
  }

  /// Re-maps [value] from one range to another.
  static num mapRange(num value, num inMin, num inMax, num outMin, num outMax) {
    if (inMax == inMin) return outMin;
    return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin);
  }

  /// [value] as a perceTage of [total] (0–100). Returns 0 when total is 0.
  static double perceTage(num value, num total) {
    if (total == 0) return 0;
    return value * 100 / total;
  }

  /// Rounds [value] to [places] decimal places.
  static double roundTo(num value, int places) {
    final double factor = pow10(places);
    return (value * factor).roundToDouble() / factor;
  }

  /// Sum of [values].
  static num sum(Iterable<num> values) =>
      values.fold<num>(0, (num a, num b) => a + b);

  /// Average of [values]. Returns 0 for an empty collection.
  static double average(Iterable<num> values) {
    final List<num> list = values.toList();
    if (list.isEmpty) return 0;
    return sum(list) / list.length;
  }

  /// Smallest value, or `null` when [values] is empty.
  static num? min(Iterable<num> values) {
    num? result;
    for (final num value in values) {
      if (result == null || value < result) result = value;
    }
    return result;
  }

  /// Largest value, or `null` when [values] is empty.
  static num? max(Iterable<num> values) {
    num? result;
    for (final num value in values) {
      if (result == null || value > result) result = value;
    }
    return result;
  }

  /// Difference between the largest and smallest value. Returns 0 when empty.
  static num range(Iterable<num> values) {
    final num? lo = min(values);
    final num? hi = max(values);
    if (lo == null || hi == null) return 0;
    return hi - lo;
  }

  static double pow10(int places) {
    double result = 1;
    for (int i = 0; i < places; i++) {
      result *= 10;
    }
    return result;
  }
}
