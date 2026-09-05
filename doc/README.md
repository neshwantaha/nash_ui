# Nash Design System Documentation

Welcome to the `nash_ui` documentation.

## Guides

| Guide | Description |
| --- | --- |
| [Getting started](getting_started.md) | Setup, dependency and first app |
| [Design tokens](tokens.md) | Colors, typography, spacing, radius, shadows, gradients |
| [Themes](themes.md) | Light, dark, AMOLED and custom themes |
| [Responsive](responsive.md) | Breakpoints, screen types and scaling |
| [Animations](animations.md) | Motion library reference |
| [Widgets](widgets.md) | Widget catalog with usage examples |
| [Templates](templates.md) | Full-screen template layouts |
| [Utilities](utilities.md) | Validators, formatters and helpers |
| [Testing](testing.md) | Unit, widget, golden and integration tests |

## Quick reference

```dart
import 'package:nash_ui/nash_ui.dart';
```

- Theme: `NashTheme.light()`, `NashTheme.dark()`, `NashTheme.amoled()`, `NashTheme.custom(...)`
- Responsive: `AppResponsive`, `AppScreenType`, `AppBreakpoint`
- Tokens: `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadow`, `AppGradients`
- Animations: `FadeAnimation`, `SlideAnimation`, `ScaleAnimation`, `RotateAnimation`, `Bounce`, `Shake`, `NashRipple`, `HoverEffect`, `HeroWidget`
