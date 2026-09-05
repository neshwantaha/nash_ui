# Animations

The animation library provides production-ready motion primitives built on the
Flutter animation framework. All animations respect `MediaQuery.disableAnimations`
and use the design-system `AppDuration` and `AppCurves` tokens.

## Transitions

Wrap any widget to animate its appearance:

```dart
FadeAnimation(duration: AppDuration.normal, child: ...);   // opacity fade-in
SlideAnimation(duration: AppDuration.normal, child: ...);  // slide-up + fade
ScaleAnimation(duration: AppDuration.normal, child: ...);  // scale-in + fade
RotateAnimation(degrees: 180, child: ...);               // rotate-in
```

## Attention effects

```dart
Bounce(amplitude: 0.08, child: ...);  // continuous bounce
Shake(duration: AppDuration.normal, child: ...); // horizontal shake
NashRipple(radius: 16, child: ...);       // ink ripple on mount
HoverEffect(scale: 1.05, child: ...);       // interactive hover/scale
```

## Interactive widgets

```dart
NAnimatedButton(
  onPressed: onTap,
  child: const PrimaryButton(label: 'Save'),
);
```

## Page transitions

```dart
Navigator.of(context).push(
  NashPageRoute(page: const DetailPage()),
);
```

`NTransitioNashSwitcher` cross-fades between child snapshots, and
`NSharedAxisTransition` animates shared elements between screens.

## Containers

```dart
NAnimatedContainer(
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppRadius.large),
  ),
  child: ...,
);
```
