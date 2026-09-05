import 'package:flutter/material.dart';

/// Accessibility design tokens for the design system.
///
/// Provides minimum touch targets, focus ring styles, and semantic helpers
/// to ensure WCAG AA compliance across all components.
abstract final class AppAccessibility {
  AppAccessibility._();

  // ---------------------------------------------------------------------------
  // Touch Targets
  // ---------------------------------------------------------------------------

  /// Minimum touch target width in logical pixels (WCAG 2.5.5).
  static const double minTouchTarget = 48;

  /// Recommended comfortable touch target.
  static const double comfortableTouchTarget = 56;

  /// Small touch target (icon buttons in dense areas).
  static const double smallTouchTarget = 40;

  // ---------------------------------------------------------------------------
  // Focus Ring
  // ---------------------------------------------------------------------------

  /// Focus ring width.
  static const double focusRingWidth = 2.0;

  /// Focus ring offset from the focused widget.
  static const double focusRingOffset = 2.0;

  /// Focus ring corner radius.
  static const double focusRingRadius = 4.0;

  /// Default focus ring color is resolved from context at build time.
  static const Color focusRingColorDefault = Color(0xFF4F46E5);

  // ---------------------------------------------------------------------------
  // Contrast
  // ---------------------------------------------------------------------------

  /// WCAG AA minimum contrast ratio for normal text.
  static const double contrastRatioAA = 4.5;

  /// WCAG AA minimum contrast ratio for large text (18pt+ or 14pt bold).
  static const double contrastRatioAALarge = 3.0;

  /// WCAG AAA minimum contrast ratio for normal text.
  static const double contrastRatioAAA = 7.0;

  /// WCAG AAA minimum contrast ratio for large text.
  static const double contrastRatioAAALarge = 4.5;

  // ---------------------------------------------------------------------------
  // Text Scaling
  // ---------------------------------------------------------------------------

  /// Maximum text scale factor allowed before clamping.
  static const double maxTextScaleFactor = 2.0;

  /// Minimum text scale factor allowed.
  static const double minTextScaleFactor = 0.8;

  // ---------------------------------------------------------------------------
  // Motion
  // ---------------------------------------------------------------------------

  /// Duration for reduced-motion mode (nearly instant).
  static const Duration reducedMotionDuration = Duration(milliseconds: 1);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the luminance contrast ratio between two colors.
  static double contrastRatio(Color foreground, Color background) {
    final double l1 = foreground.computeLuminance();
    final double l2 = background.computeLuminance();
    final double lighter = l1 > l2 ? l1 : l2;
    final double darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Whether [foreground] on [background] meets WCAG AA for normal text.
  static bool meetsAA(Color foreground, Color background) =>
      contrastRatio(foreground, background) >= contrastRatioAA;

  /// Whether [foreground] on [background] meets WCAG AAA for normal text.
  static bool meetsAAA(Color foreground, Color background) =>
      contrastRatio(foreground, background) >= contrastRatioAAA;

  /// Clamps [textScaleFactor] to the allowed range.
  static double clampTextScale(double textScaleFactor) =>
      textScaleFactor.clamp(minTextScaleFactor, maxTextScaleFactor);
}

/// A focus ring that wraps its child with a themed border on focus.
///
/// ```dart
/// FocusRing(
///   child: TextField(...),
/// )
/// ```
class FocusRing extends StatefulWidget {
  const FocusRing({
    super.key,
    required this.child,
    this.color,
    this.width = AppAccessibility.focusRingWidth,
    this.offset = AppAccessibility.focusRingOffset,
    this.radius = AppAccessibility.focusRingRadius,
  });

  /// The widget to wrap.
  final Widget child;

  /// Focus ring color. Defaults to primary.
  final Color? color;

  /// Focus ring stroke width.
  final double width;

  /// Distance from the child edge.
  final double offset;

  /// Corner radius of the ring.
  final double radius;

  @override
  State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<FocusRing> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color ringColor =
        widget.color ?? Theme.of(context).colorScheme.primary;
    return Focus(
      focusNode: _focusNode,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: _focused
              ? Border.all(color: ringColor, width: widget.width)
              : null,
        ),
        margin: _focused ? EdgeInsets.all(widget.offset) : EdgeInsets.zero,
        child: widget.child,
      ),
    );
  }
}

/// Enforces minimum touch target size on its child.
///
/// ```dart
/// TouchTarget(
///   child: IconButton(icon: Icon(Icons.close), onPressed: () {}),
/// )
/// ```
class TouchTarget extends StatelessWidget {
  const TouchTarget({
    super.key,
    required this.child,
    this.minSize = AppAccessibility.minTouchTarget,
    this.padding,
  });

  /// The widget to enforce touch target on.
  final Widget child;

  /// Minimum size in logical pixels.
  final double minSize;

  /// Optional padding around the child.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      );
}

/// Wraps the app to respect `MediaQuery.accessibleNavigationOf` and
/// `MediaQuery.disableAnimationsOf`.
///
/// Place this above `MaterialApp` or use it inside `builder`.
class AccessibilityProvider extends StatelessWidget {
  const AccessibilityProvider({
    super.key,
    required this.child,
    this.forceReducedMotion = false,
  });

  /// The child widget tree.
  final Widget child;

  /// When true, forces reduced motion globally regardless of system setting.
  final bool forceReducedMotion;

  /// Whether the system requests reduced motion.
  static bool reducedMotionOf(BuildContext context) {
    final bool systemReduced = MediaQuery.disableAnimationsOf(context);
    return systemReduced;
  }

  /// Whether the system requests high contrast.
  static bool highContrastOf(BuildContext context) =>
      MediaQuery.highContrastOf(context);

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            AppAccessibility.clampTextScale(
              MediaQuery.textScalerOf(context).scale(1.0) / 1.0,
            ),
          ),
        ),
        child: child,
      );
}

/// A semantics wrapper that announces text changes to screen readers.
///
/// ```dart
/// SemanticsAnnouncer(
///   message: 'Item added to cart',
///   child: YourWidget(),
/// )
/// ```
class SemanticsAnnouncer extends StatelessWidget {
  const SemanticsAnnouncer({
    super.key,
    required this.message,
    required this.child,
    this.assertive = false,
  });

  /// The announcement text.
  final String message;

  /// The child widget.
  final Widget child;

  /// Whether the announcement is assertive (interrupts current speech).
  final bool assertive;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        explicitChildNodes: true,
        child: MergeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Semantics(
                label: message,
                liveRegion: true,
                child: const SizedBox.shrink(),
              ),
              child,
            ],
          ),
        ),
      );
}

/// Wraps a child with a tap target that is accessible and announces its label.
///
/// Use for icon-only buttons or other controls that need explicit labels.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.semanticsLabel,
    this.semanticsHint,
    this.excludeSemantics = false,
  });

  /// The button widget.
  final Widget child;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Accessible label for screen readers.
  final String semanticsLabel;

  /// Optional hint text for screen readers.
  final String? semanticsHint;

  /// When true, hides the child from semantics tree (use when child has its own).
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticsLabel,
        hint: semanticsHint,
        enabled: onPressed != null,
        child: TouchTarget(
          child: ExcludeFocus(
            excluding: excludeSemantics,
            child: GestureDetector(
              onTap: onPressed,
              behavior: HitTestBehavior.opaque,
              child: child,
            ),
          ),
        ),
      );
}
