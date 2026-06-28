import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/theme_provider.dart';
import 'package:au_med/src/router/router.dart';

class AuMedApp extends ConsumerWidget {
  const AuMedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentIndex = ref.watch(accentColorIndexProvider);
    final accentColor = AccentColorNotifier.colors[accentIndex];

    return MaterialApp.router(
      title: 'MedTracker',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: _buildLightTheme(accentColor),
      darkTheme: _buildDarkTheme(accentColor),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }

  ThemeData _buildLightTheme(Color accent) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: accent,
        onPrimary: Colors.white,
        secondary: const Color(0xFFF1F5F9),
        onSecondary: const Color(0xFF1E293B),
        surface: const Color(0xFFF8FAFC),
        onSurface: const Color(0xFF0F172A),
        error: const Color(0xFFEF4444),
        onError: Colors.white,
        surfaceContainerHighest: const Color(0xFFF1F5F9),
        onSurfaceVariant: const Color(0xFF64748B),
        outline: const Color(0xFFE2E8F0),
        outlineVariant: const Color(0xFFE2E8F0),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFFE2E8F0), width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: accent.withAlpha(25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFE2E8F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme(Color accent) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color.lerp(accent, Colors.white, 0.3)!,
        onPrimary: Colors.white,
        secondary: const Color(0xFF2D2D2D),
        onSecondary: const Color(0xFFE5E5E5),
        surface: const Color(0xFF1A1A1A),
        onSurface: const Color(0xFFE5E5E5),
        error: const Color(0xFF7F1D1D),
        onError: const Color(0xFFE5E5E5),
        surfaceContainerHighest: const Color(0xFF2D2D2D),
        onSurfaceVariant: const Color(0xFF9CA3AF),
        outline: const Color(0xFF404040),
        outlineVariant: const Color(0xFF404040),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      cardTheme: CardThemeData(
        color: const Color(0xFF2D2D2D),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFF404040), width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: const Color(0xFFE5E5E5),
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF2D2D2D),
        indicatorColor: accent.withAlpha(25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF404040)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.lerp(accent, Colors.white, 0.3)!,
        foregroundColor: Colors.white,
      ),
    );
  }
}
