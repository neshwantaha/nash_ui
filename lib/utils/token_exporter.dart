/// Token documentation generator for the design system.
///
/// Provides methods to export design tokens as structured data (JSON, Markdown)
/// for documentation sites, design tools, and CI pipelines.
abstract final class TokenExporter {
  TokenExporter._();

  /// Exports all tokens as a structured JSON-compatible map.
  static Map<String, dynamic> exportAll() => <String, dynamic>{
        'colors': _exportColors(),
        'spacing': _exportSpacing(),
        'radius': _exportRadius(),
        'typography': _exportTypography(),
        'elevation': _exportElevation(),
        'opacity': _exportOpacity(),
        'shadows': _exportShadows(),
        'accessibility': _exportAccessibility(),
      };

  /// Exports tokens as a Markdown documentation string.
  static String exportMarkdown() {
    final StringBuffer buffer = StringBuffer()
      ..writeln('# Nash UI Design Tokens\n')

      // Colors
      ..writeln('## Colors\n')
      ..writeln('| Token | Value |')
      ..writeln('| --- | --- |')
      ..writeln('| primary | #4F46E5 |')
      ..writeln('| secondary | #0284C7 |')
      ..writeln('| success | #16A34A |')
      ..writeln('| error | #DC2626 |')
      ..writeln('| warning | #D97706 |')
      ..writeln('| info | #2563EB |')
      ..writeln()

      // Spacing
      ..writeln('## Spacing\n')
      ..writeln('| Token | Value |')
      ..writeln('| --- | --- |')
      ..writeln('| xs | 4px |')
      ..writeln('| sm | 8px |')
      ..writeln('| md | 12px |')
      ..writeln('| lg | 16px |')
      ..writeln('| xl | 20px |')
      ..writeln('| xxl | 24px |')
      ..writeln('| xxxl | 32px |')
      ..writeln('| huge | 40px |')
      ..writeln('| massive | 48px |')
      ..writeln('| giant | 64px |')
      ..writeln('| colossal | 80px |')
      ..writeln()

      // Radius
      ..writeln('## Border Radius\n')
      ..writeln('| Token | Value |')
      ..writeln('| --- | --- |')
      ..writeln('| small | 8px |')
      ..writeln('| medium | 12px |')
      ..writeln('| large | 16px |')
      ..writeln('| extraLarge | 24px |')
      ..writeln('| circular | 1000px |')
      ..writeln()

      // Typography
      ..writeln('## Typography\n')
      ..writeln('| Style | Size | Height | Weight |')
      ..writeln('| --- | --- | --- | --- |')
      ..writeln('| displayLarge | 57 | 1.12 | w700 |')
      ..writeln('| displayMedium | 45 | 1.16 | w700 |')
      ..writeln('| displaySmall | 36 | 1.22 | w700 |')
      ..writeln('| headlineLarge | 32 | 1.25 | w600 |')
      ..writeln('| headlineMedium | 28 | 1.29 | w600 |')
      ..writeln('| headlineSmall | 24 | 1.33 | w600 |')
      ..writeln('| titleLarge | 22 | 1.27 | w600 |')
      ..writeln('| titleMedium | 16 | 1.5 | w500 |')
      ..writeln('| titleSmall | 14 | 1.43 | w500 |')
      ..writeln('| bodyLarge | 16 | 1.5 | w400 |')
      ..writeln('| bodyMedium | 14 | 1.43 | w400 |')
      ..writeln('| bodySmall | 12 | 1.33 | w400 |')
      ..writeln('| labelLarge | 14 | 1.43 | w500 |')
      ..writeln('| labelMedium | 12 | 1.33 | w500 |')
      ..writeln('| labelSmall | 11 | 1.45 | w500 |')
      ..writeln()

      // Elevation
      ..writeln('## Elevation\n')
      ..writeln('| Token | Value |')
      ..writeln('| --- | --- |')
      ..writeln('| none | 0dp |')
      ..writeln('| dp1 | 1dp |')
      ..writeln('| dp2 | 2dp |')
      ..writeln('| dp3 | 3dp |')
      ..writeln('| dp4 | 4dp |')
      ..writeln('| dp6 | 6dp |')
      ..writeln('| dp8 | 8dp |')
      ..writeln('| dp12 | 12dp |')
      ..writeln('| dp16 | 16dp |')
      ..writeln('| dp24 | 24dp |')
      ..writeln();

    return buffer.toString();
  }

