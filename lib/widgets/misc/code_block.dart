import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A sleek code block viewer with line numbers, language tag, and one-click copy button.
class CodeBlock extends StatefulWidget {
  const CodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.showLineNumbers = true,
    this.showCopyButton = true,
    this.fontSize = 12.0,
    this.borderRadius = AppRadius.large,
    this.headerBackground,
  });

  /// The source code text.
  final String code;

  /// Programming language label displayed on the header (e.g. 'dart', 'yaml', 'json').
  final String language;

  /// Whether to display line numbers on the left gutter.
  final bool showLineNumbers;

  /// Whether to show the Copy to Clipboard button.
  final bool showCopyButton;

  /// Code font size.
  final double fontSize;

  /// Corner radius.
  final double borderRadius;

  /// Optional custom header bar color.
  final Color? headerBackground;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> lines = widget.code.trimRight().split('\n');

    final Color bg = isDark ? const Color(0xFF0F0F1A) : const Color(0xFF1E1E2E);
    final Color headerBg = widget.headerBackground ??
        (isDark ? const Color(0xFF161626) : const Color(0xFF28283E));
    const Color textColor = Color(0xFFE2E8F0);
    const Color lineNumberColor = Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: headerBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Window dots + Language Tag
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.language.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: lineNumberColor,
                      ),
                    ),
                  ],
                ),

                // Copy Button
                if (widget.showCopyButton)
                  InkWell(
                    onTap: _copy,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: AppDuration.fast,
                            child: Icon(
                              _copied
                                  ? Icons.check_rounded
                                  : Icons.copy_rounded,
                              key: ValueKey<bool>(_copied),
                              size: 14,
                              color:
                                  _copied ? AppColors.success : lineNumberColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _copied ? 'Copied!' : 'Copy',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  _copied ? AppColors.success : lineNumberColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Code Body with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Line Numbers
                if (widget.showLineNumbers) ...<Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List<Widget>.generate(
                        lines.length,
                        (int i) => Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: widget.fontSize,
                                color: lineNumberColor.withValues(alpha: 0.6),
                                height: 1.5,
                              ),
                            )),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: lines.length * (widget.fontSize * 1.5),
                    color: lineNumberColor.withValues(alpha: 0.15),
                  ),
                  const SizedBox(width: 16),
                ],

                // Code lines
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List<Widget>.generate(
                      lines.length,
                      (int i) => Text(
                            lines[i].isEmpty ? ' ' : lines[i],
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: widget.fontSize,
                              color: textColor,
                              height: 1.5,
                            ),
                          )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
