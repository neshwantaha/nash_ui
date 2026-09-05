import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/material.dart' as fl show Theme;
import 'package:google_fonts/google_fonts.dart';

import '../colors/brand_colors.dart';
import '../radius/app_radius.dart';
import '../typography/app_typography.dart';
import '../typography/font_config.dart';
import 'theme_extension.dart';

/// Theme factory for the design system.
///
/// Provides opinionated, production-ready Material 3 themes:
///
/// ```dart
/// MaterialApp(
///   theme: Theme.light(),
///   darkTheme: Theme.dark(),
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class Theme {
  Theme._();

  /// Retrieves the current [ThemeData] from the nearest [Theme] ancestor.
  static ThemeData of(BuildContext context) => fl.Theme.of(context);

  /// Light theme built from the brand palette.
  static ThemeData light({
    String? fontFamily,
    bool useGoogleFonts = true,
    Color? seedColor,
    AppThemeExtension? extension,
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
  }) =>
      _build(
        brightness: Brightness.light,
        seedColor: seedColor ?? AppColors.primary,
        fontFamily: fontFamily,
        useGoogleFonts: useGoogleFonts,
        extension: extension,
        fontConfig: fontConfig,
        direction: direction,
      );

  /// Dark theme built from the brand palette.
  static ThemeData dark({
    String? fontFamily,
    bool useGoogleFonts = true,
    Color? seedColor,
    AppThemeExtension? extension,
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
  }) =>
      _build(
        brightness: Brightness.dark,
        seedColor: seedColor ?? AppColors.primary,
        fontFamily: fontFamily,
        useGoogleFonts: useGoogleFonts,
        extension: extension,
        fontConfig: fontConfig,
        direction: direction,
      );

  /// True-black (AMOLED) theme.
  static ThemeData amoled({
    String? fontFamily,
    bool useGoogleFonts = true,
    Color? seedColor,
    AppThemeExtension? extension,
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
  }) =>
      _build(
        brightness: Brightness.dark,
        seedColor: seedColor ?? AppColors.primary,
        fontFamily: fontFamily,
        useGoogleFonts: useGoogleFonts,
        amoled: true,
        extension: extension,
        fontConfig: fontConfig,
        direction: direction,
      );

  /// Builds a fully custom theme from a provided [ColorScheme].
  static ThemeData custom({
    required ColorScheme colorScheme,
    String? fontFamily,
    bool useGoogleFonts = true,
    AppThemeExtension? extension,
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
  }) =>
      _build(
        brightness: colorScheme.brightness,
        seedColor: colorScheme.primary,
        fontFamily: fontFamily,
        useGoogleFonts: useGoogleFonts,
        customScheme: colorScheme,
        extension: extension,
        fontConfig: fontConfig,
        direction: direction,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color seedColor,
    String? fontFamily,
    bool useGoogleFonts = true,
    bool amoled = false,
    ColorScheme? customScheme,
    AppThemeExtension? extension,
    FontConfig? fontConfig,
    TextDirection direction = TextDirection.ltr,
  }) {
    final bool dark = brightness == Brightness.dark;
    final ColorScheme scheme = customScheme ??
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
          primary: seedColor,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: dark
              ? (amoled ? AppColors.amoled : AppColors.surfaceDark)
              : AppColors.surface,
        );

    final ColorScheme adjusted = amoled
        ? scheme.copyWith(
            surface: AppColors.amoled,
            surfaceContainerLowest: AppColors.amoled,
            surfaceContainerLow: const Color(0xFF050505),
            surfaceContainer: const Color(0xFF0A0A0A),
            surfaceContainerHigh: const Color(0xFF111111),
            surfaceContainerHighest: const Color(0xFF1A1A1A),
          )
        : scheme;

    final AppThemeExtension tokens =
        extension ?? AppThemeExtension.defaults(brightness);
    final TextTheme textTheme = AppTypography.build(
      fontConfig: fontConfig,
      direction: direction,
      fontFamily: fontFamily,
      useGoogleFonts: useGoogleFonts,
    );

    // Resolve fontFamily string for ThemeData.fontFamily
    final String? resolvedFontFamily;
    if (fontConfig != null) {
      resolvedFontFamily = fontConfig.resolveFontFamily(direction);
    } else if (fontFamily != null && !useGoogleFonts) {
      resolvedFontFamily = fontFamily;
    } else if (fontFamily != null && GoogleFonts.config.allowRuntimeFetching) {
      resolvedFontFamily = GoogleFonts.getFont(fontFamily).fontFamily;
    } else {
      resolvedFontFamily = null;
    }

    final Color onSurface = adjusted.onSurface;
    final Color primary = adjusted.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: adjusted,
      scaffoldBackgroundColor: adjusted.surface,
      textTheme: textTheme,
      fontFamily: resolvedFontFamily,
      extensions: <ThemeExtension<ThemeExtension>>[tokens],
      // Components ------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor: adjusted.surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: adjusted.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          backgroundColor: primary,
          foregroundColor: adjusted.onPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          backgroundColor: primary,
          foregroundColor: adjusted.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
          side: BorderSide(color: adjusted.outline),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          foregroundColor: primary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          foregroundColor: primary,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: adjusted.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: adjusted.onSurfaceVariant.withValues(alpha: 0.7)),
        labelStyle:
            textTheme.bodyMedium?.copyWith(color: adjusted.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: adjusted.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: adjusted.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: adjusted.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: adjusted.error, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: adjusted.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: adjusted.surfaceContainer,
        selectedItemColor: primary,
        unselectedItemColor: adjusted.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: adjusted.surfaceContainer,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(color: adjusted.onSurface),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: adjusted.surface,
        selectedIconTheme: IconThemeData(color: primary),
        unselectedIconTheme: IconThemeData(color: adjusted.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle:
            textTheme.labelMedium?.copyWith(color: adjusted.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.circular)),
        side: BorderSide(color: adjusted.outlineVariant),
        labelStyle: textTheme.labelLarge?.copyWith(color: adjusted.onSurface),
        backgroundColor: adjusted.surfaceContainerHighest,
        selectedColor: primary.withValues(alpha: 0.12),
        checkmarkColor: primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        // backgroundColor and contentTextStyle intentionally omitted
        // so each showXxxSnack() call controls its own colors.
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: adjusted.surfaceContainerLow,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge)),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: onSurface),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: adjusted.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: adjusted.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.extraLarge)),
        ),
        showDragHandle: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primary
              : adjusted.surfaceContainerHighest,
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : adjusted.outline,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary : null,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: textTheme.labelLarge?.copyWith(
          color: adjusted.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral[800],
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: adjusted.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
