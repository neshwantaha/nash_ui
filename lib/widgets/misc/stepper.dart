import 'package:flutter/material.dart' hide Stepper;

import '../../spacing/app_spacing.dart';

/// A step indicator supporting horizontal and vertical layouts with
/// clickable steps, validation states, and content below each step.
///
/// ```dart
/// Stepper(
///   currentStep: 1,
///   steps: ['Details', 'Review', 'Submit'],
///   onStepTap: (index) => goToStep(index),
///   stepStates: [StepState.complete, StepState.active, StepState.error],
/// )
/// A backwards-compatible alias for [Stepper].
typedef NashStepper = Stepper;

class Stepper extends StatelessWidget {
  const Stepper({
    super.key,
    required this.currentStep,
    this.steps = const <String>[],
    this.onStepTap,
    this.direction = Axis.vertical,
    this.color,
    this.compact = false,
    this.size = 32,
    this.stepStates,
    this.stepIcons,
    this.stepSubtitles,
    this.showContent = false,
    this.stepContent,
    this.nextButton,
    this.previousButton,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  });

  /// Index of the current step (0-based).
  final int currentStep;

  /// Step labels.
  final List<String> steps;

  /// Step tap callback. When null, steps are not clickable.
  final ValueChanged<int>? onStepTap;

  /// Layout direction.
  final Axis direction;

  /// Active step color.
  final Color? color;

  /// Whether to hide labels (icons only).
  final bool compact;

  /// Step circle size.
  final double size;

  /// Per-step states. If null, defaults are computed from currentStep.
  final List<StepState>? stepStates;

  /// Per-step icons (overrides default number/check/error icons).
  final List<IconData?>? stepIcons;

  /// Per-step subtitle text (shown below the label in vertical mode).
  final List<String?>? stepSubtitles;

  /// Whether to show content below each step in vertical mode.
  final bool showContent;

  /// Content builder for each step (only used when [showContent] is true).
  final Widget Function(int index)? stepContent;

  /// Custom next button widget.
  final Widget? nextButton;

  /// Custom previous button widget.
  final Widget? previousButton;

  /// Callback when the continue/next action is triggered.
  final VoidCallback? onStepContinue;

  /// Callback when the cancel/back action is triggered.
  final VoidCallback? onStepCancel;

  /// Custom controls builder replacing the default next/previous buttons.
  final Widget Function(BuildContext context, int step,
      VoidCallback? onContinue, VoidCallback? onBack)? controlsBuilder;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color accent = color ?? scheme.primary;

    final List<Widget> stepWidgets = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      final StepState state = _resolveState(i);

      stepWidgets.add(_StepItem(
        index: i,
        size: size,
        state: state,
        accent: accent,
        label: steps[i],
        subtitle: stepSubtitles != null ? stepSubtitles![i] : null,
        icon: stepIcons != null ? stepIcons![i] : null,
        compact: compact,
        onTap: onStepTap == null ? null : () => onStepTap!(i),
        showContent: showContent,
        content: stepContent != null ? stepContent!(i) : null,
      ));

      if (i != steps.length - 1) {
        stepWidgets.add(_StepConnector(
          color: state == StepState.complete ? accent : scheme.outlineVariant,
          thickness: 2,
          length: compact ? 24 : 28,
          direction: direction,
        ));
      }
    }

    if (direction == Axis.horizontal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < steps.length; i++)
                Expanded(
                  child: _HorizontalStepItem(
                    index: i,
                    size: size,
                    state: _resolveState(i),
                    accent: accent,
                    label: steps[i],
                    subtitle: stepSubtitles != null && i < stepSubtitles!.length
                        ? stepSubtitles![i]
                        : null,
                    icon: stepIcons != null && i < stepIcons!.length
                        ? stepIcons![i]
                        : null,
                    compact: compact,
                    onTap: onStepTap == null ? null : () => onStepTap!(i),
                    isFirst: i == 0,
                    isLast: i == steps.length - 1,
                  ),
                ),
            ],
          ),
          if (showContent && stepContent != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            stepContent!(currentStep),
          ],
          if (controlsBuilder != null)
            controlsBuilder!(context, currentStep, onStepContinue, onStepCancel)
          else if (onStepContinue != null || onStepCancel != null)
            _buildControls(context, scheme, accent),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < stepWidgets.length; i++)
          if (i.isOdd)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: stepWidgets[i],
            )
          else
            stepWidgets[i],
        if (controlsBuilder != null)
          controlsBuilder!(context, currentStep, onStepContinue, onStepCancel)
        else if (onStepContinue != null || onStepCancel != null)
          _buildControls(context, scheme, accent),
      ],
    );
  }

  StepState _resolveState(int index) {
    if (stepStates != null && index < stepStates!.length) {
      return stepStates![index];
    }
    if (index < currentStep) return StepState.complete;
    if (index == currentStep) return StepState.active;
    return StepState.inactive;
  }

  Widget _buildControls(
          BuildContext context, ColorScheme scheme, Color accent) =>
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (currentStep > 0 && onStepCancel != null)
              previousButton ??
                  OutlinedButton.icon(
                    onPressed: onStepCancel,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back'),
                  )
            else
              const SizedBox.shrink(),
            if (currentStep < steps.length - 1 && onStepContinue != null)
              nextButton ??
                  FilledButton.icon(
                    onPressed: onStepContinue,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Next'),
                  )
            else if (currentStep == steps.length - 1 && onStepContinue != null)
              nextButton ??
                  FilledButton.icon(
                    onPressed: onStepContinue,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Finish'),
                  ),
          ],
        ),
      );
}

