import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Themes & Colors',
      icon: Icons.palette_rounded,
      sections: [
        ShowcaseSection(
          title: 'Gradient Presets',
          children: [
            _GradientTile('Primary Gradient', AppGradients.primary),
            const SizedBox(height: 10),
            _GradientTile('Ocean Gradient', AppGradients.ocean),
            const SizedBox(height: 10),
            _GradientTile('Emerald Gradient', AppGradients.emerald),
            const SizedBox(height: 10),
            _GradientTile('Cyberpunk Gradient', AppGradients.cyberpunk),
          ],
        ),
        ShowcaseSection(
          title: 'Accent Colors',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ColorChip('Primary', AppColors.primary),
                _ColorChip('Violet', AppColors.violet),
                _ColorChip('Emerald', AppColors.emerald),
                _ColorChip('Rose', AppColors.rose),
                _ColorChip('Amber', AppColors.amber),
                _ColorChip('Cyan', AppColors.cyan),
                _ColorChip('Pink', AppColors.pink),
                _ColorChip('Error', AppColors.error),
                _ColorChip('Warning', AppColors.warning),
                _ColorChip('Success', AppColors.success),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Typography Scale',
          children: [
            ...[
              ('Display Large', context.textTheme.displayLarge),
              ('Headline Medium', context.textTheme.headlineMedium),
              ('Title Large', context.textTheme.titleLarge),
              ('Body Large', context.textTheme.bodyLarge),
              ('Body Medium', context.textTheme.bodyMedium),
              ('Label Small', context.textTheme.labelSmall),
            ].map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(e.$1, style: e.$2),
                )),
          ],
        ),
        ShowcaseSection(
          title: 'Spacing & Radius Tokens',
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _tokenRow('xs', AppSpacing.xs),
                _tokenRow('sm', AppSpacing.sm),
                _tokenRow('md', AppSpacing.md),
                _tokenRow('lg', AppSpacing.lg),
                _tokenRow('xl', AppSpacing.xl),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TableRow _tokenRow(String name, double value) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child:
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: value,
                  height: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('${value.toStringAsFixed(0)}px'),
              ],
            ),
          ),
        ],
      );
}

class _GradientTile extends StatelessWidget {
  const _GradientTile(this.label, this.gradient);
  final String label;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
