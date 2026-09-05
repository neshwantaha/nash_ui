@Tags(['golden'])
library;

import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nash_ui/nash_ui.dart';

/// Allows a small pixel variance (e.g. 0.5%) to account for minor OS/driver font antialiasing differences.
class TolerantLocalFileComparator extends LocalFileComparator {
  TolerantLocalFileComparator(super.testFile, {this.tolerance = 0.005});

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent <= tolerance) {
      return true;
    }

    if (!result.passed) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }
}

Future<void> _pumpApp(WidgetTester tester, Widget body) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.light(useGoogleFonts: false),
      home: Scaffold(body: body),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    if (goldenFileComparator is LocalFileComparator) {
      final baseDir = (goldenFileComparator as LocalFileComparator).basedir;
      goldenFileComparator = TolerantLocalFileComparator(
        baseDir.resolve('golden_test.dart'),
        tolerance: 0.005, // 0.5% tolerance for OS antialiasing variations
      );
    }
  });

  testWidgets('buttons render consistently', (WidgetTester tester) async {
    _setSurface(tester, const Size(800, 600));
    await _pumpApp(
      tester,
      const Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: <Widget>[
            PrimaryButton(label: 'Primary', onPressed: _noopTap),
            SecondaryButton(label: 'Secondary', onPressed: _noopTap),
            OutlineButton(label: 'Outline', onPressed: _noopTap),
            TextButton(label: 'Text', onPressed: _noopTap),
            LoadingButton(label: 'Loading', onPressed: _noopTap, loading: true),
            IconButton(icon: Icons.favorite),
            PrimaryButton(
                label: 'With icon', icon: Icons.send, onPressed: _noopTap),
          ],
        ),
      ),
    );
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/buttons.png'));
  });

  testWidgets('forms render consistently', (WidgetTester tester) async {
    _setSurface(tester, const Size(800, 900));
    await _pumpApp(
      tester,
      const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            TextField(label: 'Email', hint: 'you@example.com'),
            SizedBox(height: 16),
            PasswordField(),
            SizedBox(height: 16),
            EmailField(label: 'Email field'),
            SizedBox(height: 16),
            NumberField(label: 'Quantity'),
            SizedBox(height: 16),
            OtpField(length: 4),
            SizedBox(height: 16),
            SearchField(hint: 'Search products'),
            SizedBox(height: 24),
            Checkbox(label: 'Remember me', value: true, onChanged: _noopBool),
            SizedBox(height: 8),
            Switch(label: 'Notifications', value: true, onChanged: _noopBool),
            SizedBox(height: 24),
            LabeledField(
                label: 'Nested field', child: TextField(label: 'Full name')),
          ],
        ),
      ),
    );
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/forms.png'));
  });

  testWidgets('cards render consistently', (WidgetTester tester) async {
    _setSurface(tester, const Size(900, 700));
    await _pumpApp(
      tester,
      const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Card(child: Text('A standard card with elevation and radius.')),
            SizedBox(height: 16),
            GradientCard(child: Text('Gradient card')),
            SizedBox(height: 16),
            StatisticCard(title: 'Active users', value: '24,812'),
            SizedBox(height: 16),
            SizedBox(
              width: 260,
              child: ProductCard(
                title: 'Wireless Headphones',
                price: r'$129',
                rating: 4.5,
                oldPrice: r'$159',
                discount: '-19%',
              ),
            ),
          ],
        ),
      ),
    );
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/cards.png'));
  });

  testWidgets('navigation components render consistently',
      (WidgetTester tester) async {
    _setSurface(tester, const Size(900, 700));
    await _pumpApp(
      tester,
      const Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: _noop,
            destinations: <NavRailDestination>[
              NavRailDestination(label: 'Home', icon: Icons.home_outlined),
              NavRailDestination(
                  label: 'Inbox', icon: Icons.mail_outline, badge: '3'),
              NavRailDestination(label: 'Profile', icon: Icons.person_outline),
            ],
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: <Widget>[
                AppBar(
                    title: 'Dashboard', actions: <Widget>[Icon(Icons.search)]),
                Spacer(),
                BottomNavBar(
                  currentIndex: 1,
                  onTap: _noop,
                  items: <BottomNavItem>[
                    BottomNavItem(icon: Icons.home, label: 'Home'),
                    BottomNavItem(
                        icon: Icons.favorite, label: 'Saved', badge: '8'),
                    BottomNavItem(icon: Icons.settings, label: 'Settings'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/navigation.png'));
  });

  testWidgets('tokens showcase renders consistently',
      (WidgetTester tester) async {
    _setSurface(tester, const Size(900, 900));
    await _pumpApp(
      tester,
      const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SectionHeader(text: 'Brand palette'),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: <Widget>[
              AppColorswatch(color: AppColors.primary),
              AppColorswatch(color: AppColors.secondary),
              AppColorswatch(color: AppColors.error),
              AppColorswatch(color: AppColors.surface),
              AppColorswatch(color: AppColors.surfaceDark),
              AppColorswatch(color: AppColors.amoled),
            ]),
            SizedBox(height: 24),
            _SectionHeader(text: 'Gradients'),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: <Widget>[
              AppGradientswatch(gradient: AppGradients.brand),
              AppGradientswatch(gradient: AppGradients.success),
              AppGradientswatch(gradient: AppGradients.warning),
            ]),
            SizedBox(height: 24),
            _SectionHeader(text: 'Spacing'),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: <Widget>[
              AppSpacingSwatch(size: AppSpacing.xs),
              AppSpacingSwatch(size: AppSpacing.sm),
              AppSpacingSwatch(size: AppSpacing.md),
              AppSpacingSwatch(size: AppSpacing.lg),
              AppSpacingSwatch(size: AppSpacing.xl),
            ]),
            SizedBox(height: 24),
            _SectionHeader(text: 'Radius'),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: <Widget>[
              AppRadiusSwatch(radius: AppRadius.small),
              AppRadiusSwatch(radius: AppRadius.medium),
              AppRadiusSwatch(radius: AppRadius.large),
              AppRadiusSwatch(radius: AppRadius.extraLarge),
              AppRadiusSwatch(radius: AppRadius.circular),
            ]),
          ],
        ),
      ),
    );
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/tokens.png'));
  });
}

void _noop(int index) {}

void _noopTap() {}

void _noopBool(bool? value) {}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleLarge);
}

class AppColorswatch extends StatelessWidget {
  const AppColorswatch({super.key, required this.color});

  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      );
}

class AppGradientswatch extends StatelessWidget {
  const AppGradientswatch({super.key, required this.gradient});

  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      );
}

class AppSpacingSwatch extends StatelessWidget {
  const AppSpacingSwatch({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 60,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(size.round().toString()),
        ],
      );
}

class AppRadiusSwatch extends StatelessWidget {
  const AppRadiusSwatch({super.key, required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          const SizedBox(height: 4),
          Text(radius.round().toString()),
        ],
      );
}