/// State of a stepper step.
enum StepState {
  /// Not yet reached.
  inactive,

  /// Currently active.
  active,

  /// Completed successfully.
  complete,

  /// Contains an error.
  error,

  /// Skipped.
  skipped,
}

class _HorizontalStepItem extends StatelessWidget {
  const _HorizontalStepItem({
    required this.index,
    required this.size,
    required this.state,
    required this.accent,
    required this.label,
    this.subtitle,
    this.icon,
    required this.compact,
    this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  final int index;
  final double size;
  final StepState state;
  final Color accent;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool compact;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Circle row with connecting lines
          Row(
            children: <Widget>[
              Expanded(
                child: isFirst
                    ? const SizedBox.shrink()
                    : Container(
                        height: 2,
                        color: state == StepState.complete ||
                                state == StepState.active
                            ? accent
                            : scheme.outlineVariant,
                      ),
              ),
              _StepCircle(
                index: index + 1,
                size: size,
                state: state,
                accent: accent,
                icon: icon,
                onTap: onTap,
              ),
              Expanded(
                child: isLast
                    ? const SizedBox.shrink()
                    : Container(
                        height: 2,
                        color: state == StepState.complete
                            ? accent
                            : scheme.outlineVariant,
                      ),
              ),
            ],
          ),
          if (!compact) ...<Widget>[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: state == StepState.active
                          ? accent
                          : (state == StepState.complete
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant),
                      fontWeight: state == StepState.active
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
              ),
            ),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.size,
    required this.state,
    required this.accent,
    required this.label,
    this.subtitle,
    this.icon,
    required this.compact,
    this.onTap,
    this.showContent = false,
    this.content,
  });

  final int index;
  final double size;
  final StepState state;
  final Color accent;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool compact;
  final VoidCallback? onTap;
  final bool showContent;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Widget circle = _StepCircle(
      index: index + 1,
      size: size,
      state: state,
      accent: accent,
      icon: icon,
    );

    final Widget labelWidget = !compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: state == StepState.active
                          ? accent
                          : scheme.onSurfaceVariant,
                      fontWeight: state == StepState.active
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ],
          )
        : const SizedBox.shrink();

    if (showContent && content != null && state == StepState.active) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                circle,
                const SizedBox(width: AppSpacing.md),
                labelWidget
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 44, top: AppSpacing.sm),
              child: content!,
            ),
          ],
        ),
      );
    }

    return Row(
      children: <Widget>[
        circle,
        const SizedBox(width: AppSpacing.md),
        labelWidget
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.size,
    required this.state,
    required this.accent,
    this.icon,
    this.onTap,
  });

  final int index;
  final double size;
  final StepState state;
  final Color accent;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;
    final Widget content;

    switch (state) {
      case StepState.complete:
        bg = accent;
        fg = Colors.white;
        content = Icon(icon ?? Icons.check, size: size * 0.55, color: fg);
      case StepState.active:
        bg = accent.withValues(alpha: 0.15);
        fg = accent;
        content = Text(
          '$index',
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.4,
          ),
        );
      case StepState.error:
        bg = scheme.error.withValues(alpha: 0.15);
        fg = scheme.error;
        content =
            Icon(icon ?? Icons.error_outline, size: size * 0.55, color: fg);
      case StepState.skipped:
        bg = scheme.surfaceContainerHighest;
        fg = scheme.onSurfaceVariant;
        content = Icon(icon ?? Icons.skip_next, size: size * 0.5, color: fg);
      case StepState.inactive:
        bg = scheme.surfaceContainerHighest;
        fg = scheme.onSurfaceVariant;
        content = Text(
          '$index',
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
            fontSize: size * 0.4,
          ),
        );
    }

    final Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: state == StepState.active
            ? Border.all(color: accent, width: 2)
            : null,
      ),
      child: Center(child: content),
    );

    if (onTap == null) return circle;
    return InkWell(
        onTap: onTap, customBorder: const CircleBorder(), child: circle);
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({
    required this.color,
    required this.thickness,
    required this.length,
    required this.direction,
  });

  final Color color;
  final double thickness;
  final double length;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Center(
        child: Container(
          width: length,
          height: thickness,
          color: color,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: thickness,
        height: length,
        color: color,
      ),
    );
  }
}
