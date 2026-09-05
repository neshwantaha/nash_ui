import 'dart:async';

import 'package:flutter/material.dart';

/// A lightweight toast notification that slides in and auto-dismisses.
///
/// Call [AppToast.show] to display a toast on top of the current route:
///
/// ```dart
/// AppToast.show(
///   context,
///   message: 'Saved successfully!',
///   icon: Icons.check_circle,
///   type: AppToastType.success,
/// );
/// ```
class AppToast extends StatefulWidget {
  const AppToast({
    super.key,
    required this.message,
    this.icon,
    this.type = AppToastType.info,
    this.duration = const Duration(seconds: 3),
    this.position = AppToastPosition.bottom,
    this.action,
    this.actionLabel,
  });

  /// Message text to display.
  final String message;

  /// Optional leading icon.
  final IconData? icon;

  /// Semantic type that determines the default color scheme.
  final AppToastType type;

  /// How long to show the toast before auto-dismissing.
  final Duration duration;

  /// Where on the screen to show the toast.
  final AppToastPosition position;

  /// Callback for the optional action button.
  final VoidCallback? action;

  /// Label of the optional action button.
  final String? actionLabel;

  /// Shows a toast over the current [context].
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(seconds: 3),
    AppToastPosition position = AppToastPosition.bottom,
    VoidCallback? action,
    String? actionLabel,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AppToast(
        message: message,
        icon: icon,
        type: type,
        duration: duration,
        position: position,
        action: action,
        actionLabel: actionLabel,
      ),
    );
    overlay.insert(entry);
    Timer(duration + const Duration(milliseconds: 400), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  State<AppToast> createState() => _AppToastState();
}

/// Toast color / icon semantic.
enum AppToastType { info, success, warning, error }

/// Where the toast appears on screen.
enum AppToastPosition { top, bottom }

class _AppToastState extends State<AppToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final dy = widget.position == AppToastPosition.bottom ? 1.0 : -1.0;
    _slide = Tween<Offset>(
      begin: Offset(0, dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);

    _ctrl.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() async {
    if (mounted) await _ctrl.reverse();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  (Color bg, Color fg, IconData defaultIcon) _scheme() => switch (widget.type) {
        AppToastType.success => (
            const Color(0xFF1B5E20),
            const Color(0xFFA5D6A7),
            Icons.check_circle_rounded
          ),
        AppToastType.warning => (
            const Color(0xFF4E342E),
            const Color(0xFFFFCC80),
            Icons.warning_rounded
          ),
        AppToastType.error => (
            const Color(0xFF4A0000),
            const Color(0xFFEF9A9A),
            Icons.error_rounded
          ),
        _ => (
            const Color(0xFF1A237E),
            const Color(0xFF90CAF9),
            Icons.info_rounded
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, defaultIcon) = _scheme();
    final icon = widget.icon ?? defaultIcon;

    final align = widget.position == AppToastPosition.bottom
        ? Alignment.bottomCenter
        : Alignment.topCenter;
    final edgePadding = widget.position == AppToastPosition.bottom
        ? const EdgeInsets.only(bottom: 32)
        : const EdgeInsets.only(top: 48);

    return Positioned.fill(
      child: Align(
        alignment: align,
        child: Padding(
          padding: edgePadding + const EdgeInsets.symmetric(horizontal: 16),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: fg, size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: TextStyle(color: fg, fontSize: 14),
                        ),
                      ),
                      if (widget.action != null &&
                          widget.actionLabel != null) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: widget.action,
                          style: TextButton.styleFrom(
                            foregroundColor: fg,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            widget.actionLabel!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
