import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter/material.dart' as fl;

/// A backwards-compatible alias for [Tooltip].
typedef NashTooltip = Tooltip;

/// A modern tooltip with custom styling, positioning and actions.
class Tooltip extends StatelessWidget {
  const Tooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = true,
    this.background,
    this.textColor,
    this.icon,
    this.borderRadius = 8,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.waitDuration = const Duration(milliseconds: 400),
    this.verticalOffset = 24,
  });

  /// Tooltip message.
  final String message;

  /// The widget that triggers the tooltip.
  final Widget child;

  /// Whether to show below the child (otherwise above).
  final bool preferBelow;

  /// Tooltip background color.
  final Color? background;

  /// Tooltip text color.
  final Color? textColor;

  /// Optional leading icon.
  final IconData? icon;

  /// Corner radius.
  final double borderRadius;

  /// Margin around the tooltip.
  final EdgeInsets margin;

  /// Inner padding.
  final EdgeInsets padding;

  /// Hover duration before showing.
  final Duration waitDuration;

  /// Vertical offset from the child.
  final double verticalOffset;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg = background ?? scheme.inverseSurface;

    return fl.Tooltip(
      message: message,
      waitDuration: waitDuration,
      verticalOffset: verticalOffset,
      margin: margin,
      padding: padding,
      textStyle: TextStyle(
        color: textColor ?? scheme.onInverseSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      richMessage: icon == null
          ? null
          : WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  icon,
                  size: 14,
                  color: textColor ?? scheme.onInverseSurface,
                ),
              ),
            ),
      preferBelow: preferBelow,
      child: child,
    );
  }
}

/// An info icon that shows a tooltip with an optional title.
class InfoHint extends StatelessWidget {
  const InfoHint({
    super.key,
    required this.message,
    this.icon = Icons.help_outline_rounded,
    this.color,
    this.size = 16,
  });

  /// Hint message.
  final String message;

  /// Hint icon.
  final IconData icon;

  /// Icon color.
  final Color? color;

  /// Icon size.
  final double size;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: message,
        child: InkResponse(
          radius: 20,
          onTap: () {
            final OverlayState? overlay = Overlay.maybeOf(context);
            if (overlay != null) {
              _showTapHint(context, message);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(
              icon,
              size: size,
              color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );

  void _showTapHint(BuildContext context, String message) {
    final OverlayState overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.sizeOf(context).height * 0.4,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }
}
