import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:intl/intl.dart';

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
                  Builder(
                    builder: (context) {
                      final data = heatmapAsync.value;
                      final isLoading = heatmapAsync.isLoading;
                      if (data == null && isLoading) {
                        return const Card(child: Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(child: CircularProgressIndicator()),
                        ));
                      }
                      if (data == null) {
                        return const Card(child: Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(child: Text('Ошибка загрузки тепловой карты')),
                        ));
                      }
                      return _HeatmapCard(heatmapData: data, isLoading: isLoading);
                    },
                  ),
                  const SizedBox(height: 8),
                  _StreakCard(streak: streakAsync.value ?? 0),
                  const SizedBox(height: 8),
                  weeklyBarAsync.when(
                    data: (data) => _BarChartCard(
                      title: 'Статистика недели',
                      data: data,
                      dayLabels: const ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
                    ),
                    loading: () => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )),
                    error: (_, _) => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: Text('Ошибка загрузки')),
                    )),
                  ),
                  const SizedBox(height: 8),
                  monthlyBarAsync.when(
                    data: (data) {
                      final first = data.first.date;
                      final last = data.last.date;
                      final monthLabel = first.month == last.month
                          ? DateFormat('LLLL', 'ru').format(first)
                          : '${DateFormat('LLLL', 'ru').format(first)}–${DateFormat('LLLL', 'ru').format(last)}';
                      return _BarChartCard(
                        title: monthLabel,
                        data: data,
                        showMonthDayLabels: true,
                      );
                    },
                    loading: () => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )),
                    error: (_, _) => const Card(child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: Text('Ошибка загрузки')),
                    )),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}

class _BarChartCard extends StatefulWidget {
  final String title;
  final List<BarChartDayData> data;
  final List<String>? dayLabels;
  final bool showMonthDayLabels;

  const _BarChartCard({
    required this.title,
    required this.data,
    this.dayLabels,
    this.showMonthDayLabels = false,
  });

  @override
  State<_BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<_BarChartCard> {
  final _scrollController = ScrollController();
  String? _visibleMonthLabel;

  String _formatMonth(DateTime date) => DateFormat('LLLL', 'ru').format(date);

  @override
  void initState() {
    super.initState();
    if (widget.showMonthDayLabels) {
      _visibleMonthLabel = widget.title;
      _scrollController.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !widget.showMonthDayLabels) return;
    final viewportCenter = _scrollController.offset +
        _scrollController.position.viewportDimension / 2;
    final barSpacing = 24.0;
    final centerIndex =
        (viewportCenter / barSpacing).round().clamp(0, widget.data.length - 1);
    final label = _formatMonth(widget.data[centerIndex].date);
    if (label != _visibleMonthLabel) {
      setState(() => _visibleMonthLabel = label);
    }
  }

  void _scrollToToday() {
    if (!_scrollController.hasClients) return;
    final todayIndex = widget.data.lastIndexWhere(
      (d) =>
          d.date.year == DateTime.now().year &&
          d.date.month == DateTime.now().month &&
          d.date.day == DateTime.now().day,
    );
    if (todayIndex < 0) return;
    final barSpacing = 24.0;
    final viewportWidth = _scrollController.position.viewportDimension;
    final offset = (todayIndex * barSpacing) - viewportWidth + barSpacing * 4;
    _scrollController
        .jumpTo(offset.clamp(0.0, _scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final maxY = widget.data.fold<int>(0, (prev, d) {
      final dayTotal = d.taken + d.missed;
      return dayTotal > prev ? dayTotal : prev;
    });
    final topY = (maxY + 1).toDouble();
    final isMonthly = widget.showMonthDayLabels;
    final barWidth = isMonthly ? 12.0 : 20.0;

    final chart = BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topY,
        minY: 0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIdx, rod, rodIdx) {
              final d = widget.data[group.x];
              return BarTooltipItem(
                '${d.taken} из ${d.total}',
                TextStyle(color: colors.textPrimary, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                String label;
                if (widget.dayLabels != null && idx < widget.dayLabels!.length) {
                  label = widget.dayLabels![idx];
                } else {
                  label = '${widget.data[idx].date.day}';
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(label,
                      style: TextStyle(
                          fontSize: isMonthly ? 9 : 10,
                          color: colors.textTertiary)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: topY > 10 ? (topY / 4).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                if (value == value.roundToDouble() && value >= 0) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text('${value.toInt()}',
                        style: TextStyle(
                            fontSize: 10, color: colors.textTertiary)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: topY > 10 ? (topY / 4).ceilToDouble() : 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colors.textTertiary.withAlpha(40),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(widget.data.length, (i) {
          final d = widget.data[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: d.taken.toDouble(),
                color: colors.success,
                width: barWidth,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3)),
              ),
              if (d.missed > 0)
                BarChartRodData(
                  toY: d.missed.toDouble(),
                  color: colors.error,
                  width: barWidth,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3)),
                ),
            ],
          );
        }),
      ),
    );

    final chartWidget = isMonthly
        ? SizedBox(
            height: 180,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: widget.data.length * 24.0,
                height: 180,
                child: chart,
              ),
            ),
          )
        : SizedBox(height: 180, child: chart);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_visibleMonthLabel ?? widget.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            chartWidget,
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    color: colors.success,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text('Принято',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                const SizedBox(width: 16),
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text('Пропущено',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
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
  final bool isLoading;

  const _HeatmapCard({required this.heatmapData, this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(heatmapRangeProvider);
    final colors = context.appColors;

    return Stack(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Center(
                  child: MedHeatmap(
                    entries: heatmapData,
                    cellSpacing: 3,
                    cellRadius: 3,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
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
                const SizedBox(height: 8),
                Center(
                  child: SegmentedButton<int>(
                    segments: const [
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
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _HmLegend(color: colors.textTertiary.withAlpha(60), label: 'Нет'),
                      _HmLegend(color: colors.error, label: 'Пропущено'),
                      _HmLegend(color: colors.warning, label: 'Часть'),
                      _HmLegend(color: colors.success, label: 'Всё'),
                      _HmDotLegend(color: colors.info, label: 'По надобности'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          const Positioned(
            top: 8,
            right: 8,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
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
