/// Standard responsive breakpoints (logical pixels).
abstract final class AppBreakpoint {
  AppBreakpoint._();

  /// Upper bound of the phone range.
  static const double phone = 600;

  /// Upper bound of the tablet range.
  static const double tablet = 1024;

  /// Compact layout cutoff (Material).
  static const double compact = 600;

  /// Medium layout cutoff (Material).
  static const double medium = 840;

  /// Expanded layout cutoff (Material).
  static const double expanded = 1200;
}
