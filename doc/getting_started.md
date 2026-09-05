# Getting started

This guide walks through adding `nash_ui` to a Flutter app and
rendering your first screen.

## 1. Add the dependency

Add `nash_ui` from [pub.dev](https://pub.dev/packages/nash_ui):

```bash
flutter pub add nash_ui
```

Or add it directly to your `pubspec.yaml`:

```yaml
dependencies:
  nash_ui: ^1.0.0
```

Run `flutter pub get`.

## 2. Apply a theme

Wrap your app with the design-system theme. All factories accept an optional
`seedColor` and a `useGoogleFonts` flag.

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
      theme: NashTheme.light(),
      darkTheme: NashTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

## 3. Add an optional responsive root

If you want the responsive number extensions (`10.w`, `20.h`, `16.r`, `5.v`) to
scale against a design reference, wrap your app in `AppResponsive`.

```dart
AppResponsive(
  designWidth: 390,
  designHeight: 844,
  child: const MyApp(),
)
```

## 4. Build a screen

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NashAppBar(title: 'Home'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: const <Widget>[
            PrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward,
            ),
            SizedBox(height: AppSpacing.md),
            NashTextField(label: 'Email', hint: 'you@example.com'),
          ],
        ),
      ),
    );
  }
}
```

## 5. Run

```sh
flutter run
```

## Next steps

- Learn about [design tokens](tokens.md).
- Explore the [widget catalog](widgets.md).
- Use the [templates](templates.md) for full screens.
