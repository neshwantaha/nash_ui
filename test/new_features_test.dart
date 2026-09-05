import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  group('Gap Widget Tests', () {
    testWidgets('Gap renders within Column as vertical space',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                Text('A'),
                Gap(24),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      final Finder gapFinder = find.byType(Gap);
      expect(gapFinder, findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(
          find.descendant(of: gapFinder, matching: find.byType(SizedBox)));
      expect(sizedBox.height, 24);
    });

    testWidgets('Gap renders within Row as horizontal space',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: <Widget>[
                Text('A'),
                Gap(16),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      final Finder gapFinder = find.byType(Gap);
      expect(gapFinder, findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(
          find.descendant(of: gapFinder, matching: find.byType(SizedBox)));
      expect(sizedBox.width, 16);
    });

    testWidgets('Gap.expand creates an expanded space',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                Text('Top'),
                Gap.expand(),
                Text('Bottom'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Expanded), findsWidgets);
    });
  });

  group('Extensions Tests', () {
    test('Num & Duration extensions', () {
      expect(10.seconds, const Duration(seconds: 10));
      expect(5.minutes, const Duration(minutes: 5));
      expect(2.hours, const Duration(hours: 2));
      expect(1.days, const Duration(days: 1));
      expect(500.ms, const Duration(milliseconds: 500));

      expect(4.isEven, isTrue);
      expect(7.isOdd, isTrue);
      expect(5.between(1, 10), isTrue);
      expect(15.clampTo(0, 10), 10);
    });

    test('List extensions', () {
      final List<int> numbers = <int>[1, 2, 3, 4, 5];
      final List<List<int>> chunks = numbers.chunked(2);
      expect(chunks, <List<int>>[
        <int>[1, 2],
        <int>[3, 4],
        <int>[5],
      ]);

      expect(numbers.sumBy((int e) => e), 15);
      expect(<int?>[1, null, 2, null, 3].whereNotNull, <int>[1, 2, 3]);
      expect(numbers.firstWhereOrNull((int e) => e == 3), 3);
      expect(numbers.firstWhereOrNull((int e) => e == 99), isNull);
    });

    test('String extensions', () {
      expect('hello world'.toTitleCase(), 'Hello World');
      expect('Hello World!'.toSlug(), 'hello-world');
      expect('2026-08-28'.toDate(), isNotNull);
      expect('long string here'.ellipsize(5), 'long ...');
    });
  });

  group('Color Palettes & fromSeed Tests', () {
    test('Material palette values', () {
      expect(AppPalette.indigo.shade500, AppColors.primary);
      expect(AppPalette.sky.shade600, AppColors.secondary);
      expect(AppPalette.emerald.shade500, const Color(0xFF10B981));
      expect(AppPalette.red.shade500, const Color(0xFFEF4444));
      expect(AppPalette.amber.shade500, const Color(0xFFF59E0B));
    });

    test('AppPalette.fromSeed generates MaterialColor swatch', () {
      final MaterialColor palette =
          AppPalette.fromSeed(const Color(0xFF009688));
      expect(palette[500], const Color(0xFF009688));
      expect(palette[50], isNotNull);
      expect(palette[900], isNotNull);
    });
  });

  group('New Charts Tests', () {
    testWidgets('HeatMap chart renders day cells', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatMap(
              data: <DateTime, int>{
                DateTime(2026, 8): 5,
                DateTime(2026, 8, 2): 10,
              },
            ),
          ),
        ),
      );

      expect(find.byType(HeatMap), findsOneWidget);
    });

    testWidgets('GanttChart renders tasks and progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GanttChart(
              tasks: <GanttTask>[
                GanttTask(
                  name: 'Design System',
                  start: DateTime(2026, 8),
                  end: DateTime(2026, 8, 15),
                  progress: 0.8,
                ),
                GanttTask(
                  name: 'Components',
                  start: DateTime(2026, 8, 10),
                  end: DateTime(2026, 8, 25),
                  progress: 0.3,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GanttChart), findsOneWidget);
      expect(find.text('Design System'), findsOneWidget);
      expect(find.text('Components'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
    });
  });

  group('Services Tests', () {
    test('AppNetwork sets bearer token and clears it', () {
      AppNetwork.setBearerToken('test-token');
      expect(AppNetwork.defaultHeaders['Authorization'], 'Bearer test-token');
      AppNetwork.clearBearerToken();
      expect(AppNetwork.defaultHeaders.containsKey('Authorization'), isFalse);
    });

    test('AppPermissions requests permission', () async {
      final AppPermissionStatus status =
          await AppPermissions.request(AppPermission.camera);
      expect(status, AppPermissionStatus.granted);
    });

    test('AppBiometrics availability', () async {
      final bool available = await AppBiometrics.isAvailable;
      expect(available, isTrue);
    });

    test('AppNotifications records history', () async {
      AppNotifications.clearHistory();
      await AppNotifications.show(title: 'Test', body: 'Message');
      expect(AppNotifications.history.length, 1);
      expect(AppNotifications.history.first.title, 'Test');
    });
  });

  group('2.4.0 Components Tests', () {
    testWidgets('SignaturePad renders correctly and clears',
        (WidgetTester tester) async {
      final GlobalKey<SignaturePadState> sigKey =
          GlobalKey<SignaturePadState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignaturePad(key: sigKey),
          ),
        ),
      );

      expect(find.byType(SignaturePad), findsOneWidget);
      expect(sigKey.currentState?.isEmpty, isTrue);
      sigKey.currentState?.clear();
      expect(sigKey.currentState?.isEmpty, isTrue);
    });

    testWidgets('Watermark renders child and overlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Watermark(
              text: 'DRAFT',
              child: Text('Protected Content'),
            ),
          ),
        ),
      );

      expect(find.byType(Watermark), findsOneWidget);
      expect(find.text('Protected Content'), findsOneWidget);
    });

    testWidgets('SpeedDial renders main FAB and expands on tap',
        (WidgetTester tester) async {
      bool itemTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpeedDial(
              items: <SpeedDialItem>[
                SpeedDialItem(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () => itemTapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SpeedDial), findsOneWidget);
      final Finder mainFab = find.byWidgetPredicate(
        (Widget w) =>
            w is FloatingActionButton && w.heroTag == 'speed_dial_main',
      );
      expect(mainFab, findsOneWidget);

      // Tap to expand
      await tester.tap(mainFab);
      await tester.pumpAndSettle();

      expect(find.text('Share'), findsOneWidget);
      await tester.tap(find.text('Share'));
      expect(itemTapped, isTrue);
    });

    testWidgets('SwipeActionCard renders and shows child',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeActionCard(
              leftActions: <SwipeAction>[
                SwipeAction(
                  icon: Icons.archive,
                  label: 'Archive',
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
              child: const ListTile(title: Text('Swipe Me')),
            ),
          ),
        ),
      );

      expect(find.byType(SwipeActionCard), findsOneWidget);
      expect(find.text('Swipe Me'), findsOneWidget);
    });

    testWidgets('CountDownTimer & StopWatch render',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                CountDownTimer(
                    duration: Duration(minutes: 10), autoStart: false),
                StopWatch(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(CountDownTimer), findsOneWidget);
      expect(find.byType(StopWatch), findsOneWidget);
      expect(find.text('00:10:00'), findsOneWidget);
      expect(find.text('00:00:00'), findsOneWidget);
    });

    testWidgets('Accordion expands and collapses items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Accordion(
              items: <AccordionItem>[
                AccordionItem(
                  header: Text('Header 1'),
                  body: Text('Body 1'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Header 1'), findsOneWidget);
      await tester.tap(find.text('Header 1'));
      await tester.pumpAndSettle();
      expect(find.text('Body 1'), findsOneWidget);
    });

    testWidgets('StickyHeaderList renders sections',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StickyHeaderList(
              sections: <StickySection>[
                StickySection(
                  header: Text('Section A'),
                  children: <Widget>[Text('Item 1'), Text('Item 2')],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(StickyHeaderList), findsOneWidget);
      expect(find.text('Section A'), findsWidgets);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('MarkdownText renders markdown headings and content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MarkdownText(
              data: '# Title\n- Point 1\n- Point 2',
            ),
          ),
        ),
      );

      expect(find.byType(MarkdownText), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Point 1'), findsOneWidget);
    });

    testWidgets('SyntaxHighlighter renders code block',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SyntaxHighlighter(
              code: 'void main() {}',
              language: CodeLanguage.dart,
            ),
          ),
        ),
      );

      expect(find.byType(SyntaxHighlighter), findsOneWidget);
      expect(find.text('DART'), findsOneWidget);
    });

    test('Debouncer and Throttler execute accurately', () async {
      int debounced = 0;
      final Debouncer d = Debouncer(duration: const Duration(milliseconds: 30))
        ..run(() => debounced++)
        ..run(() => debounced++);
      expect(debounced, 0);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(debounced, 1);
      d.dispose();

      int throttled = 0;
      final Throttler t = Throttler(duration: const Duration(milliseconds: 40))
        ..run(() => throttled++)
        ..run(() => throttled++);
      expect(throttled, 1);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      t
        ..run(() => throttled++)
        ..dispose();
      expect(throttled, 2);
    });
  });

  group('2.5.0 Extended Features Tests', () {
    testWidgets('BeforeAfterImage renders both before and after widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BeforeAfterImage(
              before: Text('Before View'),
              after: Text('After View'),
            ),
          ),
        ),
      );

      expect(find.byType(BeforeAfterImage), findsOneWidget);
      expect(find.text('Before View'), findsOneWidget);
      expect(find.text('After View'), findsOneWidget);
    });

    testWidgets('CornerRibbon renders child and diagonal ribbon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CornerRibbon(
              text: 'PRO',
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CornerRibbon), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('CreditCardWidget detects brand and flips on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CreditCardWidget(
              cardNumber: '4111 2222 3333 4444',
              expiryDate: '12/28',
              cardHolderName: 'TEST USER',
              cvv: '123',
            ),
          ),
        ),
      );

      expect(find.byType(CreditCardWidget), findsOneWidget);
      expect(find.text('VISA'), findsOneWidget);
      expect(find.text('TEST USER'), findsOneWidget);
    });

    testWidgets('PatternLock renders 9 dots and handles gestures',
        (WidgetTester tester) async {
      List<int> result = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatternLock(
              onComplete: (List<int> pattern) => result = pattern,
            ),
          ),
        ),
      );

      expect(find.byType(PatternLock), findsOneWidget);
      expect(result, isEmpty);
    });

    testWidgets('OtpPinField renders boxes and captures digits',
        (WidgetTester tester) async {
      String pin = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpPinField(
              onCompleted: (String val) => pin = val,
            ),
          ),
        ),
      );

      expect(find.byType(OtpPinField), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pump();
      expect(pin, '1234');
    });

    testWidgets('ConfettiWidget renders child and triggers play',
        (WidgetTester tester) async {
      final GlobalKey<ConfettiWidgetState> confettiKey =
          GlobalKey<ConfettiWidgetState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfettiWidget(
              key: confettiKey,
              child: const Text('Winner!'),
            ),
          ),
        ),
      );

      expect(find.byType(ConfettiWidget), findsOneWidget);
      expect(find.text('Winner!'), findsOneWidget);
      confettiKey.currentState?.play();
      await tester.pump();
    });

    testWidgets('ScratchCard renders hidden child and scratch surface',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScratchCard(
              child: Text('Hidden Prize'),
            ),
          ),
        ),
      );

      expect(find.byType(ScratchCard), findsOneWidget);
      expect(find.text('Hidden Prize'), findsOneWidget);
    });

    testWidgets('AudioWaveform renders amplitudes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AudioWaveform(
              amplitudes: <double>[0.2, 0.5, 0.8, 0.4, 0.9, 0.3],
              progress: 0.5,
            ),
          ),
        ),
      );

      expect(find.byType(AudioWaveform), findsOneWidget);
    });

    testWidgets('QrCodeWidget and BarcodeWidget render accurately',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                QrCodeWidget(data: 'https://nashui.dev'),
                BarcodeWidget(data: '1234567890'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(QrCodeWidget), findsOneWidget);
      expect(find.byType(BarcodeWidget), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });
  });

  group('2.6.0 Modern Interactive & Visual Tests', () {
    testWidgets('MiniMap renders with controller and viewport indicator',
        (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniMap(
              controller: controller,
              child: ListView(
                controller: controller,
                children: List.generate(
                    20, (i) => SizedBox(height: 50, child: Text('Item $i'))),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MiniMap), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('CameraCapture renders viewfinder and controls',
        (WidgetTester tester) async {
      bool captured = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraCapture(
              onCapture: () => captured = true,
            ),
          ),
        ),
      );

      expect(find.byType(CameraCapture), findsOneWidget);
      expect(find.text('PHOTO'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('camera_shutter_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(captured, isTrue);
    });

    testWidgets('GradientPicker renders preview and color stops',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientPicker(),
          ),
        ),
      );

      expect(find.byType(GradientPicker), findsOneWidget);
    });

    testWidgets('RadarChart renders labels and data polygons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RadarChart(
              labels: ['Speed', 'Power', 'Defense', 'Agility'],
              dataSets: [
                RadarDataSet(
                  values: [80, 90, 70, 85],
                  color: Colors.blue,
                  label: 'Stats',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(RadarChart), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    testWidgets('PushNotificationCard renders title, body and triggers actions',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PushNotificationCard(
              title: 'Order Shipped',
              body: 'Your package #1234 is on the way',
              actions: [
                PushNotificationAction(
                    label: 'Track',
                    onTap: () => tapped = true,
                    isPrimary: true),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(PushNotificationCard), findsOneWidget);
      expect(find.text('Order Shipped'), findsOneWidget);
      expect(find.text('Track'), findsOneWidget);
      await tester.tap(find.text('Track'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('ParallaxCard renders child widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParallaxCard(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Text('Parallax Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ParallaxCard), findsOneWidget);
      expect(find.text('Parallax Content'), findsOneWidget);
    });

    testWidgets('ChatBubble renders message, timestamp and reacts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'Hello World!',
              timestamp: '10:45 AM',
              reactions: [
                ChatReaction(emoji: '❤️', count: 3),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ChatBubble), findsOneWidget);
      expect(find.text('Hello World!'), findsOneWidget);
      expect(find.text('10:45 AM'), findsOneWidget);
      expect(find.text('❤️ 3'), findsOneWidget);
    });

    testWidgets('TimelinePicker renders scrollable date list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimelinePicker(),
          ),
        ),
      );

      expect(find.byType(TimelinePicker), findsOneWidget);
    });

    testWidgets('BiometricButton renders and handles tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BiometricButton(
              onAuthenticate: () async => true,
            ),
          ),
        ),
      );

      expect(find.byType(BiometricButton), findsOneWidget);
      expect(find.text('Touch to Authenticate'), findsOneWidget);
      await tester.tap(find.byType(BiometricButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Authenticated'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('LiquidProgressBar renders percentage label and liquid wave',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidProgressBar(
              value: 0.65,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidProgressBar), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });

    testWidgets('DraggableDashboard renders grid of tiles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DraggableDashboard(
              items: [
                DashboardItem(id: '1', child: Text('Tile 1')),
                DashboardItem(id: '2', child: Text('Tile 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(DraggableDashboard), findsOneWidget);
      expect(find.text('Tile 1'), findsOneWidget);
      expect(find.text('Tile 2'), findsOneWidget);
    });
  });

  group('2.7.0 Next-Gen Creative & Interactive Components Tests', () {
    testWidgets('VoiceNotePlayer renders controls and waveforms',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VoiceNotePlayer(),
          ),
        ),
      );

      expect(find.byType(VoiceNotePlayer), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('WheelOfFortune renders spinning wheel and center hub',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WheelOfFortune(
              items: ['Prize 1', 'Prize 2', 'Prize 3', 'Prize 4'],
            ),
          ),
        ),
      );

      expect(find.byType(WheelOfFortune), findsOneWidget);
      expect(find.text('SPIN'), findsOneWidget);
    });

    testWidgets('AnimatedTextKit renders typewriter text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedTextKit(
              texts: ['Flutter Design System'],
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedTextKit), findsOneWidget);
    });

    testWidgets('GlassmorphicContainer renders child with backdrop blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassmorphicContainer(
              child: Text('Frosted Glass'),
            ),
          ),
        ),
      );

      expect(find.byType(GlassmorphicContainer), findsOneWidget);
      expect(find.text('Frosted Glass'), findsOneWidget);
    });

    testWidgets('FunnelChart renders stages and drop-off values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FunnelChart(
              stages: [
                FunnelStage(label: 'Visits', value: 1000),
                FunnelStage(label: 'Leads', value: 600),
                FunnelStage(label: 'Sales', value: 200),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FunnelChart), findsOneWidget);
      expect(find.text('Visits'), findsOneWidget);
      expect(find.text('Leads'), findsOneWidget);
      expect(find.text('Sales'), findsOneWidget);
    });

    testWidgets('EqualizerWidget renders frequency bands',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EqualizerWidget(bandCount: 6),
          ),
        ),
      );

      expect(find.byType(EqualizerWidget), findsOneWidget);
    });

    testWidgets('BoardingPassCard renders airport codes and passenger details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BoardingPassCard(
              originCode: 'RUH',
              originCity: 'Riyadh',
              destinationCode: 'DXB',
              destinationCity: 'Dubai',
              passengerName: 'Neshwan',
              flightNumber: 'SV 123',
              gate: 'A4',
              seat: '12B',
              departureTime: '10:30 AM',
            ),
          ),
        ),
      );

      expect(find.byType(BoardingPassCard), findsOneWidget);
      expect(find.text('RUH'), findsOneWidget);
      expect(find.text('DXB'), findsOneWidget);
      expect(find.text('Neshwan'), findsOneWidget);
      expect(find.text('SV 123'), findsOneWidget);
    });

    testWidgets('MagnifierLens renders child widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MagnifierLens(
              child: Text('Inspectable Content'),
            ),
          ),
        ),
      );

      expect(find.byType(MagnifierLens), findsOneWidget);
      expect(find.text('Inspectable Content'), findsOneWidget);
    });

    testWidgets('AnimatedCounter displays formatted numeric value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCounter(
              value: 2500,
              prefix: '\$',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedCounter), findsOneWidget);
    });

    testWidgets('SecurityPinKeyboard renders keypad and triggers digits',
        (WidgetTester tester) async {
      String entered = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecurityPinKeyboard(
              onKeyTap: (digit) => entered += digit,
              onDelete: () => entered = '',
            ),
          ),
        ),
      );

      expect(find.byType(SecurityPinKeyboard), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(entered, '1');
    });
  });

  group('2.8.0 Creative, Maps, Charts & Mobile UX Suite Tests', () {
    testWidgets('NeonButton renders with label and handles click',
        (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Sign In',
              onPressed: () => clicked = true,
            ),
          ),
        ),
      );

      expect(find.byType(NeonButton), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      await tester.tap(find.byType(NeonButton));
      await tester.pump();
      expect(clicked, true);
    });

    testWidgets('FloatingParticles and GradientText render accurately',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FloatingParticles(
              child: GradientText('Hello World'),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingParticles), findsOneWidget);
      expect(find.byType(GradientText), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('TypingIndicator renders animated dots',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(showLabel: true, label: 'Typing...'),
          ),
        ),
      );

      expect(find.byType(TypingIndicator), findsOneWidget);
      expect(find.text('Typing...'), findsOneWidget);
    });

    testWidgets(
        'CandlestickChart, BubbleChart, TreeMapChart and Sparkline render without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CandlestickChart(candles: [
                    Candle(
                        open: 100, high: 120, low: 90, close: 110, date: 'Mon'),
                  ]),
                  BubbleChart(points: [
                    BubblePoint(x: 10, y: 20, size: 15, label: 'A'),
                  ]),
                  TreeMapChart(nodes: [
                    TreeMapNode(label: 'Item 1', value: 50),
                  ]),
                  SparklineWidget(data: [10, 20, 15, 30]),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CandlestickChart), findsOneWidget);
      expect(find.byType(BubbleChart), findsOneWidget);
      expect(find.byType(TreeMapChart), findsOneWidget);
      expect(find.byType(SparklineWidget), findsOneWidget);
    });

    testWidgets('ReceiptCard and PriceTag render formatted currency and totals',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ReceiptCard(
                  merchantName: 'Test Cafe',
                  items: [ReceiptItem(label: 'Coffee', amount: 5.0)],
                  total: 5.0,
                ),
                PriceTag(price: 19.99, originalPrice: 29.99),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ReceiptCard), findsOneWidget);
      expect(find.text('Test Cafe'), findsOneWidget);
      expect(find.text('\$5.00'), findsNWidgets(2));
      expect(find.byType(PriceTag), findsOneWidget);
      expect(find.text('\$19.99'), findsOneWidget);
    });

    testWidgets(
        'InboxCard, PollWidget, LocationPinCard and DeliveryTracker render properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InboxCard(
                    senderName: 'Sarah',
                    preview: 'Meeting at 3pm',
                    timestamp: '12:00',
                  ),
                  PollWidget(
                    question: 'Best Language?',
                    options: [PollOption(label: 'Dart', votes: 100)],
                  ),
                  LocationPinCard(
                    title: 'HQ',
                    address: '123 Main St',
                  ),
                  DeliveryTracker(
                    steps: [
                      DeliveryStep(
                          title: 'Shipped',
                          subtitle: 'On the way',
                          time: '10:00 AM',
                          isCurrent: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(InboxCard), findsOneWidget);
      expect(find.text('Sarah'), findsOneWidget);
      expect(find.byType(PollWidget), findsOneWidget);
      expect(find.text('Best Language?'), findsOneWidget);
      expect(find.byType(LocationPinCard), findsOneWidget);
      expect(find.text('HQ'), findsOneWidget);
      expect(find.byType(DeliveryTracker), findsOneWidget);
      expect(find.text('Shipped'), findsOneWidget);
    });

    testWidgets(
        'DistanceBar, ThemeSwitcherFab, NetworkStatusBar, and PermissionRequestCard render',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const DistanceBar(
                  origin: 'City A',
                  destination: 'City B',
                  distanceText: '120 km',
                  durationText: '1 hr 15 min',
                ),
                ThemeSwitcherFab(
                  currentMode: ThemeMode.light,
                  onChanged: (_) {},
                ),
                const NetworkStatusBar(isOnline: false),
                PermissionRequestCard(
                  title: 'Camera Access',
                  description: 'Needed for scanning barcodes',
                  icon: Icons.camera_alt,
                  onRequest: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(DistanceBar), findsOneWidget);
      expect(find.text('City A'), findsOneWidget);
      expect(find.byType(ThemeSwitcherFab), findsOneWidget);
      expect(find.byType(NetworkStatusBar), findsOneWidget);
      expect(find.byType(PermissionRequestCard), findsOneWidget);
      expect(find.text('Camera Access'), findsOneWidget);
    });
  });

  group('2.10.0 Creative & Modern Components Tests', () {
    testWidgets('AppMasonry renders list and builder constructors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppMasonry(
              columnCount: 2,
              children: [
                SizedBox(height: 80, child: Text('Item 1')),
                SizedBox(height: 120, child: Text('Item 2')),
                SizedBox(height: 60, child: Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('ProgressRing and SegmentedProgressBar render properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ProgressRing(
                  value: 0.75,
                  size: 120,
                  child: Text('75%'),
                ),
                SegmentedProgressBar(
                  segmentCount: 4,
                  currentIndex: 1,
                  progress: 0.5,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(SegmentedProgressBar), findsOneWidget);
    });

    testWidgets('FlipCard flips and reveals back on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlipCard(
              front: Text('Front Side'),
              back: Text('Back Side'),
            ),
          ),
        ),
      );

      expect(find.text('Front Side'), findsOneWidget);
      await tester.tap(find.text('Front Side'));
      await tester.pumpAndSettle();
      expect(find.text('Back Side'), findsOneWidget);
    });

    testWidgets('GlowBorderWidget renders content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlowBorderWidget(
              child: Text('Glow Content'),
            ),
          ),
        ),
      );

      expect(find.text('Glow Content'), findsOneWidget);
    });

    testWidgets('StepperInput increments and decrements',
        (WidgetTester tester) async {
      num current = 5;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => StepperInput(
                value: current,
                min: 1,
                max: 10,
                onChanged: (v) => setState(() => current = v),
              ),
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('SwipeableCards, AppContextMenu, and ColorSwatchViewer render',
        (WidgetTester tester) async {
      ColorSwatchEntry? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SwipeableCards(
                  itemCount: 3,
                  itemBuilder: (context, i) => Text('Card $i'),
                ),
                AppContextMenu(
                  items: [
                    ContextMenuItem(label: 'Action', onTap: () {}),
                  ],
                  child: const Text('Target Item'),
                ),
                ColorSwatchViewer(
                  swatches: const [
                    ColorSwatchEntry(color: Color(0xFF4FC3F7), label: 'Sky'),
                  ],
                  onSelect: (entry) => selected = entry,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);
      expect(find.text('Target Item'), findsOneWidget);
      expect(find.text('Sky'), findsOneWidget);

      await tester.tap(find.text('Sky'));
      await tester.pumpAndSettle();
      expect(selected?.label, 'Sky');
    });

    testWidgets('AppToast shows and auto-dismisses',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppToast.show(
                  context,
                  message: 'Hello Toast',
                  type: AppToastType.success,
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      expect(find.text('Hello Toast'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });
  });

  group('2.11.0 Interactive, Media & UX Components Tests', () {
    testWidgets('MorphButton transitions on press',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MorphButton(
              label: 'Submit',
              onPressed: () async {
                pressed = true;
                return true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(pressed, isTrue);

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('SpotlightHighlight and ExpandableText render',
        (WidgetTester tester) async {
      const longText = 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SpotlightHighlight(
                  isVisible: false,
                  message: 'Tip here',
                  child: Text('Target Button'),
                ),
                SizedBox(
                  width: 200,
                  child: ExpandableText(
                    text: longText,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Target Button'), findsOneWidget);
      expect(find.byType(ExpandableText), findsOneWidget);
      expect(find.text(longText), findsWidgets);
    });

    testWidgets('AnimatedTabBar handles selection',
        (WidgetTester tester) async {
      int selectedTab = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => AnimatedTabBar(
                tabs: const ['Tab A', 'Tab B'],
                selectedIndex: selectedTab,
                onTabSelected: (i) => setState(() => selectedTab = i),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tab A'), findsOneWidget);
      await tester.tap(find.text('Tab B'));
      await tester.pumpAndSettle();
      expect(selectedTab, 1);
    });

    testWidgets('TagInput adds new tag', (WidgetTester tester) async {
      List<String> tags = ['flutter', 'dart'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => TagInput(
                tags: tags,
                onChanged: (val) => setState(() => tags = val),
              ),
            ),
          ),
        ),
      );

      expect(find.text('flutter'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'ui');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(tags, contains('ui'));
    });

    testWidgets('InlineAlert and AppRangeSlider render and function',
        (WidgetTester tester) async {
      bool alertActionFired = false;
      RangeValues sliderValues = const RangeValues(20, 80);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InlineAlert(
                  title: 'Attention',
                  message: 'System upgrade scheduled.',
                  type: InlineAlertType.warning,
                  actionLabel: 'Details',
                  action: () => alertActionFired = true,
                ),
                StatefulBuilder(
                  builder: (context, setState) => AppRangeSlider(
                    values: sliderValues,
                    min: 10,
                    max: 200,
                    onChanged: (v) => setState(() => sliderValues = v),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Attention'), findsOneWidget);
      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();
      expect(alertActionFired, isTrue);

      expect(find.byType(AppRangeSlider), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('PullToReveal renders child and revealed content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PullToReveal(
              revealedChild: Text('Hidden Search'),
              child: SizedBox(height: 50, child: Text('List Body')),
            ),
          ),
        ),
      );

      expect(find.text('List Body'), findsOneWidget);
    });
  });
}
