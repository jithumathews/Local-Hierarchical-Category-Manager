import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Light Theme (Clean Minimal White & Black)
  // ─────────────────────────────────────────────
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF09090B), // Deep true black
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFF4F4F5), // Soft clean off-white / zinc
      onPrimaryContainer: Color(0xFF09090B),
      secondary: Color(0xFF27272A),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF4F4F5),
      onSecondaryContainer: Color(0xFF18181B),
      tertiary: Color(0xFF3F3F46),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFF4F4F5),
      onTertiaryContainer: Color(0xFF18181B),
      error: Color(0xFFDC2626),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEF2F2),
      onErrorContainer: Color(0xFF991B1B),
      surface: Color(0xFFFFFFFF), // Crisp pure white
      onSurface: Color(0xFF09090B),
      onSurfaceVariant: Color(0xFF71717A), // Refined neutral zinc
      outline: Color(0xFFD4D4D8),
      outlineVariant: Color(0xFFE4E4E7),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAFA),
      surfaceContainer: Color(0xFFF4F4F5),
      surfaceContainerHigh: Color(0xFFE4E4E7),
      surfaceContainerHighest: Color(0xFFE4E4E7),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF09090B),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: const Color(0xFFE4E4E7).withAlpha(180),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF09090B), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF09090B),
          foregroundColor: const Color(0xFFFFFFFF),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF09090B),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 2,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(Color(0xFFF4F4F5)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE4E4E7)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF4F4F5),
        side: const BorderSide(color: Color(0xFFE4E4E7), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: const Color(0xFFE4E4E7).withAlpha(180)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE4E4E7),
        thickness: 1,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme (Pitch Black Minimal Contrast)
  // ─────────────────────────────────────────────
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFAFAFA), // Crisp white on dark
      onPrimary: Color(0xFF09090B),
      primaryContainer: Color(0xFF27272A),
      onPrimaryContainer: Color(0xFFFAFAFA),
      secondary: Color(0xFFE4E4E7),
      onSecondary: Color(0xFF09090B),
      secondaryContainer: Color(0xFF27272A),
      onSecondaryContainer: Color(0xFFFAFAFA),
      tertiary: Color(0xFFA1A1AA),
      onTertiary: Color(0xFF09090B),
      tertiaryContainer: Color(0xFF27272A),
      onTertiaryContainer: Color(0xFFFAFAFA),
      error: Color(0xFFF43F5E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF4C0519),
      onErrorContainer: Color(0xFFFFD1DC),
      surface: Color(0xFF121214), // Subtle charcoal surface
      onSurface: Color(0xFFF4F4F5),
      onSurfaceVariant: Color(0xFFA1A1AA),
      outline: Color(0xFF3F3F46),
      outlineVariant: Color(0xFF27272A),
      surfaceContainerLowest: Color(0xFF09090B),
      surfaceContainerLow: Color(0xFF121214),
      surfaceContainer: Color(0xFF18181B),
      surfaceContainerHigh: Color(0xFF27272A),
      surfaceContainerHighest: Color(0xFF27272A),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF09090B),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF09090B),
        foregroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF121214),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: const Color(0xFF27272A).withAlpha(180),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF18181B),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(color: Color(0xFF27272A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(color: Color(0xFF27272A)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFFAFAFA), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          foregroundColor: const Color(0xFF09090B),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Color(0xFF09090B),
        elevation: 2,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(Color(0xFF18181B)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF27272A)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF18181B),
        side: const BorderSide(color: Color(0xFF27272A), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF121214),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: const Color(0xFF27272A).withAlpha(180)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF27272A),
        thickness: 1,
      ),
    );
  }
}
