import 'dart:math';
import 'package:flutter/material.dart';

/// A secure on-screen PIN keypad widget with optional scrambled key order
/// and biometric/delete action keys.
class SecurityPinKeyboard extends StatefulWidget {
  const SecurityPinKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onDelete,
    this.onBiometricTap,
    this.scramble = false,
    this.buttonSize = 64,
    this.spacing = 16,
    this.buttonColor,
    this.textColor,
  });

  final ValueChanged<String> onKeyTap;
  final VoidCallback onDelete;
  final VoidCallback? onBiometricTap;
  final bool scramble;
  final double buttonSize;
  final double spacing;
  final Color? buttonColor;
  final Color? textColor;

  @override
  State<SecurityPinKeyboard> createState() => _SecurityPinKeyboardState();
}

class _SecurityPinKeyboardState extends State<SecurityPinKeyboard> {
  late List<String> _keys;

  @override
  void initState() {
    super.initState();
    _initKeys();
  }

  void _initKeys() {
    final digits = List.generate(10, (i) => i.toString());
    if (widget.scramble) {
      digits.shuffle(Random());
    }
    _keys = digits;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnBg = widget.buttonColor ??
        theme.colorScheme.surfaceContainerHighest.withAlpha(80);
    final txtColor = widget.textColor ?? theme.colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: 3 digits
        _buildRow([_keys[0], _keys[1], _keys[2]], btnBg, txtColor),
        SizedBox(height: widget.spacing),
        // Row 2: 3 digits
        _buildRow([_keys[3], _keys[4], _keys[5]], btnBg, txtColor),
        SizedBox(height: widget.spacing),
        // Row 3: 3 digits
        _buildRow([_keys[6], _keys[7], _keys[8]], btnBg, txtColor),
        SizedBox(height: widget.spacing),
        // Row 4: Biometric/Empty, Last Digit, Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Action
            SizedBox(
              width: widget.buttonSize,
              height: widget.buttonSize,
              child: widget.onBiometricTap != null
                  ? IconButton(
                      onPressed: widget.onBiometricTap,
                      icon: Icon(Icons.fingerprint, color: txtColor, size: 28),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: widget.spacing),
            // Digit 0 (or last scrambled)
            _buildKey(_keys[9], btnBg, txtColor),
            SizedBox(width: widget.spacing),
            // Delete Action
            SizedBox(
              width: widget.buttonSize,
              height: widget.buttonSize,
              child: IconButton(
                onPressed: widget.onDelete,
                icon: Icon(Icons.backspace_outlined, color: txtColor, size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits, Color bg, Color text) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildKey(digits[0], bg, text),
          SizedBox(width: widget.spacing),
          _buildKey(digits[1], bg, text),
          SizedBox(width: widget.spacing),
          _buildKey(digits[2], bg, text),
        ],
      );

  Widget _buildKey(String digit, Color bg, Color text) => GestureDetector(
        onTap: () => widget.onKeyTap(digit),
        child: Container(
          width: widget.buttonSize,
          height: widget.buttonSize,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: text,
              ),
            ),
          ),
        ),
      );
}
