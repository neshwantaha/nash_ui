import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  test('FontConfig.asset creates valid LTR and RTL fonts', () {
    final config = FontConfig.asset(ltr: 'Roboto', rtl: 'Cairo');
    expect(config.resolveFontFamily(TextDirection.ltr), 'Roboto');
    expect(config.resolveFontFamily(TextDirection.rtl), 'Cairo');
  });

  test('FontConfig.google single family works for both directions', () {
    final config = FontConfig.google(ltr: 'Poppins');
    expect(config.resolveFontFamily(TextDirection.ltr), contains('Poppins'));
    expect(config.resolveFontFamily(TextDirection.rtl), contains('Poppins'));
  });

  test('FontConfig.system returns null for default font', () {
    const config = FontConfig.system();
    expect(config.resolveFontFamily(TextDirection.ltr), isNull);
    expect(config.resolveFontFamily(TextDirection.rtl), isNull);
  });

  test('FontConfig.mixed handles google for LTR and asset for RTL', () {
    final config =
        FontConfig.mixed(ltrGoogle: 'Inter', rtlAsset: 'CustomArabic');
    expect(config.resolveFontFamily(TextDirection.ltr), contains('Inter'));
    expect(config.resolveFontFamily(TextDirection.rtl), 'CustomArabic');
  });

  test('Theme.light accepts fontConfig for RTL and LTR', () {
    final config = FontConfig.asset(ltr: 'EnglishFont', rtl: 'ArabicFont');
    final themeLtr = Theme.light(fontConfig: config);
    final themeRtl =
        Theme.light(fontConfig: config, direction: TextDirection.rtl);

    expect(themeLtr.textTheme.bodyMedium?.fontFamily, 'EnglishFont');
    expect(themeRtl.textTheme.bodyMedium?.fontFamily, 'ArabicFont');
  });

  testWidgets('DirectionText applies appropriate font based on direction',
      (tester) async {
    final config = FontConfig.asset(ltr: 'EnglishFont', rtl: 'ArabicFont');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: DirectionText(
            'مرحبا',
            fontConfig: config,
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.byType(Text));
    expect(textWidget.style?.fontFamily, 'ArabicFont');
  });
}
