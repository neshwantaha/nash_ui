import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A curated color picker and palette selector with hex support.
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.palette,
    this.showHexInput = true,
    this.columns = 6,
    this.itemSize = 36.0,
  });

  /// The currently selected color.
  final Color selectedColor;

  /// Callback when a color is picked.
  final ValueChanged<Color> onColorChanged;

  /// Optional custom palette list.
  final List<Color>? palette;

  /// Whether to show the hex text input field.
  final bool showHexInput;

  /// Number of columns in the grid.
  final int columns;

  /// Size of each color circle/square.
  final double itemSize;

  /// Default curated design palette.
  static const List<Color> defaultPalette = <Color>[
    AppColors.primary,
    AppColors.violet,
    Color(0xFF6366F1), // Indigo
    AppColors.cyan,
    AppColors.emerald,
    AppColors.success,
    AppColors.amber,
    AppColors.warning,
    AppColors.rose,
    AppColors.error,
    AppColors.pink,
    Color(0xFF64748B), // Slate
    Color(0xFF0F172A), // Dark Slate
    Color(0xFF3B82F6), // Sky Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
  ];

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late final TextEditingController _hexController;
  late Color _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedColor;
    _hexController = TextEditingController(text: _colorToHex(_current));
  }

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      _current = widget.selectedColor;
      _hexController.text = _colorToHex(_current);
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) =>
      color.toARGB32().toRadixString(16).substring(2).toUpperCase();

  void _onSelect(Color color) {
    setState(() {
      _current = color;
      _hexController.text = _colorToHex(color);
    });
    widget.onColorChanged(color);
  }

  void _onHexSubmitted(String hex) {
    final String cleanHex = hex.replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      final int? intVal = int.tryParse('FF$cleanHex', radix: 16);
      if (intVal != null) {
        final Color color = Color(intVal);
        _onSelect(color);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> palette = widget.palette ?? ColorPicker.defaultPalette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Palette Grid
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: palette.map((Color color) {
            final bool isSelected = _current.toARGB32() == color.toARGB32();
            return GestureDetector(
              onTap: () => _onSelect(color),
              child: AnimatedContainer(
                duration: AppDuration.fast,
                width: widget.itemSize,
                height: widget.itemSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? <BoxShadow>[
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),

        // Hex Code Input Bar
        if (widget.showHexInput) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              // Preview Box
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _current,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Hex TextField
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _hexController,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      prefixText: '# ',
                      prefixStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      hintText: 'HEX CODE',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.8,
                        ),
                      ),
                    ),
                    onSubmitted: _onHexSubmitted,
                    onChanged: (String v) {
                      if (v.length == 6) _onHexSubmitted(v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
