import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An interactive color palette display widget.
///
/// Shows a grid of color swatches with optional labels. Tapping a swatch
/// calls [onSelect] and optionally copies the hex value to the clipboard.
///
/// ```dart
/// ColorSwatchViewer(
///   swatches: [
///     ColorSwatch(color: Color(0xFF4FC3F7), label: 'Sky Blue'),
///     ColorSwatch(color: Color(0xFFAB47BC), label: 'Violet'),
///   ],
///   onSelect: (swatch) => print(swatch.hexCode),
/// )
/// ```
class ColorSwatchViewer extends StatefulWidget {
  const ColorSwatchViewer({
    super.key,
    required this.swatches,
    this.onSelect,
    this.columns = 4,
    this.swatchSize = 56,
    this.spacing = 8,
    this.showLabel = true,
    this.showHexOnTap = true,
    this.selectedIndex,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.copyOnTap = false,
  });

  /// List of color swatches to display.
  final List<ColorSwatchEntry> swatches;

  /// Called when a swatch is tapped.
  final ValueChanged<ColorSwatchEntry>? onSelect;

  /// Number of columns in the grid.
  final int columns;

  /// Size of each square swatch.
  final double swatchSize;

  /// Gap between swatches.
  final double spacing;

  /// Show the swatch label below each color.
  final bool showLabel;

  /// Show a hex tooltip when the swatch is tapped.
  final bool showHexOnTap;

  /// Pre-selected index (highlights with a check mark).
  final int? selectedIndex;

  /// Border radius of each swatch.
  final BorderRadius borderRadius;

  /// When true, tapping a swatch copies its hex code to the clipboard.
  final bool copyOnTap;

  @override
  State<ColorSwatchViewer> createState() => _ColorSwatchViewerState();
}

/// A single color entry in [ColorSwatchViewer].
class ColorSwatchEntry {
  const ColorSwatchEntry({
    required this.color,
    this.label,
  });

  final Color color;
  final String? label;

  /// 6-digit hex string like `#4FC3F7`.
  String get hexCode {
    final val = color.toARGB32();
    return '#${(val & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

class _ColorSwatchViewerState extends State<ColorSwatchViewer> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        children: List.generate(widget.swatches.length, (i) {
          final entry = widget.swatches[i];
          final isSelected = _selected == i;
          final luminance = entry.color.computeLuminance();
          final onColor = luminance > 0.4 ? Colors.black : Colors.white;

          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onSelect?.call(entry);
              if (widget.copyOnTap) {
                Clipboard.setData(ClipboardData(text: entry.hexCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied ${entry.hexCode}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Tooltip(
              message: entry.hexCode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.swatchSize,
                    height: widget.swatchSize,
                    decoration: BoxDecoration(
                      color: entry.color,
                      borderRadius: widget.borderRadius,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withValues(alpha: 0.08),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: entry.color.withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(Icons.check_rounded, color: onColor, size: 20)
                        : null,
                  ),
                  if (widget.showLabel && entry.label != null) ...[
                    const SizedBox(height: 4),
                    SizedBox(
                      width: widget.swatchSize,
                      child: Text(
                        entry.label!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      );
}
