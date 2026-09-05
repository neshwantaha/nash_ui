# Testing

The package ships unit, widget, golden and integration tests.

## Running the suite

```sh
flutter analyze
flutter test
```

## Unit tests

Cover validators, formatters, utilities and extensions:

- `test/validators_test.dart`
- `test/formatter_test.dart`
- `test/utils_test.dart`
- `test/extensions_test.dart`

Date-formatting tests initialize the `en_US` locale through the shared helper
`test/helpers.dart` (`initDateFormats()`), so they are deterministic on every
platform.

## Widget tests

Each widget category has a dedicated suite:

- `test/widgets_inputs_test.dart` — text/password/email/otp/search fields
- `test/widgets_cards_test.dart` — base, gradient, product, statistic cards
- `test/widgets_feedback_test.dart` — snackbar, toast, banner
- `test/widgets_misc_test.dart` — calendar, stepper, tags, timeline
- `test/widgets_navigation_test.dart` — rail, sidebar, bottom nav, drawer, app bar
- `test/widgets_templates_test.dart` — full-screen templates
- `test/widgets_smoke_test.dart` — end-to-end smoke renders

## Golden tests

`test/golden_test.dart` uses `golden_toolkit` and captures canonical images of
buttons, forms, cards, navigation components and the token showcase.

```sh
flutter test --update-goldens test/golden_test.dart   # regenerate
flutter test test/golden_test.dart                    # compare
```

Golden images are stored in `test/goldens/`. `loadAppFonts()` guarantees
identical font rendering on every OS, so images generated on one machine match
CI.

## Integration tests

`example/integration_test/app_test.dart` boots a full demo app (theme switching,
forms, buttons, cards and the calendar) on a device:

```sh
cd example
flutter test integration_test/app_test.dart -d windows
```

These require a real device or emulator and are intentionally not part of the
default `flutter test` run. CI runs them on a Windows desktop runner
(`windows-latest`).
