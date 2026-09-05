import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern, customizable OTP / PIN code input field.
///
/// ```dart
/// OtpPinField(
///   length: 6,
///   onCompleted: (pin) => print('Entered PIN: $pin'),
/// )
/// ```
class OtpPinField extends StatefulWidget {
  const OtpPinField({
    super.key,
    this.length = 4,
    this.fieldWidth = 44.0,
    this.fieldHeight = 52.0,
    this.spacing = 8.0,
    this.borderRadius,
    this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.obscureCharacter = '•',
    this.autoFocus = true,
    this.textStyle,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.fillColor,
  });

  final int length;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final BorderRadius? borderRadius;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final String obscureCharacter;
  final bool autoFocus;
  final TextStyle? textStyle;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final Color? fillColor;

  @override
  State<OtpPinField> createState() => _OtpPinFieldState();
}

class _OtpPinFieldState extends State<OtpPinField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  String _text = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newText = _controller.text;
    if (newText.length <= widget.length) {
      setState(() => _text = newText);
      widget.onChanged?.call(_text);
      if (_text.length == widget.length) {
        widget.onCompleted?.call(_text);
      }
    } else {
      // clamp silently
      _controller.value = _controller.value.copyWith(
        text: newText.substring(0, widget.length),
        selection: TextSelection.collapsed(offset: widget.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeBorderColor ?? theme.colorScheme.primary;
    final inactiveColor =
        widget.inactiveBorderColor ?? theme.colorScheme.outlineVariant;
    final bg = widget.fillColor ??
        theme.colorScheme.surfaceContainerHighest.withAlpha(50);
    final br = widget.borderRadius ?? BorderRadius.circular(10);
    final style = widget.textStyle ??
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

    // Total natural width of all boxes + spacing
    final naturalWidth = widget.length * widget.fieldWidth +
        (widget.length - 1) * widget.spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale down if the available width is smaller than the natural size
        final scale = constraints.maxWidth < naturalWidth
            ? constraints.maxWidth / naturalWidth
            : 1.0;

        final scaledFieldWidth = widget.fieldWidth * scale;
        final scaledFieldHeight = widget.fieldHeight * scale;
        final scaledSpacing = widget.spacing * scale;

        return GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: SizedBox(
            height: scaledFieldHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Invisible TextField that captures keyboard input
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.01,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: widget.autoFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.length),
                      ],
                    ),
                  ),
                ),

                // OTP Digit Boxes
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.length, (index) {
                    final isFilled = index < _text.length;
                    final isFocused =
                        index == _text.length && _focusNode.hasFocus;

                    String char = '';
                    if (isFilled) {
                      char = widget.obscureText
                          ? widget.obscureCharacter
                          : _text[index];
                    }

                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: scaledSpacing / 2),
                      width: scaledFieldWidth,
                      height: scaledFieldHeight,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: br,
                        border: Border.all(
                          color: isFocused || isFilled
                              ? activeColor
                              : inactiveColor,
                          width: isFocused ? 2.0 : 1.2,
                        ),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: activeColor.withAlpha(50),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(char, style: style),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
