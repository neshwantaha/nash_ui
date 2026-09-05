import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class UxPage extends StatelessWidget {
  const UxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'UX States',
      icon: Icons.widgets_rounded,
      sections: [
        // ── Toast ─────────────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Toast Notifications',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ToastButton(
                  label: 'Success',
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Changes saved successfully!',
                    type: ToastType.success,
                  ),
                ),
                _ToastButton(
                  label: 'Error',
                  color: AppColors.error,
                  icon: Icons.error_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Upload failed. Try again.',
                    type: ToastType.error,
                  ),
                ),
                _ToastButton(
                  label: 'Warning',
                  color: AppColors.warning,
                  icon: Icons.warning_amber_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Storage almost full.',
                    type: ToastType.warning,
                  ),
                ),
                _ToastButton(
                  label: 'Info',
                  color: AppColors.cyan,
                  icon: Icons.info_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Update available in the store.',
                    type: ToastType.info,
                  ),
                ),
                _ToastButton(
                  label: 'With Action',
                  color: AppColors.violet,
                  icon: Icons.touch_app_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Message deleted.',
                    type: ToastType.neutral,
                    actionLabel: 'Undo',
                    onAction: () {},
                  ),
                ),
                _ToastButton(
                  label: 'Bottom',
                  color: AppColors.primary,
                  icon: Icons.vertical_align_bottom_rounded,
                  onPressed: () => Toast.show(
                    context,
                    'Shown at the bottom.',
                    type: ToastType.info,
                    position: ToastPosition.bottom,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Error Boundary ────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Error Boundary',
          children: [
            // Healthy widget wrapped in boundary
            ErrorBoundary(
              onError: (e, s) => debugPrint('Caught: $e'),
              child: _StableWidget(),
            ),
            const SizedBox(height: 12),
            // Simulated caught-error fallback (without actually crashing)
            ErrorBoundary(
              title: 'Something went wrong',
              subtitle: 'This widget simulates a caught build error.',
              child: _SimulatedErrorWidget(),
            ),
          ],
        ),

        // ── Success State ─────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Success State',
          children: [
            SuccessState(
              title: 'Payment Complete',
              message: 'Your order has been placed successfully.',
              actionLabel: 'View Order',
              onAction: () {},
            ),
          ],
        ),

        // ── Offline State ─────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Offline State',
          children: [
            OfflineState(onRetry: () {}),
          ],
        ),

        // ── Permission State ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'Permission State',
          children: [
            PermissionState(
              title: 'Camera Access Required',
              message: 'Allow Nash UI to access your camera to scan QR codes.',
              icon: Icons.camera_alt_rounded,
              onAllow: () {},
              onDeny: () {},
            ),
          ],
        ),

        // ── Maintenance State ─────────────────────────────────────────────
        ShowcaseSection(
          title: 'Maintenance State',
          children: [
            const MaintenanceState(
              estimatedTime: '15:00 UTC',
            ),
          ],
        ),

        // ── Update State ──────────────────────────────────────────────────
        ShowcaseSection(
          title: 'Update Required State',
          children: [
            UpdateState(
              onUpdate: () {},
              onLater: () {},
            ),
          ],
        ),

        // ── 404 Not Found State ───────────────────────────────────────────
        ShowcaseSection(
          title: '404 — Not Found State',
          children: [
            NotFoundState(
              onAction: () {},
            ),
          ],
        ),
      ],
    );
  }
}

// ── Helper widgets ──────────────────────────────────────────────────────────

class _ToastButton extends StatelessWidget {
  const _ToastButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// A healthy widget showing the ErrorBoundary is working.
class _StableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'This widget renders normally — ErrorBoundary is satisfied.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simulates what the ErrorBoundary shows when a child widget crashes,
/// without actually throwing during build (safe for showcase).
class _SimulatedErrorWidget extends StatefulWidget {
  @override
  State<_SimulatedErrorWidget> createState() => _SimulatedErrorWidgetState();
}

class _SimulatedErrorWidgetState extends State<_SimulatedErrorWidget> {
  bool _thrown = false;

  @override
  void initState() {
    super.initState();
    // Trigger the error after the first frame so NashErrorBoundary catches it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _thrown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_thrown) throw Exception('Simulated widget build error');
    return const SizedBox.shrink();
  }
}
