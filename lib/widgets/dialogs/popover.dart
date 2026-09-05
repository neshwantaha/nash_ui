import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';

/// Alignment placement for [Popover].
enum PopoverPlacement {
  top,
  bottom,
  left,
  right,
}

/// An interactive anchored popover widget that attaches a floating card to a target widget.
class Popover extends StatefulWidget {
  const Popover({
    super.key,
    required this.child,
    required this.popoverContent,
    this.placement = PopoverPlacement.bottom,
    this.triggerMode = PopoverTriggerMode.tap,
    this.barrierDismissible = true,
    this.offset = 8.0,
    this.borderRadius = AppRadius.large,
    this.padding = const EdgeInsets.all(16),
  });

  /// The widget that triggers the popover.
  final Widget child;

  /// The content displayed inside the floating popover card.
  final Widget popoverContent;

  /// Preferred direction placement relative to [child].
  final PopoverPlacement placement;

  /// Whether triggered on click/tap or hover.
  final PopoverTriggerMode triggerMode;

  /// Whether tapping outside dismisses the popover.
  final bool barrierDismissible;

  /// Distance between target and popover.
  final double offset;

  /// Popover card corner radius.
  final double borderRadius;

  /// Inner padding of the popover card.
  final EdgeInsetsGeometry padding;

  @override
  State<Popover> createState() => _PopoverState();
}

/// Trigger action for [Popover].
enum PopoverTriggerMode {
  tap,
  hover,
}

class _PopoverState extends State<Popover> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _hidePopover();
    super.dispose();
  }

  void _togglePopover() {
    if (_isOpen) {
      _hidePopover();
    } else {
      _showPopover();
    }
  }

  void _showPopover() {
    if (_isOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _hidePopover() {
    if (!_isOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Offset offset = Offset(0, widget.offset);
    switch (widget.placement) {
      case PopoverPlacement.top:
        offset = Offset(0, -widget.offset);
        break;
      case PopoverPlacement.bottom:
        offset = Offset(0, widget.offset);
        break;
      case PopoverPlacement.left:
        offset = Offset(-widget.offset, 0);
        break;
      case PopoverPlacement.right:
        offset = Offset(widget.offset, 0);
        break;
    }

    return OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          // Dismiss barrier
          if (widget.barrierDismissible)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hidePopover,
              ),
            ),

          // Floating popover
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: widget.placement == PopoverPlacement.top
                ? Alignment.topCenter
                : widget.placement == PopoverPlacement.bottom
                    ? Alignment.bottomCenter
                    : widget.placement == PopoverPlacement.left
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
            followerAnchor: widget.placement == PopoverPlacement.top
                ? Alignment.bottomCenter
                : widget.placement == PopoverPlacement.bottom
                    ? Alignment.topCenter
                    : widget.placement == PopoverPlacement.left
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
            offset: offset,
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder<double>(
                duration: AppDuration.fast,
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (BuildContext context, double value, Widget? child) =>
                    Transform.scale(
                  scale: 0.95 + (0.05 * value),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                ),
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B1B2E) : Colors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.08),
                    ),
                    boxShadow: AppShadow.floating,
                  ),
                  child: widget.popoverContent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: widget.triggerMode == PopoverTriggerMode.hover
            ? MouseRegion(
                onEnter: (_) => _showPopover(),
                onExit: (_) => _hidePopover(),
                child: widget.child,
              )
            : GestureDetector(
                onTap: _togglePopover,
                child: widget.child,
              ),
      );
}
