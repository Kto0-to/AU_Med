import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:day_night_themed_switcher/day_night_themed_switcher.dart';

import 'package:au_med/src/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Тема',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Тёмная тема',
                          style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant)),
                      DayNightSwitch(
                        initiallyDark: themeMode == ThemeMode.dark,
                        onChange: (isDark) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
                        },
                        size: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Цвет акцента',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(AccentColorNotifier.colors.length, (i) {
                      final c = AccentColorNotifier.colors[i];
                      final accentIndex = ref.watch(accentColorIndexProvider);
                      final isSelected = accentIndex == i;
                      return GestureDetector(
                        onTap: () => ref.read(accentColorIndexProvider.notifier).setAccentIndex(i),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: theme.colorScheme.onSurface, width: 3)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Быстрые ссылки',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.archive_outlined),
                    title: const Text('Архив'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/archive'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Уведомления',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final enabled = ref.watch(notificationsEnabledProvider);
                      return SwitchListTile(
                        title: const Text('Включить напоминания'),
                        value: enabled,
                        onChanged: (v) async {
                          ref.read(notificationsEnabledProvider.notifier).setEnabled(v);
                        },
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'AU MedTraker v1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
