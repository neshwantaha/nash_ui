import 'dart:async';
import 'package:flutter/material.dart';
import '../../colors/colors.dart';
import '../../radius/app_radius.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Toast Types & Positions
// ─────────────────────────────────────────────────────────────────────────────

/// Visual style of the toast notification.
enum ToastType { success, error, warning, info, neutral }

/// Where on screen the toast appears.
enum ToastPosition { top, bottom, center }

class _ToastEntry {
  const _ToastEntry({
    required this.context,
    required this.message,
    required this.type,
    required this.position,
    required this.duration,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final BuildContext context;
  final String message;
  final ToastType type;
  final ToastPosition position;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Toast — Overlay-based toast independent of Scaffold
// ─────────────────────────────────────────────────────────────────────────────

/// Shows an animated toast notification as an overlay — no Scaffold needed.
///
/// ```dart
/// Toast.show(context, 'Saved successfully', type: ToastType.success);
/// Toast.show(context, 'Connection lost', type: ToastType.error, duration: Duration(seconds: 5));
/// ```
class Toast {
  Toast._();

  static final List<_ToastEntry> _queue = <_ToastEntry>[];
  static bool _showing = false;

  /// Shows a toast notification.
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.neutral,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    _queue.add(_ToastEntry(
      context: context,
      message: message,
      type: type,
      position: position,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      icon: icon,
    ));
    if (!_showing) _processQueue();
  }

  static void _processQueue() async {
    if (_queue.isEmpty) {
      _showing = false;
      return;
    }
    _showing = true;
    final entry = _queue.removeAt(0);
    await _showSingle(entry);
    _processQueue();
  }

  static Future<void> _showSingle(_ToastEntry entry) async {
    if (!entry.context.mounted) return;
    final overlay = Overlay.of(entry.context);
    late OverlayEntry overlayEntry;
    final completer = Completer<void>();

    overlayEntry = OverlayEntry(
      builder: (_) => _ToastWidget(
        entry: entry,
        onDismiss: () {
          if (overlayEntry.mounted) overlayEntry.remove();
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    overlay.insert(overlayEntry);
    await completer.future;
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.entry, required this.onDismiss});
  final _ToastEntry entry;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    final isBottom = widget.entry.position == ToastPosition.bottom;
    _slideAnim = Tween<Offset>(
      begin: Offset(0, isBottom ? 1 : -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _dismissTimer = Timer(widget.entry.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _typeStyle(widget.entry.type);

    return Positioned(
      top: widget.entry.position == ToastPosition.top ? 60 : null,
      bottom: widget.entry.position == ToastPosition.bottom ? 80 : null,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.large),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.entry.icon ?? icon,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.entry.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (widget.entry.actionLabel != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: widget.entry.onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(widget.entry.actionLabel!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Color, IconData) _typeStyle(ToastType type) => switch (type) {
        ToastType.success => (AppColors.success, Icons.check_circle_rounded),
        ToastType.error => (AppColors.error, Icons.error_rounded),
        ToastType.warning => (AppColors.warning, Icons.warning_rounded),
        ToastType.info => (AppColors.primary, Icons.info_rounded),
        ToastType.neutral => (
            const Color(0xFF334155),
            Icons.notifications_rounded
          ),
      };
}
