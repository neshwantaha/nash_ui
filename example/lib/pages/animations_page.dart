import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class AnimationsPage extends StatelessWidget {
  const AnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Animations',
      icon: Icons.animation_rounded,
      sections: [
        ShowcaseSection(
          title: 'Slide Animation',
          children: [
            SlideAnimation(
              direction: SlideAnimationDirection.up,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward_rounded, color: AppColors.violet),
                      const SizedBox(width: 12),
                      const Text('Slid in from bottom'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Scale Animation',
          children: [
            ScaleAnimation(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.zoom_in_rounded, color: AppColors.rose),
                      const SizedBox(width: 12),
                      const Text('Scaled in on load'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Rotate Animation',
          children: [
            RotateAnimation(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded, color: AppColors.emerald),
                      const SizedBox(width: 12),
                      const Text('Rotated in smoothly'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Hover Effect',
          children: [
            HoverEffect(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.mouse_rounded, color: AppColors.cyan),
                      const SizedBox(width: 12),
                      const Text('Hover or tap for elevation lift'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Ripple Effect',
          children: [
            Ripple(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                alignment: Alignment.center,
                child: const Text('Pulsing ripple effect around widget'),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Animated Container',
          children: [
            _AnimatedContainerDemo(),
          ],
        ),
      ],
    );
  }
}

class _AnimatedContainerDemo extends StatefulWidget {
  @override
  State<_AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<_AnimatedContainerDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: AppDuration.normal,
          curve: AppCurves.standard,
          height: _expanded ? 120 : 60,
          decoration: BoxDecoration(
            gradient: _expanded ? AppGradients.ocean : AppGradients.primary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          alignment: Alignment.center,
          child: Text(
            _expanded ? 'Expanded State 🎉' : 'Tap to expand',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        OutlineButton(
          label: _expanded ? 'Collapse' : 'Expand',
          onPressed: () => setState(() => _expanded = !_expanded),
        ),
      ],
    );
  }
}
