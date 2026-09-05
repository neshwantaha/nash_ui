import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A full-screen style numeric pad dialog.
///
/// Returns the entered amount string.
///
/// ```dart
/// final result = await showDialog<String>(
///   context: context,
///   builder: (_) => NumberPadDialog(title: 'Enter Amount', prefix: '\$'),
/// );
/// ```
class NumberPadDialog extends StatefulWidget {
  const NumberPadDialog({
    super.key,
    this.title = 'Enter Amount',
    this.prefix = '',
    this.suffix = '',
    this.maxLength = 10,
    this.confirmLabel = 'Confirm',
  });

  final String title;
  final String prefix;
  final String suffix;
  final int maxLength;
  final String confirmLabel;

  @override
  State<NumberPadDialog> createState() => _NumberPadDialogState();
}

class _NumberPadDialogState extends State<NumberPadDialog> {
  String _value = '0';

  void _tap(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_value == '0' && digit != '.') {
        _value = digit;
      } else if (_value.length < widget.maxLength) {
        if (digit == '.' && _value.contains('.')) return;
        _value += digit;
      }
    });
  }

  void _delete() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_value.length <= 1) {
        _value = '0';
      } else {
        _value = _value.substring(0, _value.length - 1);
      }
    });
  }

  Widget _key(String label, {Color? color, VoidCallback? onTap}) => Expanded(
        child: InkWell(
          onTap: onTap ?? () => _tap(label),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(6),
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color?.withAlpha(20) ??
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: color ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: primary.withAlpha(15),
                border: Border.all(color: primary.withAlpha(60)),
              ),
              child: Text(
                '${widget.prefix}$_value${widget.suffix}',
                textAlign: TextAlign.right,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Number Pad
            for (final row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['.', '0', '⌫'],
            ])
              Row(
                children: row.map((k) {
                  if (k == '⌫') {
                    return _key(k, color: Colors.redAccent, onTap: _delete);
                  }
                  return _key(k);
                }).toList(),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, _value),
                child: Text(widget.confirmLabel,
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
