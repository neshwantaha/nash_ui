# Nash UI

[![pub package](https://img.shields.io/pub/v/nash_ui.svg)](https://pub.dev/packages/nash_ui)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.27.0-02569B?logo=flutter)](https://flutter.dev)

A modern, scalable, production-ready **Flutter Design System** built on **Material 3**.

`nash_ui` provides an opinionated design-token engine, theme factories, a responsive framework, an animation library, a complete catalog of reusable widgets, and full-screen UI templates — everything you need to ship beautiful, consistent apps faster.

---

## Features

- **Design tokens** — colors, typography, spacing, radius, shadows, gradients, borders, opacity, dimensions, icons, durations, curves, elevation, and image tokens.
- **Theme engine** — `AppTheme.light()`, `AppTheme.dark()`, `AppTheme.amoled()` and fully custom themes via a `ThemeExtension`.
- **Responsive framework** — `AppResponsive`, screen types, breakpoints and responsive number extensions (`10.w`, `20.h`, `16.r`, `5.v`).
- **Animation library** — fade, slide, scale, rotate, bounce, shake, ripple, hover, hero, page and shared-axis transitions, with reduced motion support.
- **Accessibility** — WCAG AA/AAA compliance tokens, focus ring, touch targets, semantic announcements, and platform-adaptive widgets.
- **Widget catalog** — buttons, inputs, cards, selection, media, feedback, lists, indicators, dialogs, charts, loading states, drag & drop, signature pad, watermark, countdown timers, sticky headers, accordion, syntax highlighting, markdown, and misc widgets.
- **Navigation** — bottom navigation, navigation rail, drawer, top navigation and breadcrumb.
- **Localization** — number, currency, date, time, and compact formatting.
- **Full-screen templates** — login, register, forgot password, dashboard, settings, profile, chat, learning, finance, medical, e-commerce, social, admin and analytics.
- **Services & Utilities** — network client (`AppNetwork`), biometric auth (`AppBiometrics`), permissions (`AppPermissions`), notifications (`AppNotifications`), `Debouncer`, `Throttler`, validators, formatters, and color/date helpers.
- **Quality** — fully documented public API, unit/widget/golden tests and a GitHub Actions CI/CD workflow.

## Getting started

### Add the dependency

From [pub.dev](https://pub.dev/packages/nash_ui):

```bash
flutter pub add nash_ui
```

Or add it directly to your `pubspec.yaml`:

```yaml
dependencies:
  nash_ui: ^2.11.8
```
Then run:

```sh
flutter pub get
```

### Quick start

```dart
import 'package:flutter/material.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const <Widget>[
            PrimaryButton(
              label: 'Get started',
              icon: Icons.rocket_launch_outlined,
            ),
            Gap(16),
            AppTextField(label: 'Email', hint: 'you@example.com'),
          ],
        ),
      ),
    );
  }
}
```

## Themes

Every theme factory is built from a seed color using the Material 3 color system.

| Theme | Description |
| --- | --- |
| `AppTheme.light()` | Default light theme from the brand palette. |
| `AppTheme.dark()` | Dark theme from the brand palette. |
| `AppTheme.amoled()` | True-black (AMOLED) theme. |
| `AppTheme.custom(colorScheme: ...)` | Fully custom theme from any `ColorScheme`. |

```dart
MaterialApp(
  theme: AppTheme.light(seedColor: const Color(0xFF10B981)),
  darkTheme: AppTheme.dark(seedColor: const Color(0xFF10B981)),
  themeMode: ThemeMode.system,
)
```

See [Themes](doc/themes.md) for details on tokens and customization.

## Responsive

```dart
final AppScreenType type = AppResponsive.screenTypeOf(context);
if (type.isDesktop) {
  return const NavDrawer(...);
}
return const BottomNavBar(...);
```

For pixel-perfect scaling against a design reference:

```dart
AppResponsive(
  designWidth: 390,
  designHeight: 844,
  child: const MyApp(),
)
```

See [Responsive](doc/responsive.md) for the full breakpoint reference.

## Widget catalog

| Category | Widgets |
| --- | --- |
| Buttons | `PrimaryButton`, `SecondaryButton`, `OutlineButton`, `AppTextButton`, `AppIconButton`, `FloatingButton`, `LoadingButton`, `NeonButton`, `GlassButton`, `GradientBorderButton`, `SlideButton`, `SplitButton`, `HoldButton`, `SocialButton`, `ButtonGroup`, `SpeedDial` |
| Inputs | `AppTextField`, `PasswordField`, `EmailField`, `NumberField`, `PhoneField`, `SearchField`, `OtpField`, `OtpPinField`, `MentionField`, `AppDropdown`, `DateField`, `MultiSelect`, `GradientPicker`, `TimelinePicker`, `RichTextEditor` |
| Forms | `Form`, `FormTextField`, `FormWizard`, `ReactiveField`, `ReactiveFormController` || Selection | `AppCheckbox`, `AppRadio`, `AppSwitch`, `AppChip`, `SegmentedButton` |
| Cards | `AppCard`, `CreditCardWidget`, `BoardingPassCard`, `GlassmorphicContainer`, `ParallaxCard`, `ReceiptCard`, `PriceTag`, `InboxCard`, `LocationPinCard`, `CornerRibbon`, `DashboardCard`, `ProductCard`, `UserCard`, `MedicalCard`, `LearningCard`, `SwipeActionCard` |
| Media | `VoiceNotePlayer`, `EqualizerWidget`, `AudioWaveform`, `BeforeAfterImage`, `CameraCapture`, `ProductImageZoom`, `MagnifierLens`, `AppAvatar`, `AppImage`, `AppNetworkImage` |
| Feedback | `AppSnackbar`, `AppBanner`, `AppTooltip`, `PushNotificationCard`, `ConfettiWidget`, `NotificationCenter` |
| Navigation | `AppNavigationRail`, `BottomNavBar`, `NavDrawer`, `Breadcrumb`, `CustomAppBar`, `AppTabBar` |
| Dialogs | `AppDialog`, `NumberPadDialog`, `AppRatingDialog`, `AppBottomSheet`, `ActionSheet`, `AppPopupMenu`, `AdaptiveDialog`, `AdaptiveActionSheet` |
| Charts | `LineChart`, `BarChart`, `PieChart`, `CandlestickChart`, `BubbleChart`, `TreeMapChart`, `SparklineWidget`, `RadarChart`, `FunnelChart`, `HeatMap`, `GanttChart` |
| Loading | `AppLoader`, `LiquidProgressBar`, `CircularProgress`, `LinearProgress`, `Skeleton`, `SkeletonList`, `SkeletonGrid`, `Shimmer`, `LoadingScreen` |
| Indicators | `AppBadge`, `Gap`, `DistanceBar`, `NetworkStatusBar`, `TypingIndicator`, progress indicators |
| Data | `EnhancedDataTable`, `TablePagination`, `DraggableDashboard`, `DraggableList`, `DropZone`, `DraggableWidget` |
| Pickers | `showStyledTimePicker`, `showDateRangeDialog`, `showDurationPicker`, `showTimeRangePicker`, `ReactionPicker` |
| Stepper | `AppStepper` (horizontal/vertical), `DeliveryTracker`, `AppStepState` |
| Adaptive | `AdaptiveScaffold`, `AdaptiveSwitch`, `AdaptiveProgress`, `AppPlatform` |
| Accessibility | `AppFocusRing`, `AppTouchTarget`, `AppAccessibilityProvider`, `AppSemanticsAnnouncer`, `AppAccessibleButton` |
| Misc | `WheelOfFortune`, `FloatingParticles`, `GradientText`, `AnimatedTextKit`, `AnimatedCounter`, `ScratchReveal`, `ScratchCard`, `MiniMap`, `OnboardingOverlay`, `PatternLock`, `SecurityPinKeyboard`, `BiometricButton`, `ThemeSwitcherFab`, `JsonViewer`, `DebugOverlay`, `GestureHintOverlay`, `PermissionRequestCard`, `SignaturePad`, `Watermark`, `CountDownTimer`, `StopWatch`, `StickyHeaderList`, `Accordion`, `SyntaxHighlighter`, `MarkdownText`, `PollWidget`, `QrCodeWidget`, `BarcodeWidget`, `AppCalendar`, `AppRating`, `AppTimeline`, `AppTag`, `AppMasonry` |
| UX screens | `UpdateRequiredScreen`, Loading, empty state, no internet, 404, error, success, maintenance, permission, update required |

See [Widgets](doc/widgets.md) for the full API reference.

## Templates

Full-screen, production-ready layouts:

`AuthTemplates.login`, `AuthTemplates.signup`, `AuthTemplates.forgotPassword`,
`DashboardHeader`, `SettingsTemplate`, `ProfileTemplate`, `ChatTemplate`,
`LearningTemplate`, `FinanceTemplate`, `MedicalTemplate`,
`EcommerceTemplate`, `SocialTemplate`, `AdminTemplate`, `AnalyticsTemplate`.

See [Templates](doc/templates.md).

## Utilities

Validators (`Validators`), formatters (`AppFormatter`), and helpers for dates,
colors, numbers, animations, files, images, permissions and devices.
See [Utilities](doc/utilities.md).

## Documentation

| Guide | Description |
| --- | --- |
| [Getting started](doc/getting_started.md) | Setup, dependency and first app |
| [Design tokens](doc/tokens.md) | Colors, typography, spacing, radius, shadows |
| [Themes](doc/themes.md) | Light/dark/AMOLED/custom themes |
| [Responsive](doc/responsive.md) | Breakpoints and screen helpers |
| [Animations](doc/animations.md) | Motion library reference |
| [Widgets](doc/widgets.md) | Widget catalog with examples |
| [Templates](doc/templates.md) | Full-screen template layouts |
| [Utilities](doc/utilities.md) | Validators, formatters and helpers |
| [Testing](doc/testing.md) | Unit, widget, golden and integration tests |

## Example application

A complete demo app is included under [`example/`](example) showcasing theme
switching, responsive preview, the animation gallery, the widget catalog,
forms, charts, a dashboard and the template gallery.

```sh
cd example
flutter run
```

## Testing

```sh
flutter analyze
flutter test                # unit + widget + golden tests
flutter test --update-goldens test/golden_test.dart   # refresh golden images

cd example
flutter test integration_test/app_test.dart -d windows  # integration tests
```

See [Testing](doc/testing.md).

## License
 
Nash UI is licensed under the **BSD 3-Clause License**.
 
Copyright &copy; 2026 Nashwan Taha Nheli. All rights reserved.
 
See the [LICENSE](LICENSE) file for the complete terms and conditions.
