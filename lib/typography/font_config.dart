import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FontConfig — Flexible font configuration for LTR + RTL support
// ─────────────────────────────────────────────────────────────────────────────

/// The source of a font family.
enum _FontSource { google, asset, system }

/// Configuration for a single direction (LTR or RTL).
class _DirectionFont {
  const _DirectionFont._(this.family, this.source);

  final String? family;
  final _FontSource source;

  TextTheme applyToTheme(TextTheme base) {
    if (family == null || source == _FontSource.system) return base;
    if (source == _FontSource.google) {
      try {
        return GoogleFonts.getTextTheme(family!, base);
      } catch (_) {
        return base;
      }
    }
    // asset font: apply fontFamily directly
    return base.apply(fontFamily: family);
  }

  String? resolvedFamily() {
    if (family == null || source == _FontSource.system) return null;
    return family;
  }
}

/// Flexible font configuration that supports separate fonts for LTR and RTL
/// layouts, using Google Fonts, local asset fonts, or the system font.
///
/// ### Quick examples
///
/// ```dart
/// // Both from Google Fonts
/// FontConfig.google(ltr: 'Inter', rtl: 'Cairo')
///
/// // Both from local assets (declared in pubspec.yaml)
/// FontConfig.asset(ltr: 'MyFont', rtl: 'MyArabicFont')
///
/// // Mixed: LTR from Google, RTL from local asset
/// FontConfig.mixed(ltrGoogle: 'Inter', rtlAsset: 'Cairo')
///
/// // Same font for both directions (Google Fonts)
/// FontConfig.google(ltr: 'Poppins')
///
/// // System font (no external dependency)
/// FontConfig.system()
/// ```
///
/// Pass to [Theme.light] / [Theme.dark] / [ThemeBuilder.fromSeed]:
/// ```dart
/// MaterialApp(
///   theme: Theme.light(fontConfig: FontConfig.google(ltr: 'Inter', rtl: 'Cairo')),
/// )
/// ```
///
/// Or use [FontConfig.textStyleFor] inside a widget to get a direction-aware
/// [TextStyle] at any point:
/// ```dart
/// Text(
///   'مرحبا',
///   style: fontConfig.textStyleFor(context, base: TextStyle(fontSize: 16)),
/// )
/// A backwards-compatible alias for [FontConfig].
typedef NashFontConfig = FontConfig;

class FontConfig {
  const FontConfig._({
    required _DirectionFont ltr,
    required _DirectionFont rtl,
  })  : _ltr = ltr,
        _rtl = rtl;

  /// Both LTR and RTL fonts loaded from **Google Fonts**.
  ///
  /// If [rtl] is omitted, the same [ltr] font is used for both directions.
  factory FontConfig.google({
    required String ltr,
    String? rtl,
  }) =>
      FontConfig._(
        ltr: _DirectionFont._(ltr, _FontSource.google),
        rtl: _DirectionFont._(rtl ?? ltr, _FontSource.google),
      );

  /// Both LTR and RTL fonts loaded from **local asset files**.
  ///
  /// The [ltr] and [rtl] values must match the `family` name declared in
  /// `pubspec.yaml` under `flutter.fonts`.
  ///
  /// If [rtl] is omitted, the same [ltr] font is used for both directions.
  factory FontConfig.asset({
    required String ltr,
    String? rtl,
  }) =>
      FontConfig._(
        ltr: _DirectionFont._(ltr, _FontSource.asset),
        rtl: _DirectionFont._(rtl ?? ltr, _FontSource.asset),
      );

  /// LTR from **Google Fonts**, RTL from a **local asset font**.
  factory FontConfig.mixed({
    required String ltrGoogle,
    required String rtlAsset,
  }) =>
      FontConfig._(
        ltr: _DirectionFont._(ltrGoogle, _FontSource.google),
        rtl: _DirectionFont._(rtlAsset, _FontSource.asset),
      );

