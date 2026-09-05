import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Cards',
      icon: Icons.credit_card_rounded,
      sections: [
        ShowcaseSection(
          title: 'Banner Carousel Slider',
          children: [
            Carousel(
              height: 180,
              itemCount: 3,
              showArrows: true,
              itemBuilder: (context, index) {
                final gradients = [
                  AppGradients.primary,
                  AppGradients.cyberpunk,
                  AppGradients.ocean,
                ];
                final titles = [
                  'Nash UI Design System v1.0.4',
                  'Vibrant Glassmorphism & Animations',
                  'Build Production Apps 10x Faster',
                ];
                return Container(
                  decoration: BoxDecoration(
                    gradient: gradients[index],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Tag(label: 'Featured', color: Colors.white24),
                      const SizedBox(height: 12),
                      Text(
                        titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Swipe or wait for auto-advance with indicator dots.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Nash Card',
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Standard Card',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 6),
                    Text('A clean, elevated card surface.',
                        style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Glass Card',
          children: [
            // Gradient background is required for glassmorphism to be visible
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.large),
                gradient: context.isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.blur_on_rounded,
                          size: 32,
                          color:
                              context.isDark ? Colors.white70 : Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        'Glassmorphism Card',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.isDark ? Colors.white : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Frosted glass with backdrop blur',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Glow Card',
          children: [
            GlowCard(
              glowColor: AppColors.violet,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        size: 32, color: AppColors.violet),
                    const SizedBox(height: 10),
                    Text(
                      'Glow Card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ambient neon aura effect',
                      style: TextStyle(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Statistic Card',
          children: [
            StatisticCard(
              title: 'Revenue',
              value: '\$42,500',
              trend: '+12.5%',
              icon: Icons.attach_money_rounded,
              iconColor: AppColors.emerald,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Product Card',
          children: [
            ProductCard(
              title: 'Wireless Headphones',
              price: '\$99.99',
              onTap: () {},
            ),
          ],
        ),
        ShowcaseSection(
          title: 'User Card',
          children: const [
            UserCard(
              name: 'Nashwan Nheli',
              subtitle: 'Flutter Architect',
            ),
          ],
        ),
      ],
    );
  }
}
