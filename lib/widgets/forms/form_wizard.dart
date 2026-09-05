import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '../buttons/outline_button.dart';
import '../buttons/primary_button.dart';

/// A single step in a [FormWizard].
class WizardStep {
  const WizardStep({
    required this.title,
    this.subtitle,
    this.icon,
    required this.content,
    this.validator,
  });

  /// Step title heading.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional step icon.
  final IconData? icon;

  /// Step form content.
  final Widget content;

  /// Optional validator function; return false or an error String to block advancing.
  final bool Function()? validator;
}

/// A multi-step form wizard workflow with step progression, animated page transitions, and controls.
class FormWizard extends StatefulWidget {
  const FormWizard({
    super.key,
    required this.steps,
    required this.onCompleted,
    this.onCancel,
    this.initialStep = 0,
    this.nextLabel = 'Next',
    this.prevLabel = 'Back',
    this.finishLabel = 'Submit',
    this.cancelLabel = 'Cancel',
  });

  /// The wizard steps list.
  final List<WizardStep> steps;

  /// Callback when all steps are successfully completed.
  final VoidCallback onCompleted;

  /// Callback when the cancel button is clicked.
  final VoidCallback? onCancel;

  /// Initial active step index.
  final int initialStep;

  /// Next button label.
  final String nextLabel;

  /// Previous button label.
  final String prevLabel;

  /// Final submit button label.
  final String finishLabel;

  /// Cancel button label.
  final String cancelLabel;

  @override
  State<FormWizard> createState() => _FormWizardState();
}

class _FormWizardState extends State<FormWizard> {
  late int _currentStep;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _pageController = PageController(initialPage: widget.initialStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final WizardStep step = widget.steps[_currentStep];
    if (step.validator != null && !step.validator!()) {
      return;
    }

    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onCompleted();
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isLast = _currentStep == widget.steps.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Stepper Header
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161626) : const Color(0xFFF8F8FC),
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children:
                List<Widget>.generate(widget.steps.length * 2 - 1, (int i) {
              if (i.isOdd) {
                // Divider line
                final int stepIdx = i ~/ 2;
                final bool isDone = stepIdx < _currentStep;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: isDone
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : Colors.black12),
                  ),
                );
              }

              final int stepIdx = i ~/ 2;
              final bool isActive = stepIdx == _currentStep;
              final bool isDone = stepIdx < _currentStep;
              final WizardStep step = widget.steps[stepIdx];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.primary
                          : (isActive
                              ? scheme.primary.withValues(alpha: 0.15)
                              : Colors.transparent),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone || isActive
                            ? AppColors.primary
                            : (isDark ? Colors.white24 : Colors.black26),
                        width: isActive ? 2 : 1.2,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              size: 16, color: Colors.white)
                          : Text(
                              '${stepIdx + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? AppColors.primary
                                    : (isDark
                                        ? Colors.white54
                                        : Colors.black45),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Step Body
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.steps.length,
            itemBuilder: (BuildContext context, int index) =>
                SingleChildScrollView(
              child: widget.steps[index].content,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Footer Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            OutlineButton(
              label: _currentStep > 0 ? widget.prevLabel : widget.cancelLabel,
              onPressed: _previous,
              width: 110,
            ),
            PrimaryButton(
              label: isLast ? widget.finishLabel : widget.nextLabel,
              onPressed: _next,
              width: 110,
            ),
          ],
        ),
      ],
    );
  }
}
