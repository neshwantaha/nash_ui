import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Feedback',
      icon: Icons.feedback_rounded,
      sections: [
        ShowcaseSection(
          title: 'Snackbars',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SnackButton(
                  label: 'Success',
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  onPressed: () =>
                      context.showSuccessSnack('Saved successfully!'),
                ),
                _SnackButton(
                  label: 'Error',
                  color: AppColors.error,
                  icon: Icons.error_outline_rounded,
                  onPressed: () =>
                      context.showErrorSnack('Something went wrong.'),
                ),
                _SnackButton(
                  label: 'Warning',
                  color: AppColors.warning,
                  icon: Icons.warning_amber_rounded,
                  onPressed: () =>
                      context.showWarningSnack('Low storage space.'),
                ),
                _SnackButton(
                  label: 'Standard',
                  color: const Color(0xFF1E293B),
                  icon: Icons.info_outline_rounded,
                  onPressed: () => context.showSnack('Update available.'),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Tooltip',
          children: [
            Tooltip(
              message: 'This is a Nash UI tooltip',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Text('Hover / long-press me'),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Banner',
          children: [
            Banner(
              message: 'Your trial expires in 3 days.',
              type: AppFeedbackType.warning,
              onDismiss: () {},
            ),
            const SizedBox(height: 10),
            Banner(
              message: 'All systems operational.',
              type: AppFeedbackType.success,
              onDismiss: () {},
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Rating',
          children: const [
            Rating(value: 4.5, count: '128', showValue: true),
          ],
        ),
        ShowcaseSection(
          title: 'Badge',
          children: [
            Row(
              children: [
                Badge(
                  count: 5,
                  child: const Icon(Icons.notifications_rounded, size: 32),
                ),
                const SizedBox(width: 32),
                Badge(
                  count: 99,
                  child: const Icon(Icons.mail_rounded, size: 32),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Tag',
          children: [
            Wrap(
              spacing: 8,
              children: [
                Tag(label: 'Flutter', onRemoved: () {}),
                Tag(label: 'Dart', color: AppColors.violet, onRemoved: () {}),
                Tag(
                    label: 'Firebase',
                    color: AppColors.amber,
                    onRemoved: () {}),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Toast Notifications',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SnackButton(
                  label: 'Toast Success',
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Profile updated!',
                    type: ToastType.success,
                  ),
                ),
                _SnackButton(
                  label: 'Toast Error',
                  color: AppColors.error,
                  icon: Icons.error_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Network request failed.',
                    type: ToastType.error,
                  ),
                ),
                _SnackButton(
                  label: 'Toast (Bottom)',
                  color: AppColors.cyan,
                  icon: Icons.info_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Tap to learn more.',
                    type: ToastType.info,
                    position: ToastPosition.bottom,
                    actionLabel: 'Dismiss',
                    onAction: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Connectivity Banner (simulated)',
          children: [
            Banner(
              message: '⚠  You are offline — showing cached data.',
              type: AppFeedbackType.warning,
              onDismiss: () {},
            ),
            const SizedBox(height: 8),
            const Text(
              'Wrap your app root with NashConnectivityBanner for automatic online/offline detection.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

/// A small colored button used to trigger a typed snackbar demo.
class _SnackButton extends StatelessWidget {
  const _SnackButton({
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
