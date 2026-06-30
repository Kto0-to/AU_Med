import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import 'package:au_med/src/providers/theme_provider.dart';
import 'package:au_med/src/router/router.dart';
import 'package:au_med/src/theme/app_theme.dart';

class AuMedApp extends ConsumerWidget {
  const AuMedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'AU MedTracker',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        FLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(const Color(0xFFFF8C69)),
      darkTheme: AppTheme.dark(const Color(0xFFFF9F7A)),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
