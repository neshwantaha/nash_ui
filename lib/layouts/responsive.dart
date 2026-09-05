import 'package:flutter/material.dart';

import '../responsive/responsive_layout.dart';
import '../responsive/screen_type.dart';

/// An adaptive layout builder that swaps content by [AppScreenType].
///
/// ```dart
/// AppResponsiveLayout(
///   phone: const LoginForm(compact: true),
///   tablet: const LoginForm(),
///   desktop: const CenteredLoginForm(),
/// )
/// ```
class AppResponsiveLayout extends StatelessWidget {
  const AppResponsiveLayout({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  /// Shown on phone-sized screens.
  final Widget phone;

  /// Shown on tablet-sized screens (falls back to [phone]).
  final Widget? tablet;

  /// Shown on desktop-sized screens (falls back to [tablet] then [phone]).
  final Widget? desktop;

  /// Builds the right variant for [screenType].
  Widget buildFor(AppScreenType type) {
    switch (type) {
      case AppScreenType.phone:
        return phone;
      case AppScreenType.tablet:
        return tablet ?? phone;
      case AppScreenType.desktop:
        return desktop ?? tablet ?? phone;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            buildFor(screenTypeFor(constraints.maxWidth)),
      );
}

/// Calls [builder] with the current [AppScreenType].
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.builder,
  });

  /// Builds content from the current [AppScreenType].
  final Widget Function(BuildContext context, AppScreenType type) builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            builder(context, screenTypeFor(constraints.maxWidth)),
      );
}

/// A content-width centering wrapper for desktop layouts.
class ContentBox extends StatelessWidget {
  const ContentBox({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.horizontalPadding = 24,
  });

  /// The content.
  final Widget child;

  /// Maximum content width.
  final double maxWidth;

  /// Horizontal padding applied at the edges.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: child,
          ),
        ),
      );
}
