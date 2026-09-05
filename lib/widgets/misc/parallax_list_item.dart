import 'package:flutter/material.dart';

/// A parallax scroll effect applied to a list tile's background.
///
/// As the user scrolls, the [background] moves at [parallaxFactor] speed
/// relative to the list, creating a 3-D depth illusion.
///
/// Wrap inside a [ListView] or [CustomScrollView] for the effect to work.
///
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => ParallaxListItem(
///     height: 200,
///     background: Image.network(items[index].imageUrl, fit: BoxFit.cover),
///     child: Text(items[index].title),
///   ),
/// )
/// ```
class ParallaxListItem extends StatefulWidget {
  const ParallaxListItem({
    super.key,
    required this.background,
    required this.height,
    this.child,
    this.parallaxFactor = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.margin = EdgeInsets.zero,
    this.backgroundExtraHeight = 100,
  });

  /// Background widget that will be shifted during scroll.
  final Widget background;

  /// Height of the visible tile.
  final double height;

  /// Content rendered on top of the background.
  final Widget? child;

  /// How strongly the background shifts relative to scroll. 0 = no parallax.
  final double parallaxFactor;

  /// Border radius of the clipped tile.
  final BorderRadius borderRadius;

  /// Margin around the tile.
  final EdgeInsetsGeometry margin;

  /// Extra height added to the background to allow parallax movement.
  final double backgroundExtraHeight;

  @override
  State<ParallaxListItem> createState() => _ParallaxListItemState();
}

class _ParallaxListItemState extends State<ParallaxListItem> {
  final GlobalKey _bgKey = GlobalKey();

  Offset _bgOffset = Offset.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Scrollable.of(context).position.addListener(_updateParallax);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateParallax());
  }

  void _updateParallax() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final scrollable = Scrollable.of(context);
    final scrollRenderBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollRenderBox == null) return;

    final viewportHeight = scrollRenderBox.size.height;
    final itemOffset =
        renderBox.localToGlobal(Offset.zero, ancestor: scrollRenderBox);

    final fraction = (itemOffset.dy / viewportHeight).clamp(-1.0, 2.0);
    final shift =
        fraction * widget.backgroundExtraHeight * widget.parallaxFactor;

    if (mounted) setState(() => _bgOffset = Offset(0, shift));
  }

  @override
  Widget build(BuildContext context) {
    final totalBgHeight = widget.height + widget.backgroundExtraHeight;

    return Container(
      margin: widget.margin,
      height: widget.height,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Parallax background
            Positioned(
              left: 0,
              right: 0,
              top: _bgOffset.dy,
              height: totalBgHeight,
              child: KeyedSubtree(
                key: _bgKey,
                child: widget.background,
              ),
            ),

            // Foreground content
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}
