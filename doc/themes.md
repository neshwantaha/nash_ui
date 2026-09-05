# Themes

`NTheme` is the theme factory for the design system. It builds complete,
production-ready Material 3 `ThemeData` instances from a seed color, and exposes
every custom token through `NashThemeExtension`.

## Factories

| Factory | Description |
| --- | --- |
| `NashTheme.light()` | Light theme from the brand palette. |
| `NashTheme.dark()` | Dark theme from the brand palette. |
| `NashTheme.amoled()` | True-black (AMOLED) dark theme. |
| `NashTheme.custom(colorScheme: ...)` | Fully custom theme from any `ColorScheme`. |

All factories accept:

- `seedColor` — brand seed used by `ColorScheme.fromSeed`.
- `fontFamily` — optional custom font family.
- `useGoogleFonts` — enable/disable Google Fonts text theme (default `true`).
- `extension` — optional custom `NashThemeExtension`.

## Usage

```dart
MaterialApp(
  title: 'My App',
  theme: NashTheme.light(seedColor: const Color(0xFF0EA5E9)),
  darkTheme: NashTheme.dark(seedColor: const Color(0xFF0EA5E9)),
  themeMode: ThemeMode.system,
)
```

## AMOLED

```dart
MaterialApp(
  theme: NashTheme.amoled(),
  darkTheme: NashTheme.amoled(),
  themeMode: ThemeMode.system,
)
```

The AMOLED factory forces surfaces toward true black for OLED displays.

## Custom theme

```dart
final ColorScheme scheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF7C3AED),
  brightness: Brightness.light,
);

MaterialApp(theme: NashTheme.custom(colorScheme: scheme));
```

## Runtime tokens

Read design-system tokens from any build context:

```dart
final NashThemeExtension tokens = NashThemeExtension.of(context);

final Color primary = tokens.primary ?? Theme.of(context).colorScheme.primary;
final Gradient brand = tokens.brandGradient ?? AppGradients.brand;
```

## Component theming

`NashTheme._build()` styles every Material component for the brand — including
`AppBarTheme`, `CardThemeData`, button themes, `InputDecorationTheme`,
`NavigationBarTheme`, `NavigationRailTheme`, `ChipThemeData`, `SnackBarTheme`,
`DialogThemeData`, `SwitchThemeData`, `CheckboxThemeData`, `RadioThemeData`,
`DataTableTheme`, `TooltipTheme` and `PageTransitionsTheme`.
