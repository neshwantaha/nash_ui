# Design tokens

Design tokens are the single source of truth for visual style. Every widget in
the design system consumes these tokens, so customizing a token re-skins the
whole library.

All tokens are exported from `package:nash_ui/nash_ui.dart`.

## Colors

`AppColors` exposes the brand palette, semantic colors and neutral scales.

```dart
AppColors.primary;        // brand primary
AppColors.secondary;      // brand secondary
AppColors.error;          // semantic error
AppColors.success;        // semantic success
AppColors.warning;        // semantic warning
AppColors.info;           // semantic info
AppColors.surface;        // light surface
AppColors.surfaceDark;    // dark surface
AppColors.amoled;         // true-black surface
AppColors.neutral[50];    // neutral scale 50–900
```

Color extensions add convenient helpers:

```dart
Color c = const Color(0xFF4F46E5);
c.withOpacity(0.5);   // clamp-safe opacity
c.lighten();          // lighten toward white
c.darken();           // darken toward black
c.mixWith(other);     // blend toward another color
c.toHex();            // '#4f46e5' (lowercase)
ColorUtils.toHex(c);  // '#4F46E5' (uppercase)
```

## Typography

`AppTypography.build()` produces a complete Material 3 `TextTheme`. The theme
engine applies it automatically; you can opt out of Google Fonts with
`NashTheme.light(useGoogleFonts: false)`.

```dart
final TextTheme tt = Theme.of(context).textTheme;
Text('Title', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700));
```

`AppFontWeight` provides named weights (`regular`, `medium`, `semibold`, `bold`).

## Spacing

`AppSpacing` defines a consistent spacing scale:

```dart
AppSpacing.xs;    // 4
AppSpacing.sm;    // 8
AppSpacing.md;    // 12
AppSpacing.lg;    // 16
AppSpacing.xl;    // 20
AppSpacing.xxl;   // 24
AppSpacing.xxxl;  // 32
AppSpacing.huge;  // 40
```

## Radius

`AppRadius` defines the corner scale:

```dart
AppRadius.small;       // 8
AppRadius.medium;      // 12
AppRadius.large;       // 16
AppRadius.extraLarge;  // 24
AppRadius.circular;    // 1000 (pills)
```

## Shadows

`AppShadow` provides elevation presets:

```dart
AppShadow.soft;       // subtle card shadow
AppShadow.medium;     // medium elevation
AppShadow.strong;     // strong elevation
AppShadow.glass;      // floating glass surface
AppShadow.floating;   // prominent floating elevation
AppShadow.glow;       // brand glow
AppShadow.card;       // card default (= medium)
AppShadow.brand;      // primary glow used by primary buttons
```

## Gradients

`AppGradients` provides reusable gradients:

```dart
AppGradients.brand;     // primary → secondary
AppGradients.primary;   // primary → primaryLight
AppGradients.secondary; // secondary → cyan
AppGradients.success;   // success → emerald
AppGradients.warning;   // warning → amber
AppGradients.danger;    // error → red
```

## More tokens

- `AppDuration` — animation durations (`micro`, `fast`, `normal`, `slow`, `verySlow`)
- `AppCurves` — animation curves
- `AppDimensions` — standard dimensions
- `AppOpacity` — opacity levels
- `AppBorderRadius` / border helpers
- `NIcons` — curated icon constants

## Theme extension

All custom tokens are available at runtime through `NashThemeExtension`:

```dart
final NashThemeExtension tokens = NashThemeExtension.of(context);
tokens.primary;         // brand primary
tokens.brandGradient;   // brand gradient
tokens.appBarStyle;     // app bar styling
tokens.surface;         // theme surface
```
