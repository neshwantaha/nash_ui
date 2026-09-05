# Responsive

The responsive framework classifies the current width into a `AppScreenType` and
provides pixel-perfect scaling against a design reference.

## Screen types

`AppScreenType` is one of:

| Type | Range | 
| --- | --- |
| `AppScreenType.phone` | `< 600dp` |
| `AppScreenType.tablet` | `600 – 1024dp` |
| `AppScreenType.desktop` | `> 1024dp` |

Helpers: `isPhone`, `isTablet`, `isDesktop`.

## Reading the screen type

Wrap your app with `AppResponsive`, then read the type anywhere below it:

```dart
AppResponsive(
  designWidth: 390,
  designHeight: 844,
  child: const MyApp(),
)
```

```dart
final AppScreenType type = AppResponsive.screenTypeOf(context);

if (type.isDesktop) {
  return const NashSidebar(...);
}
return const BottomNavBar(...);
```

You can also classify an arbitrary width:

```dart
final AppScreenType type = screenTypeFor(900); // AppScreenType.tablet
```

## Breakpoints

`AppBreakpoint` exposes both the framework breakpoints and Material's layout
cutoffs:

```dart
AppBreakpoint.phone;    // 600
AppBreakpoint.tablet;   // 1024
AppBreakpoint.compact;  // 600
AppBreakpoint.medium;   // 840
AppBreakpoint.expanded; // 1200
```

## Scaling extensions

When the app is wrapped in `AppResponsive`, these extensions scale values against
the design reference:

```dart
10.w;   // width-scaled (screen width / design width)
20.h;   // height-scaled (screen height / design height)
16.r;   // radius-scaled using the width factor
5.v;    // vertical margin scaled using the height factor
```

The scale factors fall back to `1.0` when no `AppResponsive` ancestor exists.
