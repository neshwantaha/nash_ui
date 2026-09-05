import 'package:flutter_test/flutter_test.dart';
import 'package:nash_ui/nash_ui.dart';

void main() {
  group('ColorUtils', () {
    test('toHex round-trips', () {
      const Color color = Color(0xFF4F46E5);
      expect(ColorUtils.toHex(color), '#FF4F46E5');
      expect(ColorUtils.toHex(color, withAlpha: false), '#4F46E5');
    });

    test('fromHex parses all formats', () {
      expect(ColorUtils.fromHex('#FF4F46E5'), const Color(0xFF4F46E5));
      expect(ColorUtils.fromHex('4F46E5'), const Color(0xFF4F46E5));
      expect(ColorUtils.fromHex('#f00'), const Color(0xFFFF0000));
      expect(ColorUtils.fromHex('nothex'), isNull);
    });

    test('blend / lighten / darken', () {
      final Color a = ColorUtils.blend(
          const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5);
      expect(a.r, closeTo(0.5, 0.01));
      expect(a.g, closeTo(0.5, 0.01));
      expect(a.b, closeTo(0.5, 0.01));
      expect(ColorUtils.lighten(const Color(0xFF000000), 1),
          const Color(0xFFFFFFFF));
      expect(ColorUtils.darken(const Color(0xFFFFFFFF), 1),
          const Color(0xFF000000));
    });

    test('light/dark classification', () {
      expect(ColorUtils.isLight(const Color(0xFFFFFFFF)), isTrue);
      expect(ColorUtils.isDark(const Color(0xFF000000)), isTrue);
    });

    test('contrast ratio follows WCAG', () {
      expect(
          ColorUtils.contrastRatio(
              const Color(0xFF000000), const Color(0xFFFFFFFF)),
          closeTo(21, 0.1));
      expect(
          ColorUtils.contrastRatio(
              const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)),
          closeTo(1, 0.01));
      expect(
          ColorUtils.isReadable(
              const Color(0xFFFFFFFF), const Color(0xFF000000)),
          isTrue);
      expect(
          ColorUtils.isReadable(
              const Color(0xFF888888), const Color(0xFFFFFFFF)),
          isFalse);
    });

    test('contrastFor picks best text color', () {
      expect(ColorUtils.contrastFor(const Color(0xFF000000)),
          const Color(0xFFFFFFFF));
      expect(ColorUtils.contrastFor(const Color(0xFFFFFFFF)),
          const Color(0xFF000000));
    });
  });

  group('NumberUtils', () {
    test('clamp and normalize', () {
      expect(NumberUtils.clamp(5, 0, 3), 3);
      expect(NumberUtils.clamp01(-1), 0);
      expect(NumberUtils.normalize(5, 0, 10), 0.5);
    });

    test('mapRange', () {
      expect(NumberUtils.mapRange(0.5, 0, 1, 0, 100), 50);
    });

    test('perceTage', () {
      expect(NumberUtils.perceTage(25, 100), 25);
      expect(NumberUtils.perceTage(1, 0), 0);
    });

    test('roundTo', () {
      expect(NumberUtils.roundTo(3.14159, 2), 3.14);
      expect(NumberUtils.roundTo(2.675, 2), 2.68);
    });

    test('aggregation', () {
      expect(NumberUtils.sum(const [1, 2, 3]), 6);
      expect(NumberUtils.average(const [1, 2, 3]), 2);
      expect(NumberUtils.average(const []), 0);
      expect(NumberUtils.min(const [3, 1, 2]), 1);
      expect(NumberUtils.max(const [3, 1, 2]), 3);
      expect(NumberUtils.min(const []), isNull);
      expect(NumberUtils.range(const [3, 1, 5]), 4);
      expect(NumberUtils.range(const []), 0);
    });
  });

  group('FileUtils', () {
    test('path helpers', () {
      expect(FileUtils.extensionOf('reports/q3.pdf'), '.pdf');
      expect(FileUtils.extensionOf('noext'), '');
      expect(FileUtils.fileName('a/b/c.txt'), 'c.txt');
      expect(FileUtils.fileName(r'a\b\c.txt'), 'c.txt');
      expect(FileUtils.directory('a/b/c.txt'), 'a/b');
    });

    test('sizeLabel', () {
      expect(FileUtils.sizeLabel(500), '500 B');
      expect(FileUtils.sizeLabel(1536), '1.5 KB');
      expect(FileUtils.sizeLabel(5 * 1024 * 1024), '5.0 MB');
    });

    test('type detection', () {
      expect(FileUtils.isImage('photo.png'), isTrue);
      expect(FileUtils.isImage('movie.mp4'), isFalse);
      expect(FileUtils.isVideo('movie.mp4'), isTrue);
      expect(FileUtils.isAudio('song.mp3'), isTrue);
      expect(FileUtils.isArchive('bundle.zip'), isTrue);
    });
  });

  group('ImageUtils', () {
    test('initials', () {
      expect(ImageUtils.initials('Nash Taha'), 'NT');
      expect(ImageUtils.initials('Ada'), 'A');
      expect(ImageUtils.initials(''), '?');
      expect(ImageUtils.initials('Alice Bob Carol'), 'AB');
      expect(ImageUtils.initials(null), '?');
    });

    test('url detection', () {
      expect(ImageUtils.isNetworkUrl('https://x.dev/a.png'), isTrue);
      expect(ImageUtils.isNetworkUrl('assets/img/a.png'), isFalse);
      expect(ImageUtils.isAssetPath('assets/img/a.png'), isTrue);
      expect(ImageUtils.isDataUri('data:image/png;base64,xyz'), isTrue);
    });

    test('aspect ratio math', () {
      expect(ImageUtils.aspectRatio(400, 200), 2);
      expect(ImageUtils.heightForWidth(400, 2), 200);
      expect(ImageUtils.widthForHeight(200, 2), 400);
    });
  });

  group('AppHelpers', () {
    test('without removes the first matching value', () {
      expect(AppHelpers.without(const [1, 2, 3, 2], 2), <int>[1, 3, 2]);
    });

    test('clamp01 and parity', () {
      expect(AppHelpers.clamp01(1.5), 1);
      expect(AppHelpers.isEven(4), isTrue);
      expect(AppHelpers.isEven(-1), isFalse);
    });

    test('uid is formatted and unique', () {
      expect(AppHelpers.uid(), matches(RegExp(r'^\d+-\d+-[0-9a-fA-F]+$')));
      expect(AppHelpers.uid(), isNot(AppHelpers.uid()));
    });
  });

  group('AnimationUtils', () {
    test('between builds a tween', () {
      final Tween<double> tween = AnimationUtils.between(0, 10);
      expect(tween.begin, 0);
      expect(tween.end, 10);
    });

    test('inverse and stagger', () {
      expect(AnimationUtils.inverse(0.3), closeTo(0.7, 0.001));
      expect(
        AnimationUtils.stagger(3, step: const Duration(milliseconds: 50)),
        const Duration(milliseconds: 150),
      );
    });
  });

  group('PermissionUtils', () {
    test('default handler reports not implemented', () async {
      PermissionUtils.handler = _FakePermissionHandler();
      expect(await PermissionUtils.status(PermissionKind.camera),
          PermissionStatus.granted);
      expect(await PermissionUtils.request(PermissionKind.camera),
          PermissionStatus.denied);
    });
  });

  group('DeviceUtils', () {
    test('platform flags exist', () {
      expect(DeviceUtils.isMobile, isA<bool>());
      expect(DeviceUtils.isDesktop, isA<bool>());
      expect(DeviceUtils.isWeb, isA<bool>());
    });
  });
}

class _FakePermissionHandler implements PermissionHandler {
  @override
  Future<PermissionStatus> status(PermissionKind kind) async =>
      PermissionStatus.granted;

  @override
  Future<PermissionStatus> request(PermissionKind kind) async =>
      PermissionStatus.denied;

  @override
  Future<bool> openSettings() async => true;
}
