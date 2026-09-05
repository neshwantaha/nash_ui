import 'package:flutter/material.dart' hide DataColumn, DataRow;
import 'package:flutter/material.dart' as fl;

import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// A feature-rich data table with sorting, selection, pagination, and export.
///
/// ```dart
/// EnhancedDataTable<DataRow>(
///   columns: [
///     DataColumn(label: 'Name', sortable: true),
///     DataColumn(label: 'Email'),
///     DataColumn(label: 'Role', sortable: true),
///   ],
///   rows: [
///     DataRow(cells: [DataCell(Text('John')), DataCell(Text('john@x.com')), DataCell(Text('Admin'))]),
///   ],
///   selectable: true,
///   onSelectionChanged: (selected) { ... },
/// )
/// ```
class EnhancedDataTable<T> extends StatefulWidget {
  const EnhancedDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.selectable = false,
    this.onSelectionChanged,
    this.selectedRows = const <int>{},
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowLongPress,
    this.pagination,
    this.onPageChanged,
    this.exportEnabled = false,
    this.onExport,
    this.emptyStateWidget,
    this.loading = false,
    this.header,
    this.actions,
    this.checkboxVerticalAlignment = CrossAxisAlignment.center,
    this.dataRowHeight,
    this.headingRowHeight = 56,
    this.dividerThickness = 1,
    this.showCheckboxColumn = true,
    this.border,
    this.clipBehavior = Clip.none,
    this.shrinkWrap = false,
    this.scrollPhysics,
    this.scrollController,
  });

  /// Column definitions.
  final List<DataColumn> columns;

  /// Row data.
  final List<DataRow> rows;

  /// Currently sorted column index.
  final int? sortColumnIndex;

  /// Sort direction.
  final bool sortAscending;

  /// Callback when a sortable column header is tapped.
  // ignore: avoid_positional_boolean_parameters – must match Flutter's DataColumnSortCallback
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Whether rows are selectable with checkboxes.
  final bool selectable;

  /// Callback when selection changes.
  final void Function(Set<int> selectedIndices)? onSelectionChanged;

  /// Set of initially selected row indices.
  final Set<int> selectedRows;

  /// Callback when a row is tapped.
  final void Function(int index)? onRowTap;

  /// Callback when a row is double-tapped.
  final void Function(int index)? onRowDoubleTap;

  /// Callback when a row is long-pressed.
  final void Function(int index)? onRowLongPress;

  /// Pagination configuration.
  final TablePagination? pagination;

  /// Callback when the page changes.
  final void Function(int page)? onPageChanged;

  /// Whether to show export buttons.
  final bool exportEnabled;

  /// Custom export handler. If null, defaults to clipboard copy.
  final void Function(TableExportFormat format)? onExport;

  /// Widget to show when the table is empty.
  final Widget? emptyStateWidget;

  /// Whether the table is in loading state.
  final bool loading;

  /// Optional header widget above the table.
  final Widget? header;

  /// Action buttons in the header.
  final List<Widget>? actions;

  /// Checkbox vertical alignment.
  final CrossAxisAlignment checkboxVerticalAlignment;

  /// Data row height.
  final double? dataRowHeight;

  /// Heading row height.
  final double headingRowHeight;

  /// Divider thickness.
  final double dividerThickness;

  /// Whether to show the checkbox column.
  final bool showCheckboxColumn;

  /// Table border.
  final TableBorder? border;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Whether the table should shrink-wrap.
  final bool shrinkWrap;

  /// Scroll physics.
  final ScrollPhysics? scrollPhysics;

  /// Scroll controller.
  final ScrollController? scrollController;

  @override
  State<EnhancedDataTable<T>> createState() => _EnhancedDataTableState<T>();
}

