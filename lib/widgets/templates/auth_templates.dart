import 'package:flutter/material.dart' as fl show FormState;
import '../../nash_ui.dart';

/// A complete login screen template.
class LoginTemplate extends StatefulWidget {
  const LoginTemplate({
    super.key,
    required this.onSubmit,
    this.onForgotPassword,
    this.onSignUp,
    this.logo,
    this.title = 'Welcome back',
    this.subtitle = 'Sign in to continue to your account',
    this.submitLabel = 'Sign in',
    this.busy = false,
    this.emailController,
    this.passwordController,
  });

  /// Called with (email, password) when the form is submitted.
  final Future<void> Function(String email, String password) onSubmit;

  /// Navigates to the forgot-password flow.
  final VoidCallback? onForgotPassword;

  /// Navigates to the sign-up flow.
  final VoidCallback? onSignUp;

  /// Optional logo widget shown above the title.
  final Widget? logo;

  /// Heading text.
  final String title;

  /// Subtitle text.
  final String subtitle;

  /// Submit button label.
  final String submitLabel;

  /// Shows a loading spinner on the submit button.
  final bool busy;

  /// Optional email controller.
  final TextEditingController? emailController;

  /// Optional password controller.
  final TextEditingController? passwordController;

  @override
  State<LoginTemplate> createState() => _NLoginTemplateState();
}

class _NLoginTemplateState extends State<LoginTemplate> {
  final GlobalKey<fl.FormState> _formKey = GlobalKey<fl.FormState>();
  late final TextEditingController _emailController =
      widget.emailController ?? TextEditingController();
  late final TextEditingController _passwordController =
      widget.passwordController ?? TextEditingController();

  @override
  void dispose() {
    if (widget.emailController == null) _emailController.dispose();
    if (widget.passwordController == null) _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (widget.logo != null) Center(child: widget.logo),
                  if (widget.logo != null)
                    const SizedBox(height: AppSpacing.md),
                  SlideAnimation(
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: AppFontWeight.bold,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeAnimation(
                      child: EmailField(controller: _emailController)),
                  const SizedBox(height: AppSpacing.md),
                  FadeAnimation(
                      child: PasswordField(controller: _passwordController)),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      label: 'Forgot password?',
                      onPressed: widget.onForgotPassword,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: widget.submitLabel,
                    expanded: true,
                    loading: widget.busy,
                    icon: Icons.login_rounded,
                    onPressed: widget.busy ? null : _submit,
                  ),
                  if (widget.onSignUp != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          label: 'Sign up',
                          onPressed: widget.onSignUp,
                        ),
                      ],
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    await widget.onSubmit(email, password);
  }
}

/// A complete sign-up / registration screen template.
class SignupTemplate extends StatefulWidget {
  const SignupTemplate({
    super.key,
    required this.onSubmit,
    this.onSignIn,
    this.logo,
    this.title = 'Create account',
    this.subtitle = 'Join us and start your journey',
    this.submitLabel = 'Create account',
    this.busy = false,
    this.nameController,
    this.emailController,
    this.passwordController,
  });

  /// Called with (name, email, password) on submit.
  final Future<void> Function(String name, String email, String password)
      onSubmit;

  /// Navigates to the sign-in flow.
  final VoidCallback? onSignIn;

  /// Optional logo widget.
  final Widget? logo;

  /// Heading text.
  final String title;

  /// Subtitle text.
  final String subtitle;

  /// Submit button label.
  final String submitLabel;

  /// Shows a loading spinner.
  final bool busy;

  /// Optional name controller.
  final TextEditingController? nameController;

  /// Optional email controller.
  final TextEditingController? emailController;

  /// Optional password controller.
  final TextEditingController? passwordController;

  @override
  State<SignupTemplate> createState() => _NSignupTemplateState();
}

class _NSignupTemplateState extends State<SignupTemplate> {
  final GlobalKey<fl.FormState> _formKey = GlobalKey<fl.FormState>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (widget.logo != null) Center(child: widget.logo),
                  if (widget.logo != null)
                    const SizedBox(height: AppSpacing.md),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: AppFontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: widget.nameController,
                    label: 'Full name',
                    icon: Icons.person_outline_rounded,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  EmailField(controller: widget.emailController),
                  const SizedBox(height: AppSpacing.md),
                  PasswordField(controller: widget.passwordController),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: widget.submitLabel,
                    expanded: true,
                    loading: widget.busy,
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: widget.busy ? null : _submit,
                  ),
                  if (widget.onSignIn != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already have an account?',
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          label: 'Sign in',
                          onPressed: widget.onSignIn,
                        ),
                      ],
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(
      widget.nameController?.text.trim() ?? '',
      widget.emailController?.text.trim() ?? '',
      widget.passwordController?.text ?? '',
    );
  }
}

/// A forgot-password screen template.
class ForgotPasswordTemplate extends StatefulWidget {
  const ForgotPasswordTemplate({
    super.key,
    required this.onSubmit,
    this.onBack,
    this.logo,
    this.title = 'Forgot password?',
    this.subtitle = 'Enter your email and we will send you a reset link',
    this.submitLabel = 'Send reset link',
    this.busy = false,
    this.emailController,
  });

  /// Called with the email on submit.
  final Future<void> Function(String email) onSubmit;

  /// Navigates back to sign-in.
  final VoidCallback? onBack;

  /// Optional logo widget.
  final Widget? logo;

  /// Heading text.
  final String title;

  /// Subtitle text.
  final String subtitle;

  /// Submit button label.
  final String submitLabel;

  /// Shows a loading spinner.
  final bool busy;

  /// Optional email controller.
  final TextEditingController? emailController;

  @override
  State<ForgotPasswordTemplate> createState() =>
      _NForgotPasswordTemplateState();
}

class _NForgotPasswordTemplateState extends State<ForgotPasswordTemplate> {
  final GlobalKey<fl.FormState> _formKey = GlobalKey<fl.FormState>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (widget.logo != null) Center(child: widget.logo),
                  if (widget.logo != null)
                    const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppGradients.brand,
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: AppFontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  EmailField(controller: widget.emailController),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: widget.submitLabel,
                    expanded: true,
                    loading: widget.busy,
                    icon: Icons.send_rounded,
                    onPressed: widget.busy ? null : _submit,
                  ),
                  if (widget.onBack != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      label: 'Back to sign in',
                      icon: Icons.arrow_back_rounded,
                      onPressed: widget.onBack,
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(widget.emailController?.text.trim() ?? '');
  }
}
