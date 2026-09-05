import 'package:flutter/widgets.dart';

/// A centered layout with optional max-width constraints (readable text rows).
class AppCenter extends StatelessWidget {
  const AppCenter({
    super.key,
    this.child,
    this.maxWidth,
    this.padding,
  });

  /// The centered child.
  final Widget? child;

  /// When set, the child is constrained to this maximum width.
  final double? maxWidth;

  /// Padding applied inside the centered area.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget content = child ?? const SizedBox.shrink();
    if (padding != null) content = Padding(padding: padding!, child: content);
    return Center(
      child: maxWidth == null
          ? content
          : ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth!), child: content),
    );
  }
}

/// A [AppStack] with design-system defaults.
class AppStack extends StatelessWidget {
  const AppStack({
    super.key,
    this.children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Stack children.
  final List<Widget> children;

  /// Alignment of non-positioned children.
  final AlignmentGeometry alignment;

  /// How non-positioned children are sized.
  final StackFit fit;

  /// Text direction.
  final TextDirection? textDirection;

  /// Clip behavior.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: alignment,
        fit: fit,
        textDirection: textDirection,
        clipBehavior: clipBehavior,
        children: children,
      );
}
