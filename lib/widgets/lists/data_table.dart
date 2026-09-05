import 'package:flutter/material.dart' hide DataTable;

import '../../colors/brand_colors.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/font_weight.dart';

/// Column alignment for [DataTable].
enum DataColumnAlignment {
  /// Left aligned.
  left,

  /// Center aligned.
  center,

  /// Right aligned.
  right,
}

/// A data table row value.
class TableCellItem {
  const TableCellItem(this.value, {this.alignment = DataColumnAlignment.left});

  /// Cell value (String or Widget).
  final Widget value;

  /// Cell alignment.
  final DataColumnAlignment alignment;
}

/// A simple, styled data table with sorting and row selection support.
///
/// A backwards-compatible alias for [DataTable].
typedef NashDataTable = DataTable;

/// A simple, styled data table with sorting and row selection support.
class DataTable extends StatelessWidget {
  const DataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.horizontalPadding = AppSpacing.md,
    this.showCheckboxes = false,
    this.onRowSelected,
    this.selectedIndices = const <int>{},
    this.headerBackground,
    this.rowHeight = 48,
    this.alternating = true,
    this.showVerticalDividers = true,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
  });

  /// Column headers.
  final List<String> columns;

  /// Table rows; accepts [DataCell], [DataCell], or raw [Widget] items.
  final List<List<dynamic>> rows;

  /// Horizontal cell padding.
  final double horizontalPadding;

  /// Whether to show selection checkboxes.
  final bool showCheckboxes;

  /// Row selection callback.
  final ValueChanged<int>? onRowSelected;

  /// Indices of selected rows.
  final Set<int> selectedIndices;

  /// Header background color.
  final Color? headerBackground;

  /// Row height.
  final double rowHeight;

  /// Whether to alternate row backgrounds.
  final bool alternating;

  /// Whether to show vertical dividers between columns.
  final bool showVerticalDividers;

  /// Current sorted column index.
  final int? sortColumnIndex;

  /// Whether the sort is ascending.
  final bool sortAscending;

  /// Callback when a column header is tapped to sort.
  // ignore: avoid_positional_boolean_parameters
  final void Function(int columnIndex, bool ascending)? onSort;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: showCheckboxes
            ? const <int, TableColumnWidth>{0: FixedColumnWidth(40)}
            : null,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: showVerticalDividers
            ? TableBorder(
                verticalInside: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.4),
                ),
              )
            : null,
        children: <TableRow>[
          TableRow(
            decoration: BoxDecoration(
              color: headerBackground ?? scheme.surfaceContainerHighest,
            ),
            children: <Widget>[
              if (showCheckboxes) const SizedBox(width: 40, height: 1),
              for (int i = 0; i < columns.length; i++)
                InkWell(
                  onTap: onSort != null
                      ? () {
                          final bool ascending =
                              sortColumnIndex == i ? !sortAscending : true;
                          // ignore: avoid_positional_boolean_parameters
                          onSort!(i, ascending);
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            columns[i],
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: AppFontWeight.bold,
                              color: sortColumnIndex == i
                                  ? AppColors.primary
                                  : scheme.onSurface,
                            ),
                          ),
                          if (sortColumnIndex == i) ...[
                            const SizedBox(width: 4),
                            Icon(
                              sortAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          for (int r = 0; r < rows.length; r++)
            TableRow(
              decoration: alternating && r.isOdd
                  ? BoxDecoration(color: scheme.surfaceContainerLow)
                  : null,
              children: <Widget>[
                if (showCheckboxes)
                  SizedBox(
                    width: 40,
                    height: rowHeight,
                    child: Center(
                      child: Checkbox(
                        value: selectedIndices.contains(r),
                        onChanged: (bool? _) => onRowSelected?.call(r),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                for (int c = 0; c < columns.length; c++)
                  SizedBox(
                    height: rowHeight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Align(
                        alignment: _cellAlignment(rows[r][c]),
                        child: DefaultTextStyle(
                          style: textTheme.bodyMedium!
                              .copyWith(color: scheme.onSurface),
                          child: _cellWidget(rows[r][c]),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  static Widget _cellWidget(dynamic cell) {
    if (cell is DataCell) return cell.child;
    if (cell is TableCellItem) return cell.value;
    if (cell is Widget) return cell;
    return Text(cell.toString());
  }

  static Alignment _cellAlignment(dynamic cell) {
    if (cell is TableCellItem) return _alignment(cell.alignment);
    return Alignment.centerLeft;
  }

  static Alignment _alignment(DataColumnAlignment a) {
    switch (a) {
      case DataColumnAlignment.left:
        return Alignment.centerLeft;
      case DataColumnAlignment.center:
        return Alignment.center;
      case DataColumnAlignment.right:
        return Alignment.centerRight;
    }
  }
}
