import 'package:flutter/material.dart';

/// A widget that reveals hidden top content (e.g. search bar, quick actions, stats)
/// when the user pulls down past the top scroll boundary.
///
/// ```dart
/// PullToReveal(
///   revealedChild: QuickSearchBar(),
///   child: ListView.builder(...),
/// )
/// ```
class PullToReveal extends StatefulWidget {
  const PullToReveal({
    super.key,
    required this.child,
    required this.revealedChild,
    this.revealHeight = 60.0,
    this.triggerThreshold = 80.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Widget revealedChild;
  final double revealHeight;
  final double triggerThreshold;
  final Duration animationDuration;

  @override
  State<PullToReveal> createState() => _PullToRevealState();
}

class _PullToRevealState extends State<PullToReveal> {
  bool _isRevealed = false;
  double _overscroll = 0.0;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is OverscrollNotification && notification.overscroll < 0) {
      _overscroll += notification.overscroll.abs();
      if (!_isRevealed && _overscroll >= widget.triggerThreshold) {
        setState(() => _isRevealed = true);
      }
    } else if (notification is ScrollEndNotification) {
      _overscroll = 0.0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Column(
          children: [
            AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              height: _isRevealed ? widget.revealHeight : 0.0,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: widget.revealedChild,
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
}
