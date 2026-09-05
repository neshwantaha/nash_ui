import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class DragDropPage extends StatefulWidget {
  const DragDropPage({super.key});

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  final List<String> _fruits = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry'
  ];

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Drag & Drop',
      icon: Icons.drag_indicator_rounded,
      sections: [
        // ── Reorderable List ────────────────────────────────────────────
        ShowcaseSection(
          title: 'Reorderable List',
          children: [
            const Text(
              'Drag items to reorder them.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: context.isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: DraggableList<String>(
                items: _fruits,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) newIndex -= 1;
                    final String item = _fruits.removeAt(oldIndex);
                    _fruits.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, item, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text('${index + 1}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  title: Text(item),
                  trailing: const Icon(Icons.drag_handle_rounded, size: 20),
                ),
              ),
            ),
          ],
        ),

        // ── Drop Zone ──────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Drop Zone',
          children: [
            const Text(
              'Drag items from below into the drop zone.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            DropZone(
              onAccept: (data) {
                context.showSuccessSnack('Dropped: $data');
              },
              child: const SizedBox(
                height: 120,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline_rounded,
                          size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Drop files here',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Draggable Items ────────────────────────────────────────────
        ShowcaseSection(
          title: 'Draggable Items',
          children: [
            const Text(
              'Drag these chips into the drop zone above.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _fruits
                  .map((fruit) => Draggable(
                        data: fruit,
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                            child: Text(fruit[0],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary)),
                          ),
                          label: Text(fruit),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.small),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
