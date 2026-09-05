# Utilities

Utility classes for validation, formatting and common platform tasks.

## Validators

Two layers are provided:

- `Validators` — pure boolean checks (good for business logic and `.matches`
  style tests).
- `V` — `FormFieldValidator` functions that return an error message or `null`,
  ready to plug into any form field.

```dart
// Boolean checks (Validators)
Validators.isEmail('a@b.com');          // true
Validators.isPhone('+123456789');
Validators.isStrongPassword('Passw0rd!');
Validators.isNumber('42');
Validators.isURL('https://example.com');
Validators.isCreditCard('4242 4242 4242 4242'); // Luhn
Validators.isUsername('nashwan');
Validators.isBlank('   ');
Validators.isIBAN('DE89370400440532013000');

// String extensions return booleans directly
'user@example.com'.isEmail;
'abc123'.isNumber;
'p@ssw0rd!'.isStrongPassword;

// FormField validators (V) — returns error message or null
V.required(value);                 // 'This field is required'
V.email(value);                    // 'Enter a valid email address'
V.phone(value);
V.strongPassword(value);
V.minLength(value, 8);
V.maxLength(value, 16);
V.number(value);
V.url(value);
V.creditCard(value);
V.username(value);

// Usage
NashTextField(label: 'Email', validator: V.email);
```

Blank inputs pass optional validators (only `V.required` flags them), which
keeps "required field" errors separate from format errors.

## Formatters

`NashFormatter` formats numbers and masks sensitive values:

```dart
NashFormatter.number(1234567);     // '1,234,567'
NashFormatter.decimal(1234.5);     // '1,234.50'
NashFormatter.currency(12400);     // r'$12,400.00'
NashFormatter.compact(12400);      // '12.4K'
NashFormatter.percent(0.423);      // '42.3%'
NashFormatter.maskCard('4242424242424242'); // '4242 •••• •••• 4242'
NashFormatter.maskPhone('+1234567890');
NashFormatter.maskEmail('ada@example.com');
NashFormatter.truncate('Long text', 6);
NashFormatter.titleCase('hello world');     // 'Hello World'
```

## Date utilities

`NDateUtils` formats and inspects dates, and `DateX` extensions add the same
conveniences to `DateTime`.

```dart
// Formatting (intl-aware)
NDateUtils.format(date, 'yyyy-MM-dd');
NDateUtils.formatDate(date);         // 'Aug 13, 2026'
NDateUtils.formatTime(date);         // '10:30 AM'
NDateUtils.formatDateTime(date);
NDateUtils.formatRelative(date);     // '5 minutes ago'
NDateUtils.formatDuration(const Duration(minutes: 5)); // '5m'

// Introspection
NDateUtils.isToday(date);
NDateUtils.isPast(date);
NDateUtils.isFuture(date);
NDateUtils.daysInMonth(2026, 2);
NDateUtils.currentWeek();
NDateUtils.currentMonth();
NDateUtils.currentYear();
NDateUtils.addDays(date, 7);
NDateUtils.startOfDay(date);
NDateUtils.endOfDay(date);

// Extensions
DateTime.now().isToday;
DateTime.now().startOfWeek;
DateTime.now().endOfMonth;
DateTime.now().formatDate;
```

## Color utilities

`NColorUtils` and the `ColorX` extension:

```dart
NColorUtils.toHex(color);            // '#4F46E5' (uppercase)
NColorUtils.fromHex('#4F46E5');      // Color
NColorUtils.blend(a, b, 0.5);
NColorUtils.lighten(color, 0.1);
NColorUtils.darken(color, 0.1);
NColorUtils.isLight(color);
NColorUtils.isDark(color);
NColorUtils.contrastRatio(a, b);     // WCAG
NColorUtils.isReadable(fg, bg);      // AA check

// Extension
color.toHex();                       // '#4f46e5' (lowercase)
color.withOpacity(0.5);              // clamp-safe opacity
color.lighten(); / color.darken(); / color.mixWith(other);
```

## Number utilities

```dart
NNumberUtils.clamp(5, 0, 10);
NNumberUtils.clamp01(1.4);          // 1.0
NNumberUtils.normalize(50, 0, 100); // 0.5
NNumberUtils.mapRange(5, 0, 10, 0, 100); // 50
NNumberUtils.perceNashTage(25, 200);   // 12.5
NNumberUtils.roundTo(3.14159, 2);   // 3.14
NNumberUtils.sum([1, 2, 3]);        // 6
NNumberUtils.average([1, 2, 3]);    // 2
NNumberUtils.min([3, 1, 2]);
NNumberUtils.max([3, 1, 2]);
NNumberUtils.range([3, 1, 2]);      // 2
```

## Helpers

`NHelpers` provides small cross-cutting utilities:

```dart
NHelpers.uid();                     // unique id
NHelpers.debounce(const Duration(milliseconds: 300), onType);
NHelpers.focus(context, node);
NHelpers.unfocus(context);
NHelpers.pushNamed(context, '/route');
NHelpers.pushReplacementNamed(context, '/route');
NHelpers.popUntilFirst(context);
NHelpers.clamp01(1.4);              // 1.0
NHelpers.isEven(2);                 // true
```

## Device

```dart
NDeviceUtils.screenSize(context);
NDeviceUtils.devicePixelRatio(context);
NDeviceUtils.safeTop(context);
NDeviceUtils.safeBottom(context);
NDeviceUtils.isPortrait(context);
NDeviceUtils.isLandscape(context);
NDeviceUtils.deviceClass(context);  // 'phone' | 'tablet' | 'desktop'
```

## Files & images

```dart
NFileUtils.extensionOf('a/b.jpg');       // 'jpg'
NFileUtils.fileName('a/b.jpg');          // 'b.jpg'
NFileUtils.directory('a/b/c');           // 'a/b'
NFileUtils.sizeLabel(1536);              // '1.5 KB'
NFileUtils.isImage('photo.png');         // true
NFileUtils.isVideo('clip.mp4');
NFileUtils.isAudio('song.mp3');
NFileUtils.isArchive('bundle.zip');

NashImageUtils.initials('Ada Lovelace');    // 'AL'
NashImageUtils.isNetworkUrl(url);
NashImageUtils.isAssetPath('assets/a.png');
NashImageUtils.isDataUri(dataUri);
NashImageUtils.aspectRatio(width, height);
NashImageUtils.heightForWidth(width, 16 / 9);
NashImageUtils.widthForHeight(height, 16 / 9);
```

## Permissions

The permission utilities are handler-based, so they work on every platform
with a small bridge. Provide a `NPermissionHandler` and call:

```dart
NPermissionUtils.handler = MyPermissionHandler();

final NPermissionStatus status = await NPermissionUtils.request(NPermissionKind.camera);
if (status == NPermissionStatus.granted) { ... }

await NPermissionUtils.status(NPermissionKind.microphone);
await NPermissionUtils.openSettings();
```

`NPermissionKind` includes `camera` and `microphone`. Extend it with your own
values for other permission types.

## Animation utilities

```dart
NAnimationUtils.curved(controller, Curves.easeOut);
NAnimationUtils.interval(controller, begin: 0.5, end: 1);
NAnimationUtils.between(0, 100);          // Tween
NAnimationUtils.inverse(0.25);            // 0.75
NAnimationUtils.scaled(const Duration(milliseconds: 300), 2);
NAnimationUtils.stagger(index, interval: const Duration(milliseconds: 50));
```
