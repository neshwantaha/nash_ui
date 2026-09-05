import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Loading & Skeletons',
      icon: Icons.hourglass_top_rounded,
      sections: [
        ShowcaseSection(
          title: 'Circular Progress',
          children: const [
            Row(
              children: [
                CircularProgress(value: null),
                SizedBox(width: 24),
                CircularProgress(value: 0.75, color: AppColors.emerald),
                SizedBox(width: 24),
                CircularProgress(value: 0.40, color: AppColors.rose),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Linear Progress',
          children: const [
            LinearProgress(value: null),
            SizedBox(height: 12),
            LinearProgress(value: 0.6, color: AppColors.emerald),
            SizedBox(height: 12),
            LinearProgress(value: 0.3, color: AppColors.amber),
          ],
        ),
        ShowcaseSection(
          title: 'Loader (Spinner)',
          children: const [
            Row(
              children: [
                Loader(),
                SizedBox(width: 24),
                Loader(color: AppColors.violet, size: 40),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Shimmer Effect',
          children: [
            Shimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 18,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Skeleton List',
          children: const [
            SkeletonList(itemCount: 3),
          ],
        ),
        ShowcaseSection(
          title: 'Loading Screen',
          children: const [
            SizedBox(
              height: 180,
              child: LoadingScreen(title: 'Fetching dashboard metrics…'),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Empty State',
          children: [
            Center(
              child: EmptyState(
                icon: Icons.inbox_rounded,
                title: 'No Messages',
                message: 'Your inbox is completely empty.',
                actionLabel: 'Compose',
                onAction: () {},
                compact: true,
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Offline State',
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: OfflineState(onRetry: () {}),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
