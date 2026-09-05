import 'package:flutter/widgets.dart';

/// Corner radius tokens for the design system.
///
/// Maps 1:1 onto [AppRadius.values] and provides helpers for producing
/// [BorderRadius] and [RoundedRectangleBorder] instances.
abstract final class AppRadius {
  AppRadius._();

  /// Small radius (8) — chips, tags, small controls.
  static const double small = 8;

  /// Medium radius (12) — inputs, buttons, alerts.
  static const double medium = 12;

  /// Large radius (16) — cards, sheets.
  static const double large = 16;

  /// Extra large radius (24) — hero cards, dialogs.
  static const double extraLarge = 24;

  /// Circular radius — avatars, floating buttons, pills.
  static const double circular = 1000;

  /// [BorderRadius] built from [small].
  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(small),
  );

  /// [BorderRadius] built from [medium].
  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(medium),
  );

  /// [BorderRadius] built from [large].
  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(large),
  );

  /// [BorderRadius] built from [extraLarge].
  static const BorderRadius borderRadiusExtraLarge = BorderRadius.all(
    Radius.circular(extraLarge),
  );

  /// Fully circular [BorderRadius].
  static const BorderRadius borderRadiusCircular = BorderRadius.all(
    Radius.circular(circular),
  );

  /// [RoundedRectangleBorder] built from [medium].
  static const RoundedRectangleBorder roundedMedium =
      RoundedRectangleBorder(borderRadius: borderRadiusMedium);

  /// [RoundedRectangleBorder] built from [large].
  static const RoundedRectangleBorder roundedLarge =
      RoundedRectangleBorder(borderRadius: borderRadiusLarge);

  /// [RoundedRectangleBorder] built from [extraLarge].
  static const RoundedRectangleBorder roundedExtraLarge =
      RoundedRectangleBorder(borderRadius: borderRadiusExtraLarge);

  /// Creates a [RoundedRectangleBorder] with [radius].
  static RoundedRectangleBorder rounded([double radius = small]) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}
