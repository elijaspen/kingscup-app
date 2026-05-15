import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core colors from Stitch DESIGN.md
  static const Color surface = Color(0xFFFDF9F4);
  static const Color surfaceDim = Color(0xFFDDD9D5);
  static const Color surfaceBright = Color(0xFFFDF9F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF7F3EE);
  static const Color surfaceContainer = Color(0xFFF1EDE8);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE6E2DD);
  static const Color onSurface = Color(0xFF1C1C19);
  static const Color onSurfaceVariant = Color(0xFF51443C);
  static const Color inverseSurface = Color(0xFF31302D);
  static const Color inverseOnSurface = Color(0xFFF4F0EB);
  static const Color outline = Color(0xFF83746B);
  static const Color outlineVariant = Color(0xFFD5C3B8);
  static const Color surfaceTint = Color(0xFF805533);
  static const Color primary = Color(0xFF6F4627);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF8B5E3C);
  static const Color onPrimaryContainer = Color(0xFFFFE3D1);
  static const Color inversePrimary = Color(0xFFF4BB92);
  static const Color secondary = Color(0xFF7D562D);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color tertiary = Color(0xFF604B3E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF7A6355);
  static const Color onTertiaryContainer = Color(0xFFFFE2D1);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color background = Color(0xFFFDF9F4);
  static const Color onBackground = Color(0xFF1C1C19);

  // Status & Brand
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusPreparing = Color(0xFF8B5E3C);
  static const Color statusDelivering = Color(0xFF4B5EAA);
  static const Color statusCompleted = Color(0xFF166534);
  static const Color creamAccent = Color(0xFFFAF9F6);
  static const Color espressoDark = Color(0xFF261C15);
  static const Color primaryFixed = Color(0xFFFBDDCA);
  static const Color onTertiaryFixedVariant = Color(0xFF384A4C);

  static const List<BoxShadow> ambientShadow = [
    BoxShadow(
      color: Color.fromRGBO(61, 43, 31, 0.08),
      blurRadius: 16,
      offset: Offset(0, 4),
    )
  ];
}

class AppTheme {
  static ThemeData get light {
    final TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.libreCaslonText(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -0.02 * 48,
        color: AppColors.onSurface,
      ),
      headlineLarge: GoogleFonts.libreCaslonText(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: AppColors.onSurface,
      ),
      headlineMedium: GoogleFonts.libreCaslonText(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: AppColors.onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.onSurfaceVariant,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.05 * 14,
        color: AppColors.onSurfaceVariant,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 24 / 20,
        color: AppColors.primaryContainer,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimaryContainer,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryContainer,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.primaryContainer, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant),
        secondaryLabelStyle: GoogleFonts.manrope(fontSize: 14, color: AppColors.onPrimaryContainer),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryContainer),
        ),
      ),
    );
  }
}
