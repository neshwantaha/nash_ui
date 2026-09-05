import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int _verticalStep = 1;
  int _horizontalStep = 0;
  int _statesStep = 0;

  static const _stepLabels = ['Account', 'Details', 'Review', 'Complete'];

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Stepper',
      icon: Icons.linear_scale_rounded,
      sections: [
        // ── Vertical Stepper ────────────────────────────────────────────
        ShowcaseSection(
          title: 'Vertical Stepper',
          children: [
            Stepper(
              currentStep: _verticalStep,
              steps: _stepLabels,
              direction: Axis.vertical,
              onStepTap: (index) => setState(() => _verticalStep = index),
              onStepContinue: () {
                if (_verticalStep < _stepLabels.length - 1) {
                  setState(() => _verticalStep++);
                }
              },
              onStepCancel: () {
                if (_verticalStep > 0) {
                  setState(() => _verticalStep--);
                }
              },
            ),
          ],
        ),

        // ── Horizontal Stepper ──────────────────────────────────────────
        ShowcaseSection(
          title: 'Horizontal Stepper',
          children: [
            Stepper(
              currentStep: _horizontalStep,
              steps: _stepLabels,
              direction: Axis.horizontal,
              onStepTap: (index) => setState(() => _horizontalStep = index),
              onStepContinue: () {
                if (_horizontalStep < _stepLabels.length - 1) {
                  setState(() => _horizontalStep++);
                }
              },
              onStepCancel: () {
                if (_horizontalStep > 0) {
                  setState(() => _horizontalStep--);
                }
              },
            ),
          ],
        ),

        // ── Stepper with Custom States ──────────────────────────────────
        ShowcaseSection(
          title: 'Stepper with Custom States',
          children: [
            Stepper(
              currentStep: _statesStep,
              steps: _stepLabels,
              direction: Axis.vertical,
              stepStates: const [
                StepState.complete,
                StepState.active,
                StepState.error,
                StepState.inactive,
              ],
              stepSubtitles: const [
                'Done',
                'In progress',
                'Something went wrong',
                'Waiting',
              ],
              onStepTap: (index) => setState(() => _statesStep = index),
              onStepContinue: () {
                if (_statesStep < _stepLabels.length - 1) {
                  setState(() => _statesStep++);
                }
              },
              onStepCancel: () {
                if (_statesStep > 0) {
                  setState(() => _statesStep--);
                }
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'States: complete (green), active (outlined), error (red), inactive (grey)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
