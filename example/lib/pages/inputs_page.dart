import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  String? _dropdownValue = 'Flutter';
  bool _checkValue = true;
  String _radioValue = 'Option 1';
  double _sliderValue = 45.0;
  RangeValues _rangeValues = const RangeValues(20, 80);
  Color _pickerColor = AppColors.primary;
  List<UploadedFile> _uploadedFiles = [
    const UploadedFile(name: 'design_system_v1.pdf', sizeInBytes: 2450000),
    const UploadedFile(
        name: 'avatar_mockup.png', sizeInBytes: 850000, progress: 0.65),
  ];

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Inputs & Controls',
      icon: Icons.tune_rounded,
      sections: [
        ShowcaseSection(
          title: 'Sliders (Single & Dual Range)',
          children: [
            Text('Single Value: ${_sliderValue.toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              showMinMaxLabels: true,
              suffix: '%',
              onChanged: (v) => setState(() => _sliderValue = v),
            ),
            const SizedBox(height: 16),
            Text(
                'Range: \$${_rangeValues.start.toStringAsFixed(0)} - \$${_rangeValues.end.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            RangeSlider(
              values: _rangeValues,
              min: 0,
              max: 100,
              showMinMaxLabels: true,
              prefix: '\$',
              onChanged: (v) => setState(() => _rangeValues = v),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Color Picker & Palette',
          children: [
            ColorPicker(
              selectedColor: _pickerColor,
              onColorChanged: (c) => setState(() => _pickerColor = c),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'File Upload & Dropzone',
          children: [
            FileUpload(
              files: _uploadedFiles,
              onTap: () {
                setState(() {
                  _uploadedFiles = [
                    ..._uploadedFiles,
                    UploadedFile(
                      name: 'new_attachment_${_uploadedFiles.length + 1}.png',
                      sizeInBytes: 1200000,
                    ),
                  ];
                });
              },
              onFileRemoved: (f) {
                setState(() {
                  _uploadedFiles =
                      _uploadedFiles.where((item) => item != f).toList();
                });
              },
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Multi-Step Form Wizard',
          children: [
            FormWizard(
              steps: [
                WizardStep(
                  title: 'Account',
                  content: Column(
                    children: const [
                      TextField(label: 'Username', hint: 'Choose a handle'),
                      SizedBox(height: 10),
                      EmailField(hint: 'you@domain.com'),
                    ],
                  ),
                ),
                WizardStep(
                  title: 'Profile',
                  content: Column(
                    children: const [
                      TextField(
                          label: 'Full Name', hint: 'First and Last name'),
                      SizedBox(height: 10),
                      PhoneField(hint: '+964 700 000 0000'),
                    ],
                  ),
                ),
                WizardStep(
                  title: 'Confirm',
                  content: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 48, color: AppColors.success),
                        SizedBox(height: 8),
                        Text('Ready to submit registration!',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
              onCompleted: () => context.showSuccessSnack('Wizard completed!'),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Text Field',
          children: const [
            TextField(
              label: 'Full Name',
              hint: 'Enter your name',
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: 12),
            TextField(
              label: 'Bio',
              hint: 'Write something about yourself…',
              maxLines: 3,
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Email & Password',
          children: const [
            EmailField(hint: 'you@example.com'),
            SizedBox(height: 12),
            PasswordField(hint: 'Min 8 characters'),
          ],
        ),
        ShowcaseSection(
          title: 'Number & OTP',
          children: [
            const NumberField(label: 'Amount', hint: '0.00'),
            const SizedBox(height: 12),
            OtpField(length: 6, onCompleted: (_) {}),
          ],
        ),
        ShowcaseSection(
          title: 'Date Pickers — Horizontal Timeline Strip',
          children: [
            HorizontalDatePicker(
              initialDate: DateTime.now(),
              markedDates: {
                DateTime.now().add(const Duration(days: 2)),
                DateTime.now().add(const Duration(days: 5)),
              },
              onDateSelected: (d) =>
                  context.showSnack('Selected: ${d.year}-${d.month}-${d.day}'),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Date Pickers — Styles & Modals',
          children: [
            DateField(
              label: 'Nash BottomSheet Picker (Default)',
              pickerStyle: DateFieldPickerStyle.nash,
              onChanged: (d) {},
            ),
            const SizedBox(height: 12),
            DateField(
              label: 'iOS Wheel Spinner Picker',
              pickerStyle: DateFieldPickerStyle.wheel,
              onChanged: (d) {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pick Date Range',
                    icon: Icons.date_range_rounded,
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      );
                      if (range != null && context.mounted) {
                        context.showSuccessSnack(
                            'Range: ${range.start.month}/${range.start.day} - ${range.end.month}/${range.end.day}');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Date Pickers — Wheel / Spinner',
          children: [
            WheelDatePicker(
              height: 160,
              initialDate: DateTime.now(),
              onDateChanged: (d) {},
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Dropdowns',
          children: [
            Dropdown<String>(
              label: 'Framework',
              value: _dropdownValue,
              items: const [
                DropdownItem(value: 'Flutter', label: 'Flutter'),
                DropdownItem(value: 'React Native', label: 'React Native'),
                DropdownItem(value: 'SwiftUI', label: 'SwiftUI'),
                DropdownItem(value: 'Jetpack', label: 'Jetpack'),
              ],
              onChanged: (v) => setState(() => _dropdownValue = v),
            ),
          ],
        ),
        ShowcaseSection(
          title: 'Selection Controls & Chips',
          children: [
            Checkbox(
              value: _checkValue,
              label: 'Agree to terms and conditions',
              onChanged: (v) => setState(() => _checkValue = v),
            ),
            const SizedBox(height: 10),
            Radio(
              value: 'Option 1',
              groupValue: _radioValue,
              label: 'Default standard tier',
              onChanged: (v) {
                if (v != null) setState(() => _radioValue = v.toString());
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: 'Flutter',
                  selected: true,
                  onPressed: () {},
                ),
                Chip(
                  label: 'Dart',
                  selected: false,
                  onPressed: () {},
                ),
                Chip(
                  label: 'Mobile',
                  selected: false,
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
