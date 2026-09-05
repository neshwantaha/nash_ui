import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class TokensPage extends StatefulWidget {
  const TokensPage({super.key});

  @override
  State<TokensPage> createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {
  int _currentPage = 1;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  final Set<int> _selectedRows = <int>{0};

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Data & Developer Tools',
      icon: Icons.token_rounded,
      sections: [
        ShowcaseSection(
          title: 'Code Syntax Block',
          children: const [
            CodeBlock(
              language: 'dart',
              code: '''import 'package:nash_ui/nash_ui.dart'; // All you need!

void main() {
  runApp(
    MaterialApp(
      theme: Theme.dark(),
      home: Scaffold(
        body: Center(
          child: PrimaryButton(
            label: 'Get Started',
            onPressed: () {},
          ),
        ),
      ),
    ),
  );
}''',
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Data Table with Sorting & Selection',
          children: [
            DataTable(
              columns: const ['Name', 'Role', 'Status'],
              showCheckboxes: true,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              onSort: (col, asc) {
                setState(() {
                  _sortColumnIndex = col;
                  _sortAscending = asc;
                });
              },
              selectedIndices: _selectedRows,
              onRowSelected: (r) {
                setState(() {
                  if (_selectedRows.contains(r)) {
                    _selectedRows.remove(r);
                  } else {
                    _selectedRows.add(r);
                  }
                });
              },
              rows: const [
                [
                  DataCell(Text('Nashwan Nheli')),
                  DataCell(Text('Chief Architect')),
                  DataCell(Tag(label: 'Active', color: AppColors.success)),
                ],
                [
                  DataCell(Text('Sarah Al-Mansoor')),
                  DataCell(Text('Lead Designer')),
                  DataCell(Tag(label: 'Active', color: AppColors.success)),
                ],
                [
                  DataCell(Text('Ali Hassan')),
                  DataCell(Text('Senior Engineer')),
                  DataCell(Tag(label: 'Away', color: AppColors.warning)),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: Pagination(
                currentPage: _currentPage,
                totalPages: 10,
                onPageChanged: (p) => setState(() => _currentPage = p),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Hierarchical Tree View',
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: TreeView<String>(
                nodes: [
                  TreeNode<String>(
                    label: 'lib',
                    isExpanded: true,
                    children: [
                      TreeNode<String>(
                        label: 'widgets',
                        isExpanded: true,
                        children: [
                          TreeNode<String>(
                              label: 'command_palette.dart',
                              icon: Icons.code_rounded),
                          TreeNode<String>(
                              label: 'carousel.dart', icon: Icons.code_rounded),
                          TreeNode<String>(
                              label: 'file_upload.dart',
                              icon: Icons.code_rounded),
                        ],
                      ),
                      TreeNode<String>(
                          label: 'nash_ui.dart', icon: Icons.code_rounded),
                    ],
                  ),
                  TreeNode<String>(
                    label: 'pubspec.yaml',
                    icon: Icons.settings_rounded,
                    trailing: const Tag(label: 'v1.0.4'),
                  ),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Resizable Split View',
          children: [
            SizedBox(
              height: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: SplitView(
                  initialRatio: 0.5,
                  firstChild: Container(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    child: const Center(
                      child: Text('Left Panel (Drag divider)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  secondChild: Container(
                    color: AppColors.violet.withValues(alpha: 0.15),
                    child: const Center(
                      child: Text('Right Panel',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Calendar & Expansion Tile',
          children: [
            Calendar(
              onSelected: (_) {},
            ),
            const SizedBox(height: 12),
            const ExpansionTile(
              title: Text('What is Nash UI?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                      'Nash UI is a modern, scalable Flutter Design System '
                      'built on Material 3, providing everything you need '
                      'to ship beautiful apps faster.'),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Context Shortcuts & Duration Tokens',
          children: [
            _ExtensionRow('context.isDark', context.isDark.toString()),
            _ExtensionRow('context.isLight', context.isLight.toString()),
            _ExtensionRow('context.primaryColor',
                '#${context.primaryColor.toARGB32().toRadixString(16).toUpperCase()}'),
            _ExtensionRow(
                'AppDuration.fast', '${AppDuration.fast.inMilliseconds}ms'),
            _ExtensionRow(
                'AppDuration.normal', '${AppDuration.normal.inMilliseconds}ms'),
            _ExtensionRow(
                'AppDuration.slow', '${AppDuration.slow.inMilliseconds}ms'),
            _ExtensionRow('"hello world".capitalize', 'hello world'.capitalize),
          ],
        ),
      ],
    );
  }
}

class _ExtensionRow extends StatelessWidget {
  const _ExtensionRow(this.name, this.value);
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
                style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: AppColors.primary)),
          ),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
