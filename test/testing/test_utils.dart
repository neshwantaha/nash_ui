import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testing utilities for the Nash UI design system.
///
/// Provides finder helpers, pump helpers, and golden test configuration.
abstract final class TestUtils {
  TestUtils._();

  // ---------------------------------------------------------------------------
  // Finder Helpers
  // ---------------------------------------------------------------------------

  /// Finds a widget by its [Key].
  static Finder findByKey(String key) => find.byKey(Key(key));

  /// Finds a widget by its text content.
  static Finder findByText(String text) => find.text(text);

  /// Finds a widget by its type.
  static Finder findByType<T extends Widget>() => find.byType(T);

  /// Finds a widget by its tooltip.
  static Finder findByTooltip(String tooltip) => find.byTooltip(tooltip);

  /// Finds the first widget of type [T].
  static T getWidget<T extends Widget>(WidgetTester tester) {
    final T widget = tester.widget<T>(find.byType(T));
    return widget;
  }

  /// Finds multiple widgets of type [T].
  static List<T> getWidgets<T extends Widget>(WidgetTester tester) =>
      tester.widgetList<T>(find.byType(T)).toList();

  // ---------------------------------------------------------------------------
  // Pump Helpers
  // ---------------------------------------------------------------------------

  /// Pumps a widget wrapped in [MaterialApp] and [Theme].
  static Future<void> pumpApp(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
    Locale? locale,
    NavigatorObserver? observer,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? ThemeData(useMaterial3: true),
        locale: locale,
        navigatorObservers:
            observer != null ? <NavigatorObserver>[observer] : [],
        home: Scaffold(body: child),
      ),
    );
  }

  /// Pumps a widget as a full-screen page.
  static Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? ThemeData(useMaterial3: true),
        home: page,
      ),
    );
  }

  /// Pumps a widget and waits for animations to settle.
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
    Duration? timeout,
  }) async {
    await pumpApp(tester, child, theme: theme);
    await tester.pumpAndSettle(timeout ?? const Duration(seconds: 2));
  }

  /// Pumps multiple frames for animations.
  static Future<void> pumpFrames(
    WidgetTester tester,
    Widget child, {
    int frames = 3,
    Duration interval = const Duration(milliseconds: 16),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: child),
      ),
    );
    for (int i = 0; i < frames; i++) {
      await tester.pump(interval);
    }
  }

  // ---------------------------------------------------------------------------
  // Gesture Helpers
  // ---------------------------------------------------------------------------

  /// Taps a widget found by key.
  static Future<void> tapByKey(
    WidgetTester tester,
    String key, {
    bool warnIfMissed = true,
  }) async {
    await tester.tap(find.byKey(Key(key)), warnIfMissed: warnIfMissed);
    await tester.pump();
  }

  /// Taps a widget found by text.
  static Future<void> tapByText(
    WidgetTester tester,
    String text, {
    bool warnIfMissed = true,
  }) async {
    await tester.tap(find.text(text), warnIfMissed: warnIfMissed);
    await tester.pump();
  }

  /// Enters text into a text field.
  static Future<void> enterText(
    WidgetTester tester,
    String text, {
    Finder? finder,
  }) async {
    await tester.enterText(finder ?? find.byType(TextField).first, text);
    await tester.pump();
  }

  /// Scrolls until a widget is visible.
  static Future<void> scrollUntilVisible(
    WidgetTester tester, {
    required Finder finder,
    Finder? scrollable,
    double delta = -100,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollable ?? find.byType(Scrollable).first,
    );
  }

  // ---------------------------------------------------------------------------
  // Assertion Helpers
  // ---------------------------------------------------------------------------

  /// Asserts that a widget with the given key exists.
  static void expectByKey(WidgetTester tester, String key) {
    expect(find.byKey(Key(key)), findsOneWidget);
  }

  /// Asserts that a widget with the given text exists.
  static void expectText(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Asserts that a widget of type [T] exists.
  static void expectType<T extends Widget>(WidgetTester tester) {
    expect(find.byType(T), findsOneWidget);
  }

  /// Asserts that no error widget is shown.
  static void expectNoErrors(WidgetTester tester) {
    expect(find.byIcon(Icons.error), findsNothing);
  }

  // ---------------------------------------------------------------------------
  // Golden Test Helpers
  // ---------------------------------------------------------------------------

  /// Configures the golden test comparator for CI environments.
  static void configureGoldenTest() {
    // Uses the default golden file comparator.
    // To update goldens, run: flutter test --update-goldens
  }

  /// Creates a golden test with the standard configuration.
  static Future<void> matchesGolden(
    WidgetTester tester,
    String name, {
    Widget? child,
    double width = 390,
    double height = 844,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: SizedBox(
            width: width,
            height: height,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/$name.png'),
    );
  }
}

/// Extension on WidgetTester for convenience.
extension WidgetTesterX on WidgetTester {
  /// Pump and settle a Nash UI widget.
  Future<void> pumpWidget(
    Widget widget, {
    ThemeData? theme,
  }) async {
    await TestUtils.pumpAndSettle(this, widget, theme: theme);
  }

  /// Tap a widget by key.
  Future<void> tapNash(String key) => TestUtils.tapByKey(this, key);

  /// Enter text by key.
  Future<void> enterNash(String key, String text) async {
    await enterText(find.byKey(Key(key)), text);
    await pump();
  }
}
