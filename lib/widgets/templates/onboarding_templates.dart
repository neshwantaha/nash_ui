import '../../nash_ui.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OnboardingPage — One page/slide in the onboarding flow
// ─────────────────────────────────────────────────────────────────────────────

/// Configuration for a single onboarding slide.
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.subtitle,
    this.illustration,
    this.gradient,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String subtitle;

  /// Optional custom illustration widget.
  final Widget? illustration;

  /// Background gradient (defaults to primary → violet).
  final Gradient? gradient;

  /// Icon shown when no illustration is provided.
  final IconData? icon;
  final Color? iconColor;
}

// ─────────────────────────────────────────────────────────────────────────────
// OnboardingScreen — Multi-page onboarding with swipe, skip, get-started
// ─────────────────────────────────────────────────────────────────────────────

/// A ready-to-use animated onboarding screen.
///
/// ```dart
/// OnboardingScreen(
///   pages: [
///     OnboardingPage(
///       title: 'Design Faster',
///       subtitle: 'Build beautiful UIs with Nash UI design tokens.',
///       icon: Icons.palette_rounded,
///     ),
///   ],
///   onComplete: () => Navigator.of(context).pushReplacement(...),
/// )
/// ```
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.pages,
    required this.onComplete,
    this.onSkip,
    this.skipLabel = 'Skip',
    this.nextLabel = 'Next',
    this.completeLabel = 'Get Started',
    this.showSkip = true,
  });

  final List<OnboardingPage> pages;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;
  final String skipLabel;
  final String nextLabel;
  final String completeLabel;
  final bool showSkip;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _current = 0;

  bool get _isLast => _current == widget.pages.length - 1;

  void _next() {
    if (_isLast) {
      widget.onComplete();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skip() {
    (widget.onSkip ?? widget.onComplete)();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.pages.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (ctx, i) => _OnboardingSlide(page: widget.pages[i]),
            ),
            // Skip button
            if (widget.showSkip && !_isLast)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 12,
                right: 16,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    widget.skipLabel,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            // Bottom controls
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 24,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _current == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _current == i
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                    ),
                    child: Text(
                      _isLast ? widget.completeLabel : widget.nextLabel,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.page});
  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final gradient = page.gradient ?? AppGradients.primary;

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Illustration
            Expanded(
              flex: 4,
              child: page.illustration ??
                  Icon(
                    page.icon ?? Icons.auto_awesome_rounded,
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
            const Spacer(),
            // Text content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SplashScreen — Animated logo splash
// ─────────────────────────────────────────────────────────────────────────────

/// Shows an animated splash screen then calls [onComplete].
///
/// ```dart
/// SplashScreen(
///   logo: FlutterLogo(size: 80),
///   appName: 'MyApp',
///   onComplete: () => Navigator.pushReplacement(context, ...),
/// )
/// ```
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onComplete,
    this.logo,
    this.appName,
    this.tagline,
    this.gradient,
    this.duration = const Duration(seconds: 2),
    this.animationDuration = const Duration(milliseconds: 800),
  });

  final VoidCallback onComplete;
  final Widget? logo;
  final String? appName;
  final String? tagline;
  final Gradient? gradient;
  final Duration duration;
  final Duration animationDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));

    _ctrl.forward();
    Future<void>.delayed(widget.duration, () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration:
              BoxDecoration(gradient: widget.gradient ?? AppGradients.primary),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.logo ??
                        const Icon(Icons.auto_awesome_rounded,
                            size: 80, color: Colors.white),
                    if (widget.appName != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        widget.appName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                    if (widget.tagline != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.tagline!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileSetupScreen — Step-by-step profile creation wizard
// ─────────────────────────────────────────────────────────────────────────────

/// A multi-step profile setup screen using [FormWizard] pattern.
///
/// ```dart
/// ProfileSetupScreen(
///   onComplete: (data) => saveProfile(data),
/// )
/// ```
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({
    super.key,
    required this.onComplete,
    this.title = 'Set Up Your Profile',
    this.subtitle = 'Tell us a bit about yourself to get started.',
  });

  final void Function(Map<String, String> data) onComplete;
  final String title;
  final String subtitle;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  int _step = 0;

  static const _totalSteps = 3;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      widget.onComplete({
        'name': _nameCtrl.text,
        'username': _usernameCtrl.text,
        'bio': _bioCtrl.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_step + 1) / _totalSteps,
                  backgroundColor: scheme.primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Step ${_step + 1} of $_totalSteps',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _stepContent(_step),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                ),
                child: Text(
                  _step < _totalSteps - 1 ? 'Continue' : 'Finish',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepContent(int step) => KeyedSubtree(
        key: ValueKey(step),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 0) ...[
              const Text('What\'s your name?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 6),
              const Text('This is how other users will see you.'),
              const SizedBox(height: 20),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
            ] else if (step == 1) ...[
              const Text('Choose a username',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 6),
              const Text('Your unique identifier in the app.'),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixText: '@',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
            ] else ...[
              const Text('Write a short bio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 6),
              const Text('Optional — tell us what you\'re about.'),
              const SizedBox(height: 20),
              TextField(
                controller: _bioCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Flutter developer, open-source enthusiast…',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ],
        ),
      );
}
