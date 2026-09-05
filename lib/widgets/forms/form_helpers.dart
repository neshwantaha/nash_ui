import 'package:flutter/material.dart' hide Card;

import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/font_weight.dart';
import '../cards/card.dart';

/// A titled group of form fields inside a styled card.
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  /// Section heading.
  final String? title;

  /// Section description.
  final String? subtitle;

  /// Fields inside the section.
  final List<Widget> children;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Whether the section can be collapsed.
  final bool collapsible;

  /// Initial expanded state.
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Widget heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Text(
            title!,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: AppFontWeight.semibold,
              color: scheme.onSurface,
            ),
          ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        if (title != null || subtitle != null)
          const SizedBox(height: AppSpacing.sm),
      ],
    );

    if (!collapsible) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          heading,
          Card(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      );
    }

    return _CollapsibleFormSection(
      heading: heading,
      padding: padding,
      initiallyExpanded: initiallyExpanded,
      children: children,
    );
  }
}

class _CollapsibleFormSection extends StatefulWidget {
  const _CollapsibleFormSection({
    required this.heading,
    required this.padding,
    required this.initiallyExpanded,
    required this.children,
  });

  final Widget heading;
  final EdgeInsetsGeometry padding;
  final bool initiallyExpanded;
  final List<Widget> children;

  @override
  State<_CollapsibleFormSection> createState() =>
      _CollapsibleFormSectionState();
}

class _CollapsibleFormSectionState extends State<_CollapsibleFormSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: <Widget>[
                  Expanded(child: widget.heading),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Card(
              padding: widget.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
        ],
      );
}

/// A labelled field with label on top and hint/error below.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.required = false,
    this.child,
  });

  /// Field label.
  final String label;

  /// Field hint.
  final String? hint;

  /// Error message.
  final String? errorText;

  /// Marks the field as required.
  final bool required;

  /// The actual input widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            text: label,
            children: <TextSpan>[
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: scheme.error),
                ),
            ],
          ),
          style: textTheme.labelLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: AppFontWeight.medium,
          ),
        ),
        const SizedBox(height: 6),
        if (child != null) child!,
        if (hint != null && errorText == null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            hint!,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
