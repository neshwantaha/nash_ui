import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A simple syntax-highlighted code block widget.
///
/// Supports Dart, Python, JS/TS, HTML, CSS, YAML, JSON
/// and generic keyword highlighting without any external package.
///
/// ```dart
/// CodeBlock(
///   code: '''void main() { print("Hello"); }''',
///   language: CodeLanguage.dart,
/// )
/// ```
enum CodeLanguage {
  dart,
  python,
  javascript,
  typescript,
  html,
  css,
  yaml,
  json,
  generic
}

class SyntaxHighlighter extends StatelessWidget {
  const SyntaxHighlighter({
    super.key,
    required this.code,
    this.language = CodeLanguage.generic,
    this.showLineNumbers = true,
    this.showCopyButton = true,
    this.maxHeight,
    this.style,
    this.backgroundColor,
    this.borderRadius,
  });

  final String code;
  final CodeLanguage language;
  final bool showLineNumbers;
  final bool showCopyButton;
  final double? maxHeight;
  final TextStyle? style;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFF1E1E2E);
    final br = borderRadius ?? BorderRadius.circular(10);
    final baseStyle = style ??
        const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13.5,
          height: 1.55,
        );
    final lines = code.split('\n');

    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: br),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.vertical(top: br.topLeft),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const Spacer(),
                Text(
                  language.name.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
                if (showCopyButton) ...[
                  const SizedBox(width: 12),
                  _CopyButton(code: code),
                ],
              ],
            ),
          ),

          // Code body
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? double.infinity,
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: showLineNumbers
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Line numbers
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                lines.length,
                                (i) => Text(
                                  '${i + 1}',
                                  style: baseStyle.copyWith(
                                    color: const Color(0xFF555577),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Code
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: lines
                                  .map((l) => _HighlightedLine(
                                        line: l,
                                        language: language,
                                        baseStyle: baseStyle,
                                      ))
                                  .toList(),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lines
                              .map((l) => _HighlightedLine(
                                    line: l,
                                    language: language,
                                    baseStyle: baseStyle,
                                  ))
                              .toList(),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle));
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});
  final String code;
  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: widget.code));
          setState(() => _copied = true);
          await Future<void>.delayed(const Duration(seconds: 2));
          if (mounted) setState(() => _copied = false);
        },
        child: Icon(
          _copied ? Icons.check : Icons.copy,
          size: 16,
          color: const Color(0xFFAAAAAA),
        ),
      );
}

// Very lightweight tokenizer
class _HighlightedLine extends StatelessWidget {
  const _HighlightedLine({
    required this.line,
    required this.language,
    required this.baseStyle,
  });

  final String line;
  final CodeLanguage language;
  final TextStyle baseStyle;

  static const _colors = _SyntaxColors();

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(children: _tokenize(line, language)),
        style: baseStyle.copyWith(color: _colors.text),
      );

  List<TextSpan> _tokenize(String line, CodeLanguage lang) {
    // Detect comment lines
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('//') ||
        trimmed.startsWith('#') ||
        trimmed.startsWith('<!--')) {
      return [TextSpan(text: line, style: TextStyle(color: _colors.comment))];
    }

    final List<TextSpan> spans = [];
    // Simple regex-based pass
    final pattern = _buildPattern(lang);
    int pos = 0;
    for (final match in pattern.allMatches(line)) {
      if (match.start > pos) {
        spans.add(TextSpan(text: line.substring(pos, match.start)));
      }
      final token = match.group(0)!;
      spans.add(TextSpan(
        text: token,
        style: TextStyle(color: _colorForToken(token, lang)),
      ));
      pos = match.end;
    }
    if (pos < line.length) {
      spans.add(TextSpan(text: line.substring(pos)));
    }
    return spans.isEmpty ? [TextSpan(text: line)] : spans;
  }

  Color _colorForToken(String token, CodeLanguage lang) {
    // String literals
    if ((token.startsWith('"') && token.endsWith('"')) ||
        (token.startsWith("'") && token.endsWith("'"))) {
      return _colors.string;
    }
    // Numbers
    if (RegExp(r'^\d').hasMatch(token)) return _colors.number;
    // Keywords
    if (_keywords(lang).contains(token)) return _colors.keyword;
    // Types/classes (PascalCase)
    if (RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(token)) return _colors.type;
    return _colors.text;
  }

  RegExp _buildPattern(CodeLanguage lang) => RegExp(
        r'"[^"]*"' // double-quoted string
        r"|'[^']*'" // single-quoted string
        r'|\b\d+\.?\d*\b' // numbers
        r'|\b[a-zA-Z_][a-zA-Z0-9_]*\b', // identifiers
      );

  Set<String> _keywords(CodeLanguage lang) {
    switch (lang) {
      case CodeLanguage.dart:
        return {
          'abstract',
          'as',
          'assert',
          'async',
          'await',
          'break',
          'case',
          'catch',
          'class',
          'const',
          'continue',
          'covariant',
          'default',
          'deferred',
          'do',
          'dynamic',
          'else',
          'enum',
          'export',
          'extends',
          'extension',
          'external',
          'factory',
          'false',
          'final',
          'finally',
          'for',
          'Function',
          'get',
          'hide',
          'if',
          'implements',
          'import',
          'in',
          'interface',
          'is',
          'late',
          'library',
          'mixin',
          'new',
          'null',
          'on',
          'operator',
          'part',
          'required',
          'rethrow',
          'return',
          'sealed',
          'set',
          'show',
          'static',
          'super',
          'switch',
          'sync',
          'this',
          'throw',
          'true',
          'try',
          'typedef',
          'var',
          'void',
          'while',
          'with',
          'yield',
        };
      case CodeLanguage.python:
        return {
          'False',
          'None',
          'True',
          'and',
          'as',
          'assert',
          'async',
          'await',
          'break',
          'class',
          'continue',
          'def',
          'del',
          'elif',
          'else',
          'except',
          'finally',
          'for',
          'from',
          'global',
          'if',
          'import',
          'in',
          'is',
          'lambda',
          'nonlocal',
          'not',
          'or',
          'pass',
          'raise',
          'return',
          'try',
          'while',
          'with',
          'yield',
        };
      case CodeLanguage.javascript:
      case CodeLanguage.typescript:
        return {
          'abstract',
          'any',
          'as',
          'async',
          'await',
          'boolean',
          'break',
          'case',
          'catch',
          'class',
          'const',
          'continue',
          'debugger',
          'declare',
          'default',
          'delete',
          'do',
          'else',
          'enum',
          'export',
          'extends',
          'false',
          'finally',
          'for',
          'from',
          'function',
          'get',
          'if',
          'implements',
          'import',
          'in',
          'instanceof',
          'interface',
          'let',
          'module',
          'namespace',
          'never',
          'new',
          'null',
          'number',
          'of',
          'package',
          'private',
          'protected',
          'public',
          'readonly',
          'require',
          'return',
          'set',
          'static',
          'string',
          'super',
          'switch',
          'this',
          'throw',
          'true',
          'try',
          'type',
          'typeof',
          'undefined',
          'var',
          'void',
          'while',
          'with',
          'yield',
        };
      default:
        return {};
    }
  }
}

class _SyntaxColors {
  const _SyntaxColors();
  Color get text => const Color(0xFFCDD6F4);
  Color get keyword => const Color(0xFFCBA6F7);
  Color get string => const Color(0xFFA6E3A1);
  Color get number => const Color(0xFFFAB387);
  Color get comment => const Color(0xFF585B70);
  Color get type => const Color(0xFF89DCEB);
}
