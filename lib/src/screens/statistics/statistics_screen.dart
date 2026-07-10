import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/screens/statistics/widgets/bar_chart_card.dart';
import 'package:au_med/src/screens/statistics/widgets/streak_card.dart';
import 'package:au_med/src/screens/statistics/widgets/heatmap_card.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyAdherenceProvider);
    final monthlyAsync = ref.watch(monthlyAdherenceProvider);
    final streakAsync = ref.watch(streakDaysProvider);
    final heatmapAsync = ref.watch(heatmapDataProvider);
    final weeklyBarAsync = ref.watch(weeklyBarChartProvider);
    final monthlyBarAsync = ref.watch(monthlyBarChartProvider);

    final allError = weeklyAsync.hasError ||
        monthlyAsync.hasError ||
        streakAsync.hasError ||
        heatmapAsync.hasError ||
        weeklyBarAsync.hasError ||
        monthlyBarAsync.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklyAdherenceProvider);
          ref.invalidate(monthlyAdherenceProvider);
          ref.invalidate(streakDaysProvider);
          ref.invalidate(heatmapDataProvider);
          ref.invalidate(heatmapRangeProvider);
          ref.invalidate(weeklyBarChartProvider);
          ref.invalidate(monthlyBarChartProvider);
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
                            Icon(Icons.error_outline,
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
                  Builder(
                    builder: (context) {
                      final data = heatmapAsync.value;
                      final isLoading = heatmapAsync.isLoading;
                      if (data == null && isLoading) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(48),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }
                      if (data == null) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(48),
                            child: Center(
                                child:
                                    Text('Ошибка загрузки тепловой карты')),
                          ),
                        );
                      }
                      return HeatmapCard(
                          heatmapData: data, isLoading: isLoading);
                    },
                  ),
                  const SizedBox(height: 8),
                  StreakCard(streak: streakAsync.value ?? 0),
                  const SizedBox(height: 8),
                  weeklyBarAsync.when(
                    data: (data) => BarChartCard(
                      title: 'Статистика недели',
                      data: data,
                      dayLabels: const [
                        'Пн',
                        'Вт',
                        'Ср',
                        'Чт',
                        'Пт',
                        'Сб',
                        'Вс'
                      ],
                    ),
                    loading: () => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (_, _) => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: Text('Ошибка загрузки')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  monthlyBarAsync.when(
                    data: (data) {
                      final first = data.first.date;
                      final last = data.last.date;
                      final monthLabel = first.month == last.month
                          ? _formatMonth(first)
                          : '${_formatMonth(first)}–${_formatMonth(last)}';
                      return BarChartCard(
                        title: monthLabel,
                        data: data,
                        showMonthDayLabels: true,
                      );
                    },
                    loading: () => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (_, _) => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: Text('Ошибка загрузки')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }

  String _formatMonth(DateTime date) {
    const months = [
      'январь',
      'февраль',
      'март',
      'апрель',
      'май',
      'июнь',
      'июль',
      'август',
      'сентябрь',
      'октябрь',
      'ноябрь',
      'декабрь',
    ];
    return months[date.month - 1];
  }
}
