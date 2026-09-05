import 'package:flutter/material.dart';

/// A Tinder-style card stack that lets users swipe cards left or right.
///
/// Cards are stacked with a subtle 3-D fan perspective. When the user drags
/// and releases past [swipeThreshold], the card flies off-screen and
/// [onSwipe] is called with the direction.
///
/// ```dart
/// SwipeableCards(
///   itemCount: cards.length,
///   itemBuilder: (context, index) => MyCard(cards[index]),
///   onSwipe: (index, dir) => setState(() => cards.removeAt(index)),
/// )
/// ```
class SwipeableCards extends StatefulWidget {
  const SwipeableCards({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onSwipe,
    this.swipeThreshold = 0.35,
    this.visibleCount = 3,
    this.stackOffset = const Offset(0, 14),
    this.stackScaleStep = 0.06,
    this.flyDuration = const Duration(milliseconds: 350),
  });

  /// Total number of cards.
  final int itemCount;

  /// Builds the card at [index].
  final IndexedWidgetBuilder itemBuilder;

  /// Called when a card is swiped off.
  /// [index] is the swiped card index; [direction] is left or right.
  final void Function(int index, SwipeDirection direction)? onSwipe;

  /// Fraction of screen width beyond which a swipe is registered.
  final double swipeThreshold;

  /// How many cards to show in the stack at once.
  final int visibleCount;

  /// Vertical offset between consecutive stacked cards.
  final Offset stackOffset;

  /// Scale reduction per stacked card level.
  final double stackScaleStep;

  /// Duration of the fly-off animation.
  final Duration flyDuration;

  @override
  State<SwipeableCards> createState() => _SwipeableCardsState();
}

/// Direction of a completed swipe.
enum SwipeDirection { left, right }

class _SwipeableCardsState extends State<SwipeableCards>
    with TickerProviderStateMixin {
  int _topIndex = 0;
  Offset _drag = Offset.zero;
  AnimationController? _flyCtrl;
  Animation<Offset>? _flyAnim;
  bool _flying = false;

  int get _remaining => widget.itemCount - _topIndex;

  void _onPanUpdate(DragUpdateDetails d) {
    if (_flying) return;
    setState(() => _drag += d.delta);
  }

  void _onPanEnd(DragEndDetails d, double screenWidth) {
    if (_flying) return;
    final fraction = _drag.dx / screenWidth;
    if (fraction.abs() >= widget.swipeThreshold) {
      final dir = fraction > 0 ? SwipeDirection.right : SwipeDirection.left;
      _flyOff(dir, screenWidth);
    } else {
      setState(() => _drag = Offset.zero);
    }
  }

  void _flyOff(SwipeDirection dir, double screenWidth) {
    final targetX =
        dir == SwipeDirection.right ? screenWidth * 1.5 : -screenWidth * 1.5;
    final target = Offset(targetX, _drag.dy * 1.5);

    _flyCtrl = AnimationController(vsync: this, duration: widget.flyDuration);
    _flyAnim = Tween<Offset>(begin: _drag, end: target).animate(
      CurvedAnimation(parent: _flyCtrl!, curve: Curves.easeOut),
    );
    _flying = true;

    _flyCtrl!.forward().then((_) {
      widget.onSwipe?.call(_topIndex, dir);
      setState(() {
        _topIndex++;
        _drag = Offset.zero;
        _flying = false;
        _flyCtrl?.dispose();
        _flyCtrl = null;
        _flyAnim = null;
      });
    });
  }

  @override
  void dispose() {
    _flyCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining <= 0) {
      return const Center(child: Text('No more cards'));
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final count = _remaining.clamp(0, widget.visibleCount);

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        alignment: Alignment.center,
        children: [
          // Back cards (no interaction)
          for (int i = count - 1; i >= 1; i--)
            _BackCard(
              level: i,
              stackOffset: widget.stackOffset,
              scaleStep: widget.stackScaleStep,
              child: widget.itemBuilder(context, _topIndex + i),
            ),

          // Top card (draggable)
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: (d) => _onPanEnd(d, screenWidth),
            child: AnimatedBuilder(
              animation: _flyAnim ?? const AlwaysStoppedAnimation(Offset.zero),
              builder: (_, child) {
                final offset =
                    _flying && _flyAnim != null ? _flyAnim!.value : _drag;
                final angle = (offset.dx / screenWidth) * 0.4;
                return Transform(
                  origin: const Offset(0, 200),
                  transform: Matrix4.translationValues(
                    offset.dx,
                    offset.dy,
                    0,
                  )..rotateZ(angle),
                  child: child,
                );
              },
              child: widget.itemBuilder(context, _topIndex),
            ),
          ),

          // Swipe direction indicators
          if (!_flying && _drag.dx != 0)
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity:
                      (_drag.dx.abs() / (screenWidth * widget.swipeThreshold))
                          .clamp(0, 1),
                  child: Align(
                    alignment: _drag.dx > 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _drag.dx > 0 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _drag.dx > 0 ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _drag.dx > 0 ? '✓ LIKE' : '✗ NOPE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BackCard extends StatelessWidget {
  const _BackCard({
    required this.level,
    required this.stackOffset,
    required this.scaleStep,
    required this.child,
  });

  final int level;
  final Offset stackOffset;
  final double scaleStep;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - (level * scaleStep);
    final dy = level * stackOffset.dy;
    return Transform.translate(
      offset: Offset(0, dy),
      child: Transform.scale(scale: scale, child: child),
    );
  }
}
