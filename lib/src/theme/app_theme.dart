import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show LucideIcons;

import 'app_color_tokens.dart';
import 'app_radius.dart';

class AppColors {
  static const List<int> medicationColors = [
    0xFF9ABC04,
    0xFF2196F3,
    0xFFFF9800,
    0xFFE91E63,
    0xFF9C27B0,
    0xFF00BCD4,
    0xFFFF5722,
    0xFF607D8B,
    0xFF795548,
    0xFF3F51B5,
    0xFF009688,
    0xFFFFEB3B,
  ];

  static Color getMedicationColor(int index) =>
      Color(medicationColors[index % medicationColors.length]);
}

class MedicationIcons {
  static const icons = [
    LucideIcons.tablets,
    Bootstrap.capsule,
    IonIcons.water,
    LucideIcons.briefcaseMedical,
    IonIcons.bandage,
    FontAwesome.bottle_droplet_solid,
    LucideIcons.syringe,
    LucideIcons.glassWater,
    LucideIcons.heartPulse,
  ];

  static const iconNames = [
    'таблетка',
    'капсула',
    'капли',
    'спрей',
    'повязка',
    'сироп',
    'укол',
    'стакан',
    'пульс',
  ];

  static IconData fromCodePoint(String? codePoint) {
    if (codePoint == null) return IonIcons.medical;
    final cp = int.parse(codePoint);
    for (final icon in icons) {
      if (icon.codePoint == cp) return icon;
    }
    return IonIcons.medical;
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData light(Color accent) {
    final tokens = AppColorTokens.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: accent,
        onPrimary: Colors.white,
        secondary: tokens.accentSoft,
        onSecondary: tokens.accentStrong,
        surface: tokens.screenBg,
        onSurface: tokens.textPrimary,
        error: tokens.error,
        onError: Colors.white,
        surfaceContainerHighest: tokens.sectionBg,
        onSurfaceVariant: tokens.textSecondary,
        outline: tokens.border,
        outlineVariant: tokens.border,
      ),
      scaffoldBackgroundColor: tokens.screenBg,
      extensions: [tokens],
      cardTheme: CardThemeData(
        color: tokens.cardBg,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorder,
          side: BorderSide(color: tokens.border, width: 0.9),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.screenBg,
        foregroundColor: tokens.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.cardBg,
        indicatorColor: accent.withAlpha(25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.inputBg,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: const BorderSide(color: Color(0xFFFF8C69), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      dividerTheme: DividerThemeData(
        color: tokens.border,
        thickness: 0.5,
      ),
    );
  }

  static ThemeData dark(Color accent) {
    final tokens = AppColorTokens.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color.lerp(accent, Colors.white, 0.3)!,
        onPrimary: Colors.white,
        secondary: tokens.accentSoft,
        onSecondary: tokens.textPrimary,
        surface: tokens.screenBg,
        onSurface: tokens.textPrimary,
        error: tokens.error,
        onError: Colors.white,
        surfaceContainerHighest: tokens.sectionBg,
        onSurfaceVariant: tokens.textSecondary,
        outline: tokens.border,
        outlineVariant: tokens.border,
      ),
      scaffoldBackgroundColor: tokens.screenBg,
      extensions: [tokens],
      cardTheme: CardThemeData(
        color: tokens.cardBg,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorder,
          side: BorderSide(color: tokens.border, width: 0.9),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.screenBg,
        foregroundColor: tokens.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.cardBg,
        indicatorColor: accent.withAlpha(25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.inputBg,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: tokens.error, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.lerp(accent, Colors.white, 0.3)!,
        foregroundColor: Colors.white,
      ),
      dividerTheme: DividerThemeData(
        color: tokens.border,
        thickness: 0.5,
      ),
    );
  }
}
