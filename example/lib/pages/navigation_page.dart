import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Navigation',
      icon: Icons.navigation_rounded,
      sections: [
        ShowcaseSection(
          title: 'Nash AppBar',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: AppBar(
                title: 'Analytics Dashboard',
                actions: [
                  IconButton(
                      icon: Icons.notifications_outlined, onPressed: () {}),
                  IconButton(icon: Icons.search_rounded, onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Bottom Navigation Bar',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: BottomNavBar(
                currentIndex: _bottomIndex,
                onTap: (i) => setState(() => _bottomIndex = i),
                items: const [
                  BottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                  BottomNavItem(icon: Icons.search_rounded, label: 'Search'),
                  BottomNavItem(icon: Icons.favorite_rounded, label: 'Saved'),
                  BottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Stepper',
          children: [
            const Stepper(
              currentStep: 1,
              steps: [
                'Account Details',
                'Profile Setup',
                'Verification',
                'Completed'
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Timeline',
          children: [
            Timeline(
              items: [
                TimelineItem(
                  title: 'Order Placed',
                  time: '10:00 AM',
                  description: 'Payment verified successfully.',
                  icon: Icons.shopping_cart_rounded,
                  color: AppColors.primary,
                ),
                TimelineItem(
                  title: 'Processing',
                  time: '11:30 AM',
                  description: 'Item packed in warehouse.',
                  icon: Icons.settings_rounded,
                  color: AppColors.amber,
                ),
                TimelineItem(
                  title: 'Shipped',
                  time: '09:00 AM',
                  description: 'Carrier is on the way.',
                  icon: Icons.local_shipping_rounded,
                  color: AppColors.emerald,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
