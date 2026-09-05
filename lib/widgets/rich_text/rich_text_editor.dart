import 'package:flutter/material.dart';

/// A lightweight rich text editor with formatting toolbar.
///
/// ```dart
/// RichTextEditor(
///   controller: _controller,
///   hintText: 'Start typing...',
/// )
/// ```
class RichTextEditor extends StatefulWidget {
  const RichTextEditor({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines = 8,
    this.minLines = 4,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.toolbarActions,
    this.showToolbar = true,
    this.toolbarBackgroundColor,
    this.decoration,
    this.style,
    this.textAlign,
  });

  /// Optional text controller.
  final TextEditingController? controller;

  /// Placeholder text when empty.
  final String? hintText;

  /// Maximum lines visible.
  final int maxLines;

  /// Minimum lines visible.
  final int minLines;

  /// Whether the editor is enabled.
  final bool enabled;

  /// Whether the editor is read-only.
  final bool readOnly;

  /// Whether to autofocus.
  final bool autofocus;

  /// Callback on text change.
  final ValueChanged<String>? onChanged;

  /// Callback on submit.
  final ValueChanged<String>? onSubmitted;

  /// Custom toolbar actions (defaults to bold, italic, underline, etc.).
  final List<ToolbarAction>? toolbarActions;

  /// Whether to show the formatting toolbar.
  final bool showToolbar;

  /// Toolbar background color.
  final Color? toolbarBackgroundColor;

  /// Input decoration.
  final InputDecoration? decoration;

  /// Text style.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;
  TextAlign _textAlign = TextAlign.start;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _textAlign = widget.textAlign ?? TextAlign.start;
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleBold() => setState(() => _bold = !_bold);
  void _toggleItalic() => setState(() => _italic = !_italic);
  void _toggleUnderline() => setState(() => _underline = !_underline);

  void _setAlignment(TextAlign align) {
    setState(() => _textAlign = align);
  }

  void _insertText(String text) {
    final int start = _controller.selection.start;
    final int end = _controller.selection.end;
    final String current = _controller.text;
    _controller.text =
        '${current.substring(0, start)}$text${current.substring(end)}';
    _controller.selection =
        TextSelection.collapsed(offset: start + text.length);
  }

  void _insertBulletList() {
    _insertText('\n• ');
  }

  void _insertNumberedList() {
    _insertText('\n1. ');
  }

  void _insertLink() {
    _insertText('[link text](url)');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final InputDecoration defaultDecoration = InputDecoration(
      hintText: widget.hintText,
      hintStyle:
          TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.showToolbar)
          Container(
            decoration: BoxDecoration(
              color: widget.toolbarBackgroundColor ??
                  scheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: _buildToolbar(scheme),
          ),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          textAlign: _textAlign,
          style: widget.style ??
              TextStyle(
                fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                decoration: _underline ? TextDecoration.underline : null,
              ),
          decoration: (widget.decoration ?? defaultDecoration).copyWith(
            border: widget.decoration?.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(ColorScheme scheme) {
    final List<Widget> actions = <Widget>[
      _ToolbarButton(
        icon: Icons.format_bold,
        active: _bold,
        onTap: _toggleBold,
        tooltip: 'Bold',
      ),
      _ToolbarButton(
        icon: Icons.format_italic,
        active: _italic,
        onTap: _toggleItalic,
        tooltip: 'Italic',
      ),
      _ToolbarButton(
        icon: Icons.format_underlined,
        active: _underline,
        onTap: _toggleUnderline,
        tooltip: 'Underline',
      ),
      _toolbarDivider,
      _ToolbarButton(
        icon: Icons.format_align_left,
        active: _textAlign == TextAlign.left,
        onTap: () => _setAlignment(TextAlign.left),
        tooltip: 'Align left',
      ),
      _ToolbarButton(
        icon: Icons.format_align_center,
        active: _textAlign == TextAlign.center,
        onTap: () => _setAlignment(TextAlign.center),
        tooltip: 'Align center',
      ),
      _ToolbarButton(
        icon: Icons.format_align_right,
        active: _textAlign == TextAlign.right,
        onTap: () => _setAlignment(TextAlign.right),
        tooltip: 'Align right',
      ),
      _toolbarDivider,
      _ToolbarButton(
        icon: Icons.format_list_bulleted,
        onTap: _insertBulletList,
        tooltip: 'Bullet list',
      ),
      _ToolbarButton(
        icon: Icons.format_list_numbered,
        onTap: _insertNumberedList,
        tooltip: 'Numbered list',
      ),
      _ToolbarButton(
        icon: Icons.link,
        onTap: _insertLink,
        tooltip: 'Insert link',
      ),
    ];

    if (widget.toolbarActions != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.toolbarActions!
            .map((ToolbarAction action) => _ToolbarButton(
                  icon: action.icon,
                  active: action.isActive,
                  onTap: action.onTap,
                  tooltip: action.tooltip,
                ))
            .toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );
  }

  static const Widget _toolbarDivider = SizedBox(
    width: 1,
    height: 24,
    child: VerticalDivider(indent: 4, endIndent: 4),
  );
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: active ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// A custom toolbar action for the rich text editor.
class ToolbarAction {
  const ToolbarAction({
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final String? tooltip;
}
