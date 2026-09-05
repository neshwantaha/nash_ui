import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  // ── Infinite List state ────────────────────────────────────────────────────
  final List<String> _items = List.generate(10, (i) => 'Item ${i + 1}');
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int _loadCount = 0;

  // ── Pagination state ───────────────────────────────────────────────────────
  int _currentPage = 1;

  // ── TreeView selection ─────────────────────────────────────────────────────
  TreeNode<String>? _selectedTreeNode;

  // ── DataTable selection ────────────────────────────────────────────────────
  final Set<int> _selectedRows = {};

  void _loadMore() {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final newItems = List.generate(5, (i) => 'Item ${_items.length + i + 1}');
      setState(() {
        _items.addAll(newItems);
        _loadCount++;
        _isLoadingMore = false;
        if (_loadCount >= 2) _hasMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Lists & Tables',
      icon: Icons.table_rows_rounded,
      sections: [
        // ── Data Table ───────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Data Table',
          children: [
            DataTable(
              columns: const ['Name', 'Role', 'Status'],
              showCheckboxes: true,
              selectedIndices: _selectedRows,
              onRowSelected: (i) => setState(() {
                if (_selectedRows.contains(i)) {
                  _selectedRows.remove(i);
                } else {
                  _selectedRows.add(i);
                }
              }),
              rows: [
                [
                  DataCell(const Text('Nasher Ali')),
                  DataCell(const Text('Flutter Dev')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Active',
                          style: TextStyle(
                              color: AppColors.success, fontSize: 12)),
                    ),
                  ),
                ],
                [
                  DataCell(const Text('Sara Ahmed')),
                  DataCell(const Text('UI Designer')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Pending',
                          style:
                              TextStyle(color: AppColors.amber, fontSize: 12)),
                    ),
                  ),
                ],
                [
                  DataCell(const Text('Omar Hassan')),
                  DataCell(const Text('QA Engineer')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Inactive',
                          style:
                              TextStyle(color: AppColors.error, fontSize: 12)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),

        // ── Infinite List ─────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Infinite List (scroll to load more)',
          children: [
            SizedBox(
              height: 280,
              child: InfiniteList(
                itemCount: _items.length,
                hasMore: _hasMore,
                isLoading: _isLoadingMore,
                onLoadMore: _loadMore,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text('${i + 1}',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(_items[i]),
                  subtitle: const Text('Tap to select'),
                ),
                separator: const Divider(height: 1),
                emptyWidget: Center(
                  child: EmptyState(
                    icon: Icons.list_alt_rounded,
                    title: 'No Items',
                    message: 'Nothing to show here yet.',
                    compact: true,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Pagination ─────────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Pagination',
          children: [
            Pagination(
              currentPage: _currentPage,
              totalPages: 10,
              onPageChanged: (p) => setState(() => _currentPage = p),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Page $_currentPage of 10',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),

        // ── Tree View ─────────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Tree View',
          children: [
            TreeView<String>(
              selectedNode: _selectedTreeNode,
              onNodeSelected: (node) =>
                  setState(() => _selectedTreeNode = node),
              nodes: [
                TreeNode(
                  label: 'lib/',
                  icon: Icons.folder_rounded,
                  isExpanded: true,
                  children: [
                    TreeNode(
                      label: 'widgets/',
                      icon: Icons.folder_open_rounded,
                      isExpanded: true,
                      children: [
                        TreeNode(
                          label: 'buttons.dart',
                          icon: Icons.insert_drive_file_rounded,
                        ),
                        TreeNode(
                          label: 'cards.dart',
                          icon: Icons.insert_drive_file_rounded,
                        ),
                      ],
                    ),
                    TreeNode(
                      label: 'theme.dart',
                      icon: Icons.insert_drive_file_rounded,
                    ),
                  ],
                ),
                TreeNode(
                  label: 'test/',
                  icon: Icons.folder_rounded,
                  children: [
                    TreeNode(
                      label: 'widget_test.dart',
                      icon: Icons.science_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
