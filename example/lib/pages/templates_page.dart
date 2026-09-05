import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Templates',
      icon: Icons.dashboard_rounded,
      sections: [
        ShowcaseSection(
          title: 'Login Template',
          children: [
            SizedBox(
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: LoginTemplate(
                  onSubmit: (email, password) async {
                    await Future.delayed(const Duration(seconds: 1));
                  },
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Settings Template',
          children: [
            SizedBox(
              height: 320,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: SettingsTemplate(
                  title: 'App Settings',
                  groups: [
                    SettingsGroup(
                      title: 'Preferences',
                      tiles: [
                        SettingsTile(
                          title: 'Dark Theme',
                          subtitle: 'Toggle dark mode appearance',
                          icon: Icons.dark_mode_rounded,
                          trailing: Switch(value: true, onChanged: (_) {}),
                        ),
                        SettingsTile(
                          title: 'App Language',
                          subtitle: 'English',
                          icon: Icons.language_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'Account',
                      tiles: [
                        SettingsTile(
                          title: 'Notifications',
                          icon: Icons.notifications_rounded,
                          onTap: () {},
                        ),
                        SettingsTile(
                          title: 'Sign Out',
                          icon: Icons.logout_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Onboarding Screen',
          children: [
            SizedBox(
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: OnboardingScreen(
                  pages: const [
                    OnboardingPage(
                      title: 'Design Faster',
                      subtitle:
                          'Build beautiful UIs using Nash UI design tokens and pre-built widgets.',
                      icon: Icons.palette_rounded,
                    ),
                    OnboardingPage(
                      title: 'Fully Customizable',
                      subtitle:
                          'Every component respects your brand colors, radius, and typography.',
                      icon: Icons.tune_rounded,
                    ),
                    OnboardingPage(
                      title: 'Production Ready',
                      subtitle:
                          'Tested, documented, and published on pub.dev for immediate use.',
                      icon: Icons.rocket_launch_rounded,
                    ),
                  ],
                  onComplete: () {},
                  onSkip: () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
