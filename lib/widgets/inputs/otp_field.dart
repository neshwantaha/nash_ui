import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../spacing/app_spacing.dart';

/// A one-time-password (OTP) input with auto-advancing boxes.
class OtpField extends StatefulWidget {
  const OtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.boxSize = 48,
    this.spacing = AppSpacing.sm,
    this.filled = true,
    this.initialValue,
    this.inputType = TextInputType.number,
  });

  /// Number of digit boxes.
  final int length;

  /// Called when all boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Called on every digit change.
  final ValueChanged<String>? onChanged;

  /// Whether editing is allowed.
  final bool enabled;

  /// Box size in logical pixels.
  final double boxSize;

  /// Gap between boxes.
  final double spacing;

  /// Whether boxes have a filled background.
  final bool filled;

  /// Initial partial value.
  final String? initialValue;

  /// Keyboard type.
  final TextInputType inputType;

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  String _value = '';

  @override
  void initState() {
    super.initState();
    final String seed = widget.initialValue ?? '';
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (int i) => TextEditingController(text: i < seed.length ? seed[i] : ''),
    );
    _focusNodes = List<FocusNode>.generate(widget.length, (_) => FocusNode());
    _value = seed;
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String text) {
    if (text.isEmpty) {
      _value = _controllers.map((c) => c.text).join();
      widget.onChanged?.call(_value);
      return;
    }

    final String digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _controllers[index].clear();
      return;
    }

    // Handle paste of full or multi-digit code
    if (digits.length > 1) {
      if (digits.length >= widget.length) {
        for (int i = 0; i < widget.length; i++) {
          _controllers[i].text = digits[i];
        }
        _focusNodes[widget.length - 1].requestFocus();
      } else {
        // Take the latest single typed digit when typing over an existing digit
        _controllers[index].text = digits[digits.length - 1];
        if (index < widget.length - 1) {
          _focusNodes[index + 1].requestFocus();
        }
      }
    } else {
      _controllers[index].text = digits;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    _value = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_value);
    if (_value.length == widget.length) {
      widget.onCompleted?.call(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        widget.length,
        (int i) => Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: SizedBox(
            width: widget.boxSize,
            height: widget.boxSize,
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[i].text.isEmpty &&
                    i > 0) {
                  _controllers[i - 1].clear();
                  _focusNodes[i - 1].requestFocus();
                  _value = _controllers.map((c) => c.text).join();
                  widget.onChanged?.call(_value);
                }
              },
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                enabled: widget.enabled,
                keyboardType: widget.inputType,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 2.0,
                    ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  filled: widget.filled,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  fillColor:
                      scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.primary, width: 2),
                  ),
                ),
                onTap: () {
                  // Select existing digit on tap so typing replaces it directly
                  _controllers[i].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controllers[i].text.length,
                  );
                },
                onChanged: (String text) => _onChanged(i, text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
