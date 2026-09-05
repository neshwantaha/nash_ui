import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class NewFeaturesPage extends StatefulWidget {
  const NewFeaturesPage({super.key});

  @override
  State<NewFeaturesPage> createState() => _NewFeaturesPageState();
}

class _NewFeaturesPageState extends State<NewFeaturesPage> {
  bool _switchValue = true;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  final Set<int> _selectedRows = <int>{};

  @override
  Widget build(BuildContext context) {
    return NotificationCenter(
      child: ShowcasePage(
        title: 'New Features',
        icon: Icons.auto_awesome_rounded,
        sections: [
          // ── In-App Notifications ──────────────────────────────────────
          ShowcaseSection(
            title: 'In-App Notifications',
            children: [
              const Text(
                'Push-style notifications using NotificationCenter.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _NotifButton(
                    label: 'Info',
                    color: AppColors.info,
                    icon: Icons.info_outline_rounded,
                    onPressed: () {
                      NotificationCenter.of(context).show(
                        const Notification(
                          title: 'Info',
                          body: 'This is an informational notification.',
                          type: NotificationType.info,
                        ),
                      );
                    },
                  ),
                  _NotifButton(
                    label: 'Success',
                    color: AppColors.success,
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: () {
                      NotificationCenter.of(context).show(
                        const Notification(
                          title: 'Success',
                          body: 'Operation completed successfully!',
                          type: NotificationType.success,
                        ),
                      );
                    },
                  ),
                  _NotifButton(
                    label: 'Warning',
                    color: AppColors.warning,
                    icon: Icons.warning_amber_rounded,
                    onPressed: () {
                      NotificationCenter.of(context).show(
                        const Notification(
                          title: 'Warning',
                          body: 'Your session will expire soon.',
                          type: NotificationType.warning,
                        ),
                      );
                    },
                  ),
                  _NotifButton(
                    label: 'Error',
                    color: AppColors.error,
                    icon: Icons.error_outline_rounded,
                    onPressed: () {
                      NotificationCenter.of(context).show(
                        const Notification(
                          title: 'Error',
                          body: 'Failed to save changes.',
                          type: NotificationType.error,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── Enhanced Data Table ────────────────────────────────────────
          ShowcaseSection(
            title: 'Enhanced Data Table',
            children: [
              EnhancedDataTable(
                selectable: true,
                exportEnabled: true,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                onSort: (col, asc) {
                  setState(() {
                    _sortColumnIndex = col;
                    _sortAscending = asc;
                  });
                },
                selectedRows: _selectedRows,
                onSelectionChanged: (selected) {
                  setState(() {
                    _selectedRows
                      ..clear()
                      ..addAll(selected);
                  });
                },
                columns: const [
                  DataColumn(label: 'Name', sortable: true),
                  DataColumn(label: 'Email'),
                  DataColumn(label: 'Role', sortable: true),
                  DataColumn(label: 'Status'),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Nashwan Nheli')),
                    DataCell(Text('nash@company.com')),
                    DataCell(Text('Chief Architect')),
                    DataCell(Tag(label: 'Active', color: AppColors.success)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Sarah Al-Mansoor')),
                    DataCell(Text('sarah@company.com')),
                    DataCell(Text('Lead Designer')),
                    DataCell(Tag(label: 'Active', color: AppColors.success)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Ali Hassan')),
                    DataCell(Text('ali@company.com')),
                    DataCell(Text('Senior Engineer')),
                    DataCell(Tag(label: 'Away', color: AppColors.warning)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Mona Youssef')),
                    DataCell(Text('mona@company.com')),
                    DataCell(Text('Product Manager')),
                    DataCell(Tag(label: 'Active', color: AppColors.success)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Omar Saeed')),
                    DataCell(Text('omar@company.com')),
                    DataCell(Text('DevOps Lead')),
                    DataCell(Tag(label: 'Offline', color: AppColors.error)),
                  ]),
                ],
              ),
            ],
          ),

          // ── Adaptive Widgets ───────────────────────────────────────────
          ShowcaseSection(
            title: 'Adaptive Widgets',
            children: [
              Row(
                children: [
                  const Text('NashAdaptiveSwitch:',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(width: 12),
                  AdaptiveSwitch(
                    value: _switchValue,
                    onChanged: (v) => setState(() => _switchValue = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('NashAdaptiveProgress:',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(width: 12),
                  AdaptiveProgress(size: 28),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  PrimaryButton(
                    label: 'Confirm Dialog',
                    icon: Icons.question_answer_rounded,
                    onPressed: () async {
                      final confirmed = await AdaptiveDialog.confirm(
                        context: context,
                        title: 'Delete item?',
                        message: 'This action cannot be undone.',
                        confirmText: 'Delete',
                        isDestructive: true,
                      );
                      if (context.mounted) {
                        context
                            .showSnack(confirmed ? 'Confirmed' : 'Cancelled');
                      }
                    },
                  ),
                  PrimaryButton(
                    label: 'Action Sheet',
                    icon: Icons.menu_rounded,
                    onPressed: () async {
                      final index = await AdaptiveActionSheet.show(
                        context: context,
                        title: 'Choose an action',
                        actions: ['Edit', 'Share', 'Duplicate', 'Delete'],
                      );
                      if (context.mounted && index != null) {
                        context.showSnack('Selected action: $index');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── Responsive Typography ──────────────────────────────────────
          ShowcaseSection(
            title: 'Responsive Typography',
            children: [
              const Text(
                'Scales text based on screen width (design ref: 390dp).',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                'Display Large',
                style: ResponsiveTypography.displayLarge(context),
              ),
              const SizedBox(height: 6),
              Text(
                'Headline Medium',
                style: ResponsiveTypography.headlineMedium(context),
              ),
              const SizedBox(height: 6),
              Text(
                'Title Large',
                style: ResponsiveTypography.titleLarge(context),
              ),
              const SizedBox(height: 6),
              Text(
                'Body Medium — This is scaled body text.',
                style: ResponsiveTypography.bodyMedium(context),
              ),
              const SizedBox(height: 6),
              Text(
                'Label Small',
                style: ResponsiveTypography.labelSmall(context),
              ),
              const SizedBox(height: 12),
              Text(
                'Scaled font size: ${ResponsiveTypography.scaledFontSize(context, base: 16).toStringAsFixed(1)}dp',
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: AppColors.primary),
              ),
            ],
          ),

          // ── Reduced Motion ─────────────────────────────────────────────
          ShowcaseSection(
            title: 'Reduced Motion',
            children: [
              Text(
                'Reduced motion active: ${ReducedMotion.of(context)}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 12),
              ReducedMotionWrapper(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: const Text('Static content (no animation)'),
                ),
                animatedChild: _AnimatedBox(),
              ),
            ],
          ),

          // ── Elevation & Z-Index Tokens ─────────────────────────────────
          ShowcaseSection(
            title: 'Elevation & Z-Index Tokens',
            children: [
              const Text(
                'Material elevation values:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ElevationCard(label: 'dp1', elevation: AppElevation.dp1),
                  _ElevationCard(label: 'dp2', elevation: AppElevation.dp2),
                  _ElevationCard(label: 'dp4', elevation: AppElevation.dp4),
                  _ElevationCard(label: 'dp8', elevation: AppElevation.dp8),
                  _ElevationCard(label: 'dp12', elevation: AppElevation.dp12),
                  _ElevationCard(label: 'dp16', elevation: AppElevation.dp16),
                  _ElevationCard(label: 'dp24', elevation: AppElevation.dp24),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Z-Index values:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _ZIndexBadge(label: 'base', value: AppElevation.base),
                  _ZIndexBadge(label: 'raised', value: AppElevation.raised),
                  _ZIndexBadge(label: 'dropdown', value: AppElevation.dropdown),
                  _ZIndexBadge(label: 'sticky', value: AppElevation.sticky),
                  _ZIndexBadge(label: 'fixed', value: AppElevation.fixed),
                  _ZIndexBadge(label: 'modal', value: AppElevation.modal),
                  _ZIndexBadge(label: 'tooltip', value: AppElevation.tooltip),
                ],
              ),
              const SizedBox(height: 12),
              ZIndexed(
                index: AppElevation.raised,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Text('NashZIndexed widget (index: raised)',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),

          // ── Localization ───────────────────────────────────────────────
          ShowcaseSection(
            title: 'Localization',
            children: [
              const Text(
                'NashLocalizations provides number, currency, and date formatting.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const _LocRow(label: 'formatNumber(1234567)', value: '1,234,567'),
              const _LocRow(label: 'formatCurrency(49.99)', value: '\$49.99'),
              const _LocRow(label: 'formatCompact(1500000)', value: '1.5M'),
              const _LocRow(
                  label: 'formatDate(DateTime.now())', value: 'Aug 19, 2026'),
              const _LocRow(
                  label: 'formatTime(DateTime.now())', value: '14:30'),
            ],
          ),

          // ── Token Exporter ─────────────────────────────────────────────
          ShowcaseSection(
            title: 'Token Exporter',
            children: [
              const Text(
                'Export all design tokens as structured data.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Export Tokens (Markdown)',
                icon: Icons.code_rounded,
                onPressed: () {
                  final markdown = TokenExporter.exportMarkdown();
                  showDialog(
                    context: context,
                    builder: (ctx) => Dialog(
                      title: 'Token Export',
                      subtitle: 'Design tokens as Markdown',
                      icon: Icons.token_rounded,
                      content: SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: SelectableText(
                            markdown,
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          label: 'Close',
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        PrimaryButton(
                          label: 'Copy',
                          icon: Icons.copy_rounded,
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.showSuccessSnack('Tokens exported!');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'exportAll() returns a Map<String, dynamic> with all token categories.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),

          // ── AppMasonry ────────────────────────────────────────────────
          ShowcaseSection(
            title: 'AppMasonry',
            children: [
              const Text(
                'Self-balancing masonry layout with fixed or adaptive columns.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: AppMasonry(
                  itemCount: 8,
                  columnCount: 4,
                  itemBuilder: (context, index) {
                    final heights = [
                      70.0,
                      110.0,
                      90.0,
                      130.0,
                      80.0,
                      120.0,
                      100.0,
                      140.0
                    ];
                    return Container(
                      height: heights[index % heights.length],
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.85),
                            AppColors.primaryLight.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Item $index',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ── AppReactiveForm ───────────────────────────────────────────
          ShowcaseSection(
            title: 'Reactive Form',
            children: [
              const Text(
                'Fully reactive form with observable fields and validity.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const _ReactiveFormDemo(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReactiveFormDemo extends StatefulWidget {
  const _ReactiveFormDemo();

  @override
  State<_ReactiveFormDemo> createState() => _ReactiveFormDemoState();
}

class _ReactiveFormDemoState extends State<_ReactiveFormDemo> {
  late final ReactiveFormController _form;
  final email = reactiveText(validators: [V.required, V.email]);
  final password = reactiveText(
    validators: [
      V.required,
      (v) => (v != null && v.length < 6) ? 'Min 6 characters' : null,
    ],
  );

  String? _result;

  @override
  void initState() {
    super.initState();
    _form = ReactiveFormController();
    _form.add('email', email);
    _form.add('password', password);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _form.valid,
      builder: (context, valid, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: email.value,
              builder: (context, value, _) => TextField(
                label: 'Email',
                hint: 'you@example.com',
                initialValue: value,
                onChanged: email.update,
                errorText: email.currentError,
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: password.value,
              builder: (context, value, _) => PasswordField(
                label: 'Password',
                onChanged: password.update,
              ),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Submit',
              onPressed: valid
                  ? () {
                      _form.submit();
                      setState(() => _result = 'Valid! e=${email.value.value}');
                    }
                  : null,
            ),
            if (_result != null) ...[
              const SizedBox(height: 10),
              Text(_result!,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.success)),
            ],
          ],
        );
      },
    );
  }
}

class _NotifButton extends StatelessWidget {
  const _NotifButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _AnimatedBox extends StatefulWidget {
  @override
  State<_AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<_AnimatedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: 50,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: const Center(
            child: Text('Animated box',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }
}

class _ElevationCard extends StatelessWidget {
  const _ElevationCard({required this.label, required this.elevation});

  final String label;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: Center(
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _ZIndexBadge extends StatelessWidget {
  const _ZIndexBadge({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
            fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LocRow extends StatelessWidget {
  const _LocRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
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
