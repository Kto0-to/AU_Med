import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/widgets/med_heatmap.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyAdherenceProvider);
    final monthlyAsync = ref.watch(monthlyAdherenceProvider);
    final streakAsync = ref.watch(streakDaysProvider);
    final dailyLogsAsync = ref.watch(dailyLogsProvider);
    final prnDaysAsync = ref.watch(prnDaysLast30Provider);
    final missedDaysAsync = ref.watch(missedDaysProvider);
    final pendingDaysAsync = ref.watch(pendingDaysProvider);

    final allError = weeklyAsync.hasError ||
        monthlyAsync.hasError ||
        streakAsync.hasError ||
        dailyLogsAsync.hasError ||
        prnDaysAsync.hasError ||
        missedDaysAsync.hasError ||
        pendingDaysAsync.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklyAdherenceProvider);
          ref.invalidate(monthlyAdherenceProvider);
          ref.invalidate(streakDaysProvider);
          ref.invalidate(dailyLogsProvider);
          ref.invalidate(missedDaysProvider);
          ref.invalidate(pendingDaysProvider);
        },
        child: allError
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(FontAwesome.circle_xmark,
                                size: 48, color: Colors.red[300]),
                            const SizedBox(height: 12),
                            const Text('Ошибка загрузки данных'),
                            const SizedBox(height: 8),
                            Text(
                              'Потяните вниз для обновления',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _AdherenceCard(
                          title: 'За неделю',
                          rate: weeklyAsync.value ?? 0,
                          color: AppColors.taken,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AdherenceCard(
                          title: 'За месяц',
                          rate: monthlyAsync.value ?? 0,
                          color: AppColors.taken,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _StreakCard(streak: streakAsync.value ?? 0),
                  const SizedBox(height: 12),
                  if (dailyLogsAsync.hasValue)
                    _HeatmapCard(
                      dailyLogs: dailyLogsAsync.value!,
                      prnDays: prnDaysAsync.asData?.value ?? {},
                      missedDays: missedDaysAsync.asData?.value ?? {},
                      pendingDays: pendingDaysAsync.asData?.value ?? {},
                    )
                  else
                    const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}

class _AdherenceCard extends StatelessWidget {
  final String title;
  final double rate;
  final Color color;

  const _AdherenceCard({
    required this.title,
    required this.rate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              '${(rate * 100).toInt()}%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rate,
                backgroundColor: color.withAlpha(25),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              IonIcons.flame,
              size: 40,
              color: streak > 0 ? Colors.orange : Colors.grey,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak дн',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: streak > 0 ? Colors.orange : Colors.grey,
                  ),
                ),
                Text(
                  'Текущая серия',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  final Map<DateTime, List<bool>> dailyLogs;
  final Set<DateTime> prnDays;
  final Set<DateTime> missedDays;
  final Set<DateTime> pendingDays;
  const _HeatmapCard({
    required this.dailyLogs,
    required this.prnDays,
    required this.missedDays,
    required this.pendingDays,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final scheduledEntries = dailyLogs.entries
        .where((e) =>
            !e.key.isBefore(monthStart) && !e.key.isAfter(monthEnd))
        .map((e) {
      final list = e.value;
      final takenCount = list.where((t) => t).length;
      final totalCount = list.length;
      final hasPending = pendingDays.contains(e.key);
      int value;
      if (takenCount == totalCount && !hasPending) {
        value = 2;
      } else if (missedDays.contains(e.key)) {
        value = 4;
      } else if (hasPending) {
        value = 0;
      } else if (takenCount == 0) {
        value = 0;
      } else {
        value = 1;
      }
      return (date: e.key, value: value);
    }).toList();

    final scheduledKeys = scheduledEntries.map((e) => e.date).toSet();
    final prnOnly = prnDays.where((d) =>
        !d.isBefore(monthStart) && !d.isAfter(monthEnd) && !scheduledKeys.contains(d));
    final entries = [
      ...scheduledEntries,
      for (final d in prnOnly) (date: d, value: 3),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Тепловая карта',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Center(child: MedHeatmap(
              entries: entries,
              minDate: monthStart,
              maxDate: monthEnd,
              cellSpacing: 3,
              cellRadius: 3,
              onCellTap: (date, value) {
                final formatted = '${date.day}.${date.month}';
                String status;
                if (value == 4) {
                  status = 'пропущено всё';
                } else if (value == 0) {
                  status = 'не принято';
                } else if (value == 1) {
                  status = 'частично';
                } else if (value == 3) {
                  status = 'по требованию';
                } else {
                  status = 'полностью';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$formatted — $status'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                  ),
                );
              },
            )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HmLegend(color: Colors.grey.withAlpha(25), label: 'Нет'),
                const SizedBox(width: 12),
                _HmLegend(color: AppColors.missed.withAlpha(200), label: 'Пропущено'),
                const SizedBox(width: 12),
                _HmLegend(color: Colors.orange.withAlpha(200), label: 'Часть'),
                const SizedBox(width: 12),
                _HmLegend(color: Colors.green.withAlpha(200), label: 'Всё'),
                const SizedBox(width: 12),
                _HmPrnLegend(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HmPrnLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                right: 0.5,
                top: 0.5,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text('PRN', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

class _HmLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _HmLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
