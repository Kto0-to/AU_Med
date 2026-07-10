import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/shared/day_status.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/widgets/med_heatmap.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyAdherenceProvider);
    final monthlyAsync = ref.watch(monthlyAdherenceProvider);
    final streakAsync = ref.watch(streakDaysProvider);
    final heatmapAsync = ref.watch(heatmapDataProvider);

    final allError = weeklyAsync.hasError ||
        monthlyAsync.hasError ||
        streakAsync.hasError ||
        heatmapAsync.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklyAdherenceProvider);
          ref.invalidate(monthlyAdherenceProvider);
          ref.invalidate(streakDaysProvider);
          ref.invalidate(heatmapDataProvider);
          ref.invalidate(heatmapRangeProvider);
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
                          color: context.appColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AdherenceCard(
                          title: 'За месяц',
                          rate: monthlyAsync.value ?? 0,
                          color: context.appColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _StreakCard(streak: streakAsync.value ?? 0),
                  const SizedBox(height: 12),
                  heatmapAsync.when(
                    data: (data) => _HeatmapCard(heatmapData: data),
                    loading: () => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )),
                    error: (_, _) => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: Text('Ошибка загрузки тепловой карты')),
                    )),
                  ),
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

class _HeatmapCard extends ConsumerWidget {
  final List<HeatmapDayData> heatmapData;

  const _HeatmapCard({required this.heatmapData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(heatmapRangeProvider);
    final colors = context.appColors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Тепловая карта',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Center(
              child: MedHeatmap(
                entries: heatmapData,
                cellSpacing: 3,
                cellRadius: 3,
                onCellTap: (date, status) {
                  final formatted = '${date.day}.${date.month}';
                  final labels = {
                    DayStatus.future: 'ожидание',
                    DayStatus.empty: 'нет приёма',
                    DayStatus.completed: 'полностью',
                    DayStatus.partial: 'частично',
                    DayStatus.missed: 'пропущено всё',
                  };
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$formatted — ${labels[status] ?? ''}'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 30, label: Text('30')),
                  ButtonSegment(value: 60, label: Text('60')),
                  ButtonSegment(value: 90, label: Text('90')),
                ],
                selected: {range},
                onSelectionChanged: (v) =>
                    ref.read(heatmapRangeProvider.notifier).setRange(v.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HmLegend(color: colors.textTertiary.withAlpha(60), label: 'Нет'),
                  const SizedBox(width: 8),
                  _HmLegend(color: colors.error, label: 'Пропущено'),
                  const SizedBox(width: 8),
                  _HmLegend(color: colors.warning, label: 'Часть'),
                  const SizedBox(width: 8),
                  _HmLegend(color: colors.success, label: 'Всё'),
                  const SizedBox(width: 8),
                  _HmDotLegend(color: colors.info, label: 'PRN'),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _HmDotLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _HmDotLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