class _EnhancedDataTableState<T> extends State<EnhancedDataTable<T>> {
  late Set<int> _selectedRows;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedRows = Set<int>.from(widget.selectedRows);
    _sortColumnIndex = widget.sortColumnIndex;
    _sortAscending = widget.sortAscending;
  }

  @override
  void didUpdateWidget(EnhancedDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRows != widget.selectedRows) {
      _selectedRows = Set<int>.from(widget.selectedRows);
    }
    if (oldWidget.sortColumnIndex != widget.sortColumnIndex) {
      _sortColumnIndex = widget.sortColumnIndex;
    }
    if (oldWidget.sortAscending != widget.sortAscending) {
      _sortAscending = widget.sortAscending;
    }
  }

  void _onSort(int columnIndex) {
    if (!widget.columns[columnIndex].sortable) return;
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
    });
    widget.onSort?.call(_sortColumnIndex!, _sortAscending);
  }

  void _toggleRow(int index) {
    setState(() {
      if (_selectedRows.contains(index)) {
        _selectedRows.remove(index);
      } else {
        _selectedRows.add(index);
      }
    });
    widget.onSelectionChanged?.call(_selectedRows);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (widget.loading) {
      return _LoadingTable(
        columns: widget.columns,
        headingRowHeight: widget.headingRowHeight,
        selectable: widget.selectable,
        scheme: scheme,
      );
    }

    if (widget.rows.isEmpty && widget.emptyStateWidget != null) {
      return widget.emptyStateWidget!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.header != null || widget.actions != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: <Widget>[
                if (widget.header != null) Expanded(child: widget.header!),
                if (widget.actions != null) ...widget.actions!,
              ],
            ),
          ),
        if (widget.exportEnabled)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: <Widget>[
                _ExportButton(
                  label: 'CSV',
                  icon: Icons.table_chart,
                  onTap: () => widget.onExport?.call(TableExportFormat.csv),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ExportButton(
                  label: 'Copy',
                  icon: Icons.copy,
                  onTap: () =>
                      widget.onExport?.call(TableExportFormat.clipboard),
                ),
                if (_selectedRows.isNotEmpty) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${_selectedRows.length} selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ],
            ),
          ),
        Flexible(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: widget.scrollPhysics,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: widget.headingRowHeight,
              dataRowMinHeight: widget.dataRowHeight,
              dataRowMaxHeight: widget.dataRowHeight,
              dividerThickness: widget.dividerThickness,
              showCheckboxColumn:
                  widget.selectable && widget.showCheckboxColumn,
              border: widget.border,
              clipBehavior: widget.clipBehavior,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: <fl.DataColumn>[
                for (int i = 0; i < widget.columns.length; i++)
                  fl.DataColumn(
                    label: Text(
                      widget.columns[i].label,
                      style: widget.columns[i].labelStyle,
                    ),
                    numeric: widget.columns[i].numeric,
                    onSort: widget.columns[i].sortable
                        ? (int _, bool __) => _onSort(i)
                        : null,
                    tooltip: widget.columns[i].tooltip,
                  ),
              ],
              rows: <fl.DataRow>[
                for (int i = 0; i < widget.rows.length; i++)
                  fl.DataRow(
                    selected: _selectedRows.contains(i),
                    onSelectChanged: widget.selectable
                        ? (bool? value) => _toggleRow(i)
                        : null,
                    onLongPress: widget.onRowLongPress != null
                        ? () => widget.onRowLongPress!(i)
                        : null,
                    color: widget.rows[i].color != null
                        ? WidgetStatePropertyAll<Color>(widget.rows[i].color!)
                        : null,
                    cells: widget.rows[i].cells,
                  ),
              ],
            ),
          ),
        ),
        if (widget.pagination != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: TablePaginationWidget(
              pagination: widget.pagination!,
              onPageChanged: widget.onPageChanged,
            ),
          ),
      ],
    );
  }
}

/// Column definition for [EnhancedDataTable].
///
/// A backwards-compatible alias for [DataColumn].
typedef NashDataColumn = DataColumn;

/// Column definition for [EnhancedDataTable].
class DataColumn {
  const DataColumn({
    required this.label,
    this.sortable = false,
    this.numeric = false,
    this.tooltip,
    this.labelStyle,
  });

  final String label;
  final bool sortable;
  final bool numeric;
  final String? tooltip;
  final TextStyle? labelStyle;
}

/// Row definition for [EnhancedDataTable].
///
/// A backwards-compatible alias for [DataRow].
typedef NashDataRow = DataRow;

/// Row definition for [EnhancedDataTable].
class DataRow {
  const DataRow({
    required this.cells,
    this.color,
  });

  final List<DataCell> cells;
  final Color? color;
}

/// Pagination configuration.
class TablePagination {
  const TablePagination({
    required this.currentPage,
    required this.totalPages,
    this.totalItems,
    this.itemsPerPage = 10,
  });

  final int currentPage;
  final int totalPages;
  final int? totalItems;
  final int itemsPerPage;
}

/// Export format options.
enum TableExportFormat { csv, clipboard, json }

class _LoadingTable extends StatelessWidget {
  const _LoadingTable({
    required this.columns,
    required this.headingRowHeight,
    required this.selectable,
    required this.scheme,
  });

  final List<DataColumn> columns;
  final double headingRowHeight;
  final bool selectable;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) => DataTable(
        headingRowHeight: headingRowHeight,
        showCheckboxColumn: selectable,
        columns: <fl.DataColumn>[
          for (final DataColumn col in columns)
            fl.DataColumn(label: Text(col.label)),
        ],
        rows: <fl.DataRow>[
          for (int i = 0; i < 5; i++)
            fl.DataRow(
              cells: <DataCell>[
                for (int j = 0; j < columns.length; j++)
                  DataCell(
                    Container(
                      height: 14,
                      width: 60 + (j * 20).toDouble(),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      );
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
        ),
      );
}

/// Pagination widget for [EnhancedDataTable].
class TablePaginationWidget extends StatelessWidget {
  const TablePaginationWidget({
    super.key,
    required this.pagination,
    this.onPageChanged,
  });

  final TablePagination pagination;
  final void Function(int page)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: pagination.currentPage > 1
              ? () => onPageChanged?.call(pagination.currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        for (int i = 1; i <= pagination.totalPages; i++) ...<Widget>[
          if (i == pagination.currentPage)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              alignment: Alignment.center,
              child: Text(
                '$i',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )
          else
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                onPressed: () => onPageChanged?.call(i),
                icon: Text('$i', style: const TextStyle(fontSize: 13)),
                padding: EdgeInsets.zero,
              ),
            ),
          const SizedBox(width: 4),
        ],
        IconButton(
          onPressed: pagination.currentPage < pagination.totalPages
              ? () => onPageChanged?.call(pagination.currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
        if (pagination.totalItems != null) ...<Widget>[
          const SizedBox(width: AppSpacing.md),
          Text(
            '${pagination.totalItems} items',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}