  /// RTL from **Google Fonts**, LTR from a **local asset font**.
  factory FontConfig.mixedReversed({
    required String ltrAsset,
    required String rtlGoogle,
  }) =>
      FontConfig._(
        ltr: _DirectionFont._(ltrAsset, _FontSource.asset),
        rtl: _DirectionFont._(rtlGoogle, _FontSource.google),
      );

  /// No custom font — uses the system/platform default font.
  const factory FontConfig.system() = _SystemFontConfig;

  final _DirectionFont _ltr;
  final _DirectionFont _rtl;

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Returns the appropriate [TextTheme] for the current text direction.
  ///
  /// Call this inside [Theme.light] / [Theme.dark] to wire up the theme, or
  /// inside a widget to get a direction-aware text theme.
  TextTheme resolveTextTheme(TextDirection direction, TextTheme base) =>
      _fontFor(direction).applyToTheme(base);

  /// Returns the resolved `fontFamily` string for the current text direction.
  ///
  /// Useful when setting `ThemeData.fontFamily` directly.
  String? resolveFontFamily(TextDirection direction) =>
      _fontFor(direction).resolvedFamily();

  /// Returns a [TextStyle] with the correct font applied for the current
  /// [BuildContext]'s text direction.
  ///
  /// ```dart
  /// Text(
  ///   label,
  ///   style: myFontConfig.textStyleFor(context, base: TextStyle(fontSize: 14)),
  /// )
  /// ```
  TextStyle textStyleFor(BuildContext context,
      {TextStyle base = const TextStyle()}) {
    final direction = Directionality.of(context);
    final family = resolveFontFamily(direction);
    if (family == null) return base;
    return base.copyWith(fontFamily: family);
  }

  /// Returns a [Widget] that automatically switches font family based on the
  /// current text direction. Wraps [child] in a [DefaultTextStyle] override.
  ///
  /// Useful for mixed-direction layouts where part of the UI is RTL and
  /// another part is LTR.
  ///
  /// ```dart
  /// fontConfig.directionAwareTextStyle(
  ///   context: context,
  ///   child: Text('مرحبا'),
  /// )
  /// ```
  Widget directionAwareWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    final direction = Directionality.of(context);
    final family = resolveFontFamily(direction);
    if (family == null) return child;
    final existing = DefaultTextStyle.of(context).style;
    return DefaultTextStyle(
      style: existing.copyWith(fontFamily: family),
      child: child,
    );
  }

  _DirectionFont _fontFor(TextDirection direction) =>
      direction == TextDirection.rtl ? _rtl : _ltr;
}

/// Internal implementation for [FontConfig.system].
class _SystemFontConfig extends FontConfig {
  const _SystemFontConfig()
      : super._(
          ltr: const _DirectionFont._(null, _FontSource.system),
          rtl: const _DirectionFont._(null, _FontSource.system),
        );
}

// ─────────────────────────────────────────────────────────────────────────────
// DirectionText — Direction-aware Text widget
// ─────────────────────────────────────────────────────────────────────────────

/// A [Text] widget that automatically applies the correct font from a
/// [FontConfig] based on the current text direction.
///
/// ```dart
/// DirectionText(
///   'مرحبا بك',
///   fontConfig: FontConfig.google(ltr: 'Inter', rtl: 'Cairo'),
///   style: TextStyle(fontSize: 18),
/// )
/// A backwards-compatible alias for [DirectionText].
typedef NashDirectionText = DirectionText;

class DirectionText extends StatelessWidget {
  const DirectionText(
    this.data, {
    super.key,
    required this.fontConfig,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
  });

  /// The text string to display.
  final String data;

  /// Font configuration to use.
  final FontConfig fontConfig;

  /// Base text style (font family will be overridden by [fontConfig]).
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Maximum number of lines.
  final int? maxLines;

  /// Overflow behavior.
  final TextOverflow? overflow;

  /// Whether to soft-wrap the text.
  final bool? softWrap;

  /// Explicit text direction override. If null, inherits from [Directionality].
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = fontConfig.textStyleFor(
      context,
      base: style ?? const TextStyle(),
    );
    return Text(
      data,
      style: resolvedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
    );
  }
}
