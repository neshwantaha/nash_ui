import 'package:flutter/widgets.dart' hide LocalizationsDelegate;
import 'package:flutter/widgets.dart' as fl show LocalizationsDelegate;
import 'package:intl/intl.dart';

/// Localization / i18n framework for the design system.
///
/// Provides a lightweight, composable translation system with pluralization,
/// interpolation, date/number formatting and RTL awareness.
///
/// ```dart
/// final AppLocalizations loc = AppLocalizations.of(context);
/// Text(loc.translate('greeting', name: 'World'))
/// ```
class AppLocalizations {
  const AppLocalizations({
    required this.locale,
    required this.translations,
    this.fallbackLocale = const Locale('en'),
  });

  /// The current locale.
  final Locale locale;

  /// Translation map: key → translated string or nested map.
  final Map<String, dynamic> translations;

  /// Fallback locale when a key is missing.
  final Locale fallbackLocale;

  /// Inherited lookup from [BuildContext].
  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? loc =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(loc != null, 'AppLocalizations not found in widget tree.');
    return loc!;
  }

  /// Whether translations exist for the current locale.
  static AppLocalizations? maybeOf(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  /// Translates [key] with optional [params] interpolation.
  ///
  /// Supports dot-notation for nested maps: `'errors.required'`.
  /// Parameters use `{paramName}` placeholders in the translated string.
  String translate(String key, {Map<String, String>? params}) {
    String? value = _resolve(key);
    value ??= _resolve(key, locale: fallbackLocale);
    value ??= key;

    if (params != null) {
      for (final MapEntry<String, String> entry in params.entries) {
        value = value!.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return value!;
  }

  /// Alias for [translate].
  String t(String key, {Map<String, String>? params}) =>
      translate(key, params: params);

  /// Translates and pluralizes based on [count].
  ///
  /// Expects keys `key.one`, `key.other` (and optionally `key.zero`, `key.few`,
  /// `key.many`).
  String plural(
    String key,
    int count, {
    Map<String, String>? params,
  }) {
    final String category = _pluralCategory(count);
    final String resolved = translate('$key.$category', params: params);
    return resolved.replaceAll('{count}', count.toString());
  }

  /// Formats a number according to the current locale.
  String formatNumber(num value, {int? decimalDigits}) => NumberFormat.currency(
        locale: locale.toString(),
        decimalDigits: decimalDigits ?? 0,
        symbol: '',
      ).format(value);

  /// Formats currency with a symbol.
  String formatCurrency(num value, {String? symbol, int decimalDigits = 2}) =>
      NumberFormat.currency(
        locale: locale.toString(),
        symbol: symbol,
        decimalDigits: decimalDigits,
      ).format(value);

  /// Formats a compact number (e.g. 1.2K, 3.4M).
  String formatCompact(num value) =>
      NumberFormat.compact(locale: locale.toString()).format(value);

  /// Formats a date.
  String formatDate(DateTime date, {String pattern = 'yMMMd'}) =>
      DateFormat(pattern, locale.toString()).format(date);

  /// Formats time.
  String formatTime(DateTime date) =>
      DateFormat.Hm(locale.toString()).format(date);

  String? _resolve(String key, {Locale? locale}) {
    final Locale loc = locale ?? this.locale;
    final String langKey = '${loc.languageCode}.$key';

    // Try locale-specific key first.
    if (translations.containsKey(langKey)) {
      return _flatten(translations[langKey]);
    }

    // Try key directly.
    if (translations.containsKey(key)) {
      return _flatten(translations[key]);
    }

    // Try dot-notation nested lookup.
    final List<String> parts = key.split('.');
    dynamic current = translations;
    for (final String part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    return _flatten(current);
  }

  String? _flatten(dynamic value) {
    if (value is String) return value;
    return value?.toString();
  }

  static String _pluralCategory(int count) {
    if (count == 0) return 'zero';
    if (count == 1) return 'one';
    if (count >= 2 && count <= 10) return 'few';
    return 'other';
  }
}

/// Delegate for [AppLocalizations] using [AppLocalizationsDelegate].
class AppLocalizationsDelegate
    extends fl.LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate({
    required this.translations,
    this.supportedLocales = const <Locale>[Locale('en')],
    this.fallbackLocale = const Locale('en'),
  });

  /// Translation data keyed by locale string (e.g. `'en'`, `'ar'`).
  final Map<String, Map<String, dynamic>> translations;

  /// List of supported locales.
  final List<Locale> supportedLocales;

  /// Fallback locale.
  final Locale fallbackLocale;

  @override
  bool isSupported(Locale locale) =>
      translations.containsKey(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final Map<String, dynamic> data = translations[locale.languageCode] ??
        translations[fallbackLocale.languageCode] ??
        {};
    return AppLocalizations(
      locale: locale,
      translations: data,
      fallbackLocale: fallbackLocale,
    );
  }

  @override
  bool shouldReload(fl.LocalizationsDelegate<AppLocalizations> old) => false;
}

/// Convenience extension for translating strings directly.
extension LocalizationsX on BuildContext {
  /// Access the [AppLocalizations] instance.
  AppLocalizations get loc => AppLocalizations.of(this);

  /// Translate a key.
  String translate(String key, {Map<String, String>? params}) =>
      loc.translate(key, params: params);

  /// Translate with pluralization.
  String plural(String key, int count, {Map<String, String>? params}) =>
      loc.plural(key, count, params: params);
}
