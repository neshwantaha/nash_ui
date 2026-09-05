import 'package:flutter/widgets.dart';

/// Shadow elevation tokens for the design system.
///
/// Provides consistent, tasteful shadows for floating surfaces. Each token is
/// exposed as a [List] of [BoxShadow] for direct use in `BoxDecoration`, and
/// as a named constructor producing a full elevation style.
abstract final class AppShadow {
  AppShadow._();

  /// Soft / low elevation shadow (default).
  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium elevation shadow.
  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Strong / high elevation shadow.
  static const List<BoxShadow> strong = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Glass-style soft shadow for translucent surfaces.
  static const List<BoxShadow> glass = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];

  /// Floating button / FAB elevation.
  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// A primary-tinted soft glow used to lift branded surfaces.
  static const List<BoxShadow> glow = <BoxShadow>[
    BoxShadow(
      color: Color(0x334F46E5),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Colored glow around a success surface.
  static const List<BoxShadow> glowSuccess = <BoxShadow>[
    BoxShadow(
      color: Color(0x3316A34A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Colored glow around an error surface.
  static const List<BoxShadow> glowError = <BoxShadow>[
    BoxShadow(
      color: Color(0x33DC2626),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Returns a shadow list tinted with [color].
  static List<BoxShadow> tinted(
    Color color, {
    double blurRadius = 16,
    double offsetY = 4,
    double opacity = 0.18,
  }) =>
      <BoxShadow>[
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: blurRadius,
          offset: Offset(0, offsetY),
        ),
      ];

  /// Default decoration shadow used by elevated cards.
  static const List<BoxShadow> card = medium;

  /// Branded shadow used by primary surfaces.
  static const List<BoxShadow> brand = <BoxShadow>[
    BoxShadow(
      color: Color(0x4D4F46E5),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
