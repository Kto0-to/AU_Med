import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode');
    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('dark_mode', mode == ThemeMode.dark);
    });
  }
}

final notificationsEnabledProvider = NotifierProvider<NotificationsNotifier, bool>(() {
  return NotificationsNotifier();
});

class NotificationsNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled');
    if (enabled != null) {
      state = enabled;
    }
  }

  void setEnabled(bool value) {
    state = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('notifications_enabled', value);
    });
  }
}
