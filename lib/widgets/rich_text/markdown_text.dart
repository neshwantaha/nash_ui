import 'package:flutter/material.dart';

/// Lightweight Markdown renderer that handles common Markdown elements
/// without any external dependency.
///
/// Supported elements:
/// - H1–H3 headings (`# ## ###`)
/// - Bold (`**text**`)
/// - Italic (`*text*`)
/// - Inline code (`` `code` ``)
/// - Unordered list (`- item`)
/// - Ordered list (`1. item`)
/// - Blockquote (`> text`)
/// - Horizontal rule (`---`)
/// - Plain paragraphs
///
/// ```dart
/// MarkdownText(
///   data: '''
/// # Hello nash_ui
/// This is **bold** and *italic*.
/// ''',
/// )
/// ```
class MarkdownText extends StatelessWidget {
  const MarkdownText({
    super.key,
    required this.data,
    this.selectable = false,
    this.padding,
    this.h1Style,
    this.h2Style,
    this.h3Style,
    this.bodyStyle,
    this.codeStyle,
    this.blockquoteColor,
  });

  final String data;
  final bool selectable;
  final EdgeInsetsGeometry? padding;
  final TextStyle? h1Style;
  final TextStyle? h2Style;
  final TextStyle? h3Style;
  final TextStyle? bodyStyle;
  final TextStyle? codeStyle;
  final Color? blockquoteColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = data.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Horizontal rule
      if (RegExp(r'^-{3,}$').hasMatch(line.trim())) {
        widgets.add(const Divider());
        continue;
      }
      // H1
      if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: _rich(
            line.substring(2),
            h1Style ??
                theme.textTheme.headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
          ),
        ));
        continue;
      }
      // H2
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: _rich(
            line.substring(3),
            h2Style ??
                theme.textTheme.headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
          ),
        ));
        continue;
      }
      // H3
      if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: _rich(
            line.substring(4),
            h3Style ??
                theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
          ),
        ));
        continue;
      }
      // Blockquote
      if (line.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: blockquoteColor ?? theme.colorScheme.primary,
                width: 3,
              ),
            ),
            color: (blockquoteColor ?? theme.colorScheme.primary).withAlpha(20),
          ),
          child: _rich(
            line.substring(2),
            bodyStyle ?? theme.textTheme.bodyMedium!,
          ),
        ));
        continue;
      }
      // Unordered list
      if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: _rich(
                  line.substring(2),
                  bodyStyle ?? theme.textTheme.bodyMedium!,
                ),
              ),
            ],
          ),
        ));
        continue;
      }
      // Ordered list (e.g. "1. ")
      final olMatch = RegExp(r'^(\d+)\. (.+)').firstMatch(line);
      if (olMatch != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${olMatch.group(1)}. ',
                  style: bodyStyle ?? theme.textTheme.bodyMedium),
              Expanded(
                child: _rich(
                  olMatch.group(2)!,
                  bodyStyle ?? theme.textTheme.bodyMedium!,
                ),
              ),
            ],
          ),
        ));
        continue;
      }
      // Empty line
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }
      // Paragraph
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 2),
        child: _rich(line, bodyStyle ?? theme.textTheme.bodyMedium!),
      ));
    }

    final col = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );

    return selectable ? SelectionArea(child: col) : col;
  }

  /// Parses inline **bold**, *italic*, and `code` spans.
  Widget _rich(String text, TextStyle base) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'`([^`]+)`' // inline code
        r'|\*\*([^*]+)\*\*' // bold
        r'|\*([^*]+)\*' // italic
        );
    int pos = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > pos) {
        spans.add(TextSpan(text: text.substring(pos, match.start)));
      }
      if (match.group(1) != null) {
        // inline code
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontFamily: 'monospace',
            backgroundColor: Color(0x22888888),
            fontSize: 13,
          ),
        ));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(
          text: match.group(3),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      }
      pos = match.end;
    }
    if (pos < text.length) {
      spans.add(TextSpan(text: text.substring(pos)));
    }
    return Text.rich(TextSpan(children: spans, style: base));
  }
}
