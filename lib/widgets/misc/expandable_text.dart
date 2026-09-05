import 'package:flutter/material.dart';

/// A text widget that truncates at [maxLines] and shows an animated
/// "Read more" / "Read less" toggle.
///
/// ```dart
/// ExpandableText(
///   text: longDescription,
///   maxLines: 3,
/// )
/// ```
class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.expandText = 'Read more',
    this.collapseText = 'Read less',
    this.style,
    this.linkStyle,
    this.linkColor,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  /// The full text content.
  final String text;

  /// Number of lines before truncation.
  final int maxLines;

  final String expandText;
  final String collapseText;

  /// Style for the body text.
  final TextStyle? style;

  /// Style for the toggle link (overrides [linkColor]).
  final TextStyle? linkStyle;

  /// Color of the "Read more / less" link.
  final Color? linkColor;

  final Duration animationDuration;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = widget.style ?? theme.textTheme.bodyMedium!;
    final linkColor = widget.linkColor ?? theme.colorScheme.primary;
    final linkStyle = widget.linkStyle ??
        baseStyle.copyWith(color: linkColor, fontWeight: FontWeight.w600);

    return LayoutBuilder(builder: (context, constraints) {
      // Measure how much space the full text needs
      final span = TextSpan(text: widget.text, style: baseStyle);
      final tp = TextPainter(
        text: span,
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: constraints.maxWidth);

      _hasOverflow = tp.didExceedMaxLines;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              widget.text,
              maxLines: widget.maxLines,
              overflow: TextOverflow.ellipsis,
              style: baseStyle,
            ),
            secondChild: Text(widget.text, style: baseStyle),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: widget.animationDuration,
          ),
          if (_hasOverflow) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? widget.collapseText : widget.expandText,
                style: linkStyle,
              ),
            ),
          ],
        ],
      );
    });
  }
}