  static Map<String, dynamic> _exportColors() => <String, dynamic>{
        'primary': '#4F46E5',
        'secondary': '#0284C7',
        'success': '#16A34A',
        'error': '#DC2626',
        'warning': '#D97706',
        'info': '#2563EB',
      };

  static Map<String, dynamic> _exportSpacing() => <String, dynamic>{
        'xs': 4,
        'sm': 8,
        'md': 12,
        'lg': 16,
        'xl': 20,
        'xxl': 24,
        'xxxl': 32,
        'huge': 40,
        'massive': 48,
        'giant': 64,
        'colossal': 80,
      };

  static Map<String, dynamic> _exportRadius() => <String, dynamic>{
        'small': 8,
        'medium': 12,
        'large': 16,
        'extraLarge': 24,
        'circular': 1000,
      };

  static Map<String, dynamic> _exportTypography() => <String, dynamic>{
        'displayLarge': <String, dynamic>{
          'size': 57,
          'height': 1.12,
          'weight': 700
        },
        'displayMedium': <String, dynamic>{
          'size': 45,
          'height': 1.16,
          'weight': 700
        },
        'displaySmall': <String, dynamic>{
          'size': 36,
          'height': 1.22,
          'weight': 700
        },
        'headlineLarge': <String, dynamic>{
          'size': 32,
          'height': 1.25,
          'weight': 600
        },
        'headlineMedium': <String, dynamic>{
          'size': 28,
          'height': 1.29,
          'weight': 600
        },
        'headlineSmall': <String, dynamic>{
          'size': 24,
          'height': 1.33,
          'weight': 600
        },
        'titleLarge': <String, dynamic>{
          'size': 22,
          'height': 1.27,
          'weight': 600
        },
        'titleMedium': <String, dynamic>{
          'size': 16,
          'height': 1.5,
          'weight': 500
        },
        'titleSmall': <String, dynamic>{
          'size': 14,
          'height': 1.43,
          'weight': 500
        },
        'bodyLarge': <String, dynamic>{
          'size': 16,
          'height': 1.5,
          'weight': 400
        },
        'bodyMedium': <String, dynamic>{
          'size': 14,
          'height': 1.43,
          'weight': 400
        },
        'bodySmall': <String, dynamic>{
          'size': 12,
          'height': 1.33,
          'weight': 400
        },
        'labelLarge': <String, dynamic>{
          'size': 14,
          'height': 1.43,
          'weight': 500
        },
        'labelMedium': <String, dynamic>{
          'size': 12,
          'height': 1.33,
          'weight': 500
        },
        'labelSmall': <String, dynamic>{
          'size': 11,
          'height': 1.45,
          'weight': 500
        },
      };

  static Map<String, dynamic> _exportElevation() => <String, dynamic>{
        'none': 0,
        'dp1': 1,
        'dp2': 2,
        'dp3': 3,
        'dp4': 4,
        'dp6': 6,
        'dp8': 8,
        'dp12': 12,
        'dp16': 16,
        'dp24': 24,
      };

  static Map<String, dynamic> _exportOpacity() => <String, dynamic>{
        'none': 1.0,
        'xs': 0.9,
        'sm': 0.8,
        'md': 0.7,
        'lg': 0.6,
        'xl': 0.5,
        'disabled': 0.38,
        'faint': 0.12,
        'faintest': 0.08,
        'hidden': 0.0,
      };

  static Map<String, dynamic> _exportShadows() => <String, dynamic>{
        'soft': '0 1 3 rgba(0,0,0,0.1)',
        'medium': '0 4 6 rgba(0,0,0,0.1)',
        'strong': '0 10 15 rgba(0,0,0,0.1)',
        'floating': '0 20 25 rgba(0,0,0,0.1)',
      };

  static Map<String, dynamic> _exportAccessibility() => <String, dynamic>{
        'minTouchTarget': 48,
        'comfortableTouchTarget': 56,
        'contrastRatioAA': 4.5,
        'contrastRatioAAA': 7.0,
        'maxTextScale': 2.0,
        'minTextScale': 0.8,
      };
}
