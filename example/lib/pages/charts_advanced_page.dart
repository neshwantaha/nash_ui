import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ChartsAdvancedPage extends StatelessWidget {
  const ChartsAdvancedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Advanced Charts',
      icon: Icons.pie_chart_outline_rounded,
      sections: [
        // ── Funnel Chart ───────────────────────────────────────────────
        ShowcaseSection(
          title: 'FunnelChart (Sales Pipeline)',
          children: const [
            Text(
              'Conversion stages with drop-off percentages.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 12),
            FunnelChart(
              height: 200,
              stages: [
                FunnelStage(
                    label: 'Website Visits', value: 12000, percentage: 100),
                FunnelStage(
                    label: 'Product Views', value: 8400, percentage: 70),
                FunnelStage(
                    label: 'Added to Cart', value: 4200, percentage: 35),
                FunnelStage(label: 'Checkout', value: 2400, percentage: 20),
                FunnelStage(label: 'Purchased', value: 1800, percentage: 15),
              ],
            ),
          ],
        ),

        // ── Radar Chart ────────────────────────────────────────────────
        ShowcaseSection(
          title: 'RadarChart (Multi-dimensional)',
          children: const [
            Text(
              'Spider/radar chart for skills, stats, and benchmarks.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Center(
              child: RadarChart(
                size: 260,
                labels: [
                  'Speed',
                  'Power',
                  'Defense',
                  'Agility',
                  'Stamina',
                  'Skill'
                ],
                dataSets: [
                  RadarDataSet(
                    values: [90, 80, 70, 95, 85, 90],
                    color: Color(0xFF6C63FF),
                    fillOpacity: 0.3,
                    label: 'Player A',
                  ),
                  RadarDataSet(
                    values: [75, 95, 85, 70, 80, 75],
                    color: Color(0xFFFF6584),
                    fillOpacity: 0.3,
                    label: 'Player B',
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Heat Map Calendar ──────────────────────────────────────────
        ShowcaseSection(
          title: 'HeatMap (Activity / Commit Graph)',
          children: [
            const Text(
              'GitHub-style contribution & activity matrix.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            HeatMap(
              startDate: DateTime.now().subtract(const Duration(days: 45)),
              data: {
                DateTime.now().subtract(const Duration(days: 1)): 5,
                DateTime.now().subtract(const Duration(days: 2)): 12,
                DateTime.now().subtract(const Duration(days: 5)): 8,
                DateTime.now().subtract(const Duration(days: 9)): 2,
                DateTime.now().subtract(const Duration(days: 14)): 15,
                DateTime.now().subtract(const Duration(days: 20)): 7,
              },
            ),
          ],
        ),
      ],
    );
  }
}
