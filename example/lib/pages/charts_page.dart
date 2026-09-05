import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Charts',
      icon: Icons.bar_chart_rounded,
      sections: [
        ShowcaseSection(
          title: 'Line Chart',
          children: const [
            LineChart(
              points: [
                ChartPoint(0, 30),
                ChartPoint(1, 55),
                ChartPoint(2, 40),
                ChartPoint(3, 70),
                ChartPoint(4, 60),
                ChartPoint(5, 90),
                ChartPoint(6, 75),
              ],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
              color: AppColors.primary,
              height: 180,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Bar Chart',
          children: [
            BarChart(
              bars: const [
                BarData(label: 'Mon', value: 40),
                BarData(label: 'Tue', value: 65),
                BarData(label: 'Wed', value: 30),
                BarData(label: 'Thu', value: 80),
                BarData(label: 'Fri', value: 55),
                BarData(label: 'Sat', value: 70),
                BarData(label: 'Sun', value: 45),
              ],
              height: 180,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Pie / Donut Chart',
          children: [
            PieChart(
              segments: const [
                PieSegment(
                    label: 'Design', value: 35, color: Color(0xFF7C3AED)),
                PieSegment(label: 'Dev', value: 40, color: Color(0xFF06B6D4)),
                PieSegment(
                    label: 'Testing', value: 15, color: Color(0xFF10B981)),
                PieSegment(
                    label: 'DevOps', value: 10, color: Color(0xFFF59E0B)),
              ],
              size: 160,
            ),
          ],
        ),
      ],
    );
  }
}
