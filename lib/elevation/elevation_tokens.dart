import 'package:flutter/widgets.dart';

/// Z-index / elevation token system for managing overlay stacking.
///
/// Provides consistent elevation values across the design system to
/// ensure predictable layering of modals, snackbars, tooltips, and
/// other overlays.
abstract final class AppElevation {
  AppElevation._();

  // ---------------------------------------------------------------------------
  // Z-Index Tokens (CSS-inspired)
  // ---------------------------------------------------------------------------

  /// Base level — default content.
  static const int base = 0;

  /// Raised content — cards, sheets.
  static const int raised = 1;

  /// Dropdown menus, popovers.
  static const int dropdown = 1000;

  /// Sticky elements.
  static const int sticky = 1020;

  /// Fixed navigation (app bars, bottom bars).
  static const int fixed = 1030;

  /// Backdrop overlay (behind modals).
  static const int backdrop = 1040;

  /// Modal / dialog.
  static const int modal = 1050;

  /// Popover / tooltip.
  static const int popover = 1060;

  /// Snackbar / toast.
  static const int snackbar = 1070;

  /// Tooltip (topmost standard).
  static const int tooltip = 1080;

  /// Maximum z-index for system overlays.
  static const int max = 1090;

  // ---------------------------------------------------------------------------
  // Material Elevation Tokens
  // ---------------------------------------------------------------------------

  /// No elevation.
  static const double none = 0;

  /// dp1 — subtle card lift.
  static const double dp1 = 1;

  /// dp2 — standard card.
  static const double dp2 = 2;

  /// dp3 — raised card / FAB.
  static const double dp3 = 3;

  /// dp4 — bottom sheet.
  static const double dp4 = 4;

  /// dp6 — navigation drawer.
  static const double dp6 = 6;

  /// dp8 — app bar scrolled.
  static const double dp8 = 8;

  /// dp12 — floating action button.
  static const double dp12 = 12;

  /// dp16 — modal bottom sheet.
  static const double dp16 = 16;

  /// dp24 — dialog.
  static const double dp24 = 24;
}

/// A widget that applies a z-index value using [Stack].
///
/// ```dart
/// ZIndexed(
///   index: AppElevation.dropdown,
///   child: MyDropdown(),
/// )
/// ```
class ZIndexed extends StatelessWidget {
  const ZIndexed({
    super.key,
    required this.index,
    required this.child,
  });

  /// The z-index value.
  final int index;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) => IndexedStack(
        index: index > 0 ? 0 : null,
        children: <Widget>[child],
      );
}

/// Convenience extension on BuildContext for elevation lookup.
extension ElevationX on BuildContext {
  /// Whether the system prefers reduced motion.
  bool get prefersReducedMotion => MediaQuery.disableAnimationsOf(this);
}
