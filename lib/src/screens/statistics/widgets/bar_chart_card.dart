import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';

class BarChartCard extends StatefulWidget {
  final String title;
  final List<BarChartDayData> data;
  final List<String>? dayLabels;
  final bool showMonthDayLabels;

  const BarChartCard({
    super.key,
    required this.title,
    required this.data,
    this.dayLabels,
    this.showMonthDayLabels = false,
  });

  @override
  State<BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<BarChartCard> {
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
                if (widget.dayLabels != null &&
                    idx < widget.dayLabels!.length) {
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
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(3)),
              ),
              if (d.missed > 0)
                BarChartRodData(
                  toY: d.missed.toDouble(),
                  color: colors.error,
                  width: barWidth,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(3)),
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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            chartWidget,
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
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
                  width: 10,
                  height: 10,
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
