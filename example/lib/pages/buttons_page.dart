import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Buttons',
      icon: Icons.smart_button_rounded,
      sections: [
        // ── Modern Futuristic & Glass Buttons ───────────────────────────────
        ShowcaseSection(
          title: 'Glassmorphic & Gradient Border Buttons',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GlassButton(
                  label: 'Glassmorphic Pro',
                  icon: Icons.auto_awesome,
                  onPressed: () => context.showSnack('Glass button tapped!'),
                ),
                GradientBorderButton(
                  label: 'Gradient Border',
                  icon: Icons.bolt_rounded,
                  gradient: AppGradients.primary,
                  onPressed: () => context.showSnack('Gradient border tapped!'),
                ),
                GradientBorderButton(
                  label: 'Cyberpunk Glow',
                  icon: Icons.flash_on_rounded,
                  gradient: AppGradients.cyberpunk,
                  onPressed: () => context.showSnack('Cyberpunk glow tapped!'),
                ),
              ],
            ),
          ],
        ),

        // ── Slide to Confirm / Act Button ──────────────────────────────────
        ShowcaseSection(
          title: 'Slide to Confirm (Interactive Drag)',
          children: [
            SlideButton(
              label: 'Slide to confirm order',
              completedLabel: 'Payment Confirmed!',
              onCompleted: () async {
                await Future.delayed(const Duration(milliseconds: 1200));
                if (context.mounted) {
                  context.showSuccessSnack('Order placed successfully!');
                }
              },
            ),
            const SizedBox(height: 12),
            SlideButton(
              label: 'Slide to unlock secret',
              completedLabel: 'Unlocked!',
              icon: Icons.lock_open_rounded,
              completedIcon: Icons.lock_rounded,
              sliderGradient: AppGradients.ocean,
              onCompleted: () async {
                await Future.delayed(const Duration(milliseconds: 800));
                if (context.mounted) {
                  context.showSnack('Feature unlocked!');
                }
              },
            ),
          ],
        ),

        // ── Split Action Button ────────────────────────────────────────────
        ShowcaseSection(
          title: 'Split Action Button',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SplitButton(
                  label: 'Publish',
                  icon: Icons.send_rounded,
                  onPressed: () =>
                      context.showSuccessSnack('Publishing post...'),
                  actions: [
                    SplitAction(
                      label: 'Save as Draft',
                      icon: Icons.save_alt_rounded,
                      onTap: () => context.showSnack('Saved draft!'),
                    ),
                    SplitAction(
                      label: 'Schedule Publish',
                      icon: Icons.schedule_rounded,
                      onTap: () => context.showSnack('Scheduled!'),
                    ),
                    SplitAction(
                      label: 'Discard',
                      icon: Icons.delete_outline_rounded,
                      isDestructive: true,
                      onTap: () => context.showErrorSnack('Discarded!'),
                    ),
                  ],
                ),
                SplitButton(
                  label: 'Export PDF',
                  icon: Icons.picture_as_pdf_rounded,
                  color: AppColors.violet,
                  onPressed: () => context.showSnack('Exporting PDF...'),
                  actions: [
                    SplitAction(
                      label: 'Export CSV',
                      icon: Icons.table_chart_rounded,
                      onTap: () => context.showSnack('Exporting CSV!'),
                    ),
                    SplitAction(
                      label: 'Export PNG',
                      icon: Icons.image_rounded,
                      onTap: () => context.showSnack('Exporting PNG!'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Connected Button Group ─────────────────────────────────────────
        ShowcaseSection(
          title: 'Connected Button Group',
          children: [
            ButtonGroup<String>(
              selectedValue: _selectedPeriod,
              items: const [
                GroupItem(value: 'Day', label: 'Day'),
                GroupItem(value: 'Week', label: 'Week'),
                GroupItem(value: 'Month', label: 'Month'),
                GroupItem(value: 'Year', label: 'Year'),
              ],
              onChanged: (val) => setState(() => _selectedPeriod = val),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Selected view: $_selectedPeriod',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        // ── Press and Hold to Confirm ──────────────────────────────────────
        ShowcaseSection(
          title: 'Press & Hold to Confirm (Safety Action)',
          children: [
            HoldButton(
              label: 'Hold to Delete Account',
              icon: Icons.delete_forever_rounded,
              color: AppColors.error,
              duration: const Duration(seconds: 2),
              onCompleted: () =>
                  context.showErrorSnack('Account deletion triggered!'),
            ),
            const SizedBox(height: 12),
            HoldButton(
              label: 'Hold to Reset Settings',
              icon: Icons.refresh_rounded,
              color: AppColors.amber,
              duration: const Duration(milliseconds: 1500),
              onCompleted: () =>
                  context.showWarningSnack('Settings have been reset!'),
            ),
          ],
        ),

        // ── Social Authentication Buttons ──────────────────────────────────
        ShowcaseSection(
          title: 'Social Auth Buttons',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SocialButton(
                  provider: SocialProvider.google,
                  onPressed: () => context.showSnack('Google sign-in'),
                ),
                SocialButton(
                  provider: SocialProvider.apple,
                  onPressed: () => context.showSnack('Apple sign-in'),
                ),
                SocialButton(
                  provider: SocialProvider.github,
                  onPressed: () => context.showSnack('GitHub sign-in'),
                ),
                SocialButton(
                  provider: SocialProvider.discord,
                  onPressed: () => context.showSnack('Discord sign-in'),
                ),
              ],
            ),
          ],
        ),

        // ── Core Standard Buttons ──────────────────────────────────────────
        ShowcaseSection(
          title: 'Primary Button',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PrimaryButton(label: 'Get Started', onPressed: () {}),
                PrimaryButton(
                  label: 'Launch',
                  icon: Icons.rocket_launch_rounded,
                  onPressed: () {},
                ),
                const PrimaryButton(label: 'Disabled', onPressed: null),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Secondary & Outline Buttons',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SecondaryButton(label: 'Learn More', onPressed: () {}),
                SecondaryButton(
                  label: 'Settings',
                  icon: Icons.settings_rounded,
                  onPressed: () {},
                ),
                OutlineButton(label: 'Cancel', onPressed: () {}),
                OutlineButton(
                  label: 'Delete',
                  icon: Icons.delete_outline_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Text & Loading Buttons',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(label: 'Skip', onPressed: () {}),
                TextButton(
                  label: 'View All',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {},
                ),
                LoadingButton(
                  label: 'Saving…',
                  loading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Icon & Floating Action Buttons',
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  icon: Icons.favorite_rounded,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icons.share_rounded,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icons.bookmark_rounded,
                  onPressed: () {},
                ),
                FloatingButton(
                  icon: Icons.add_rounded,
                  onPressed: () {},
                ),
                FloatingButton(
                  icon: Icons.edit_rounded,
                  extendedLabel: 'Compose',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
