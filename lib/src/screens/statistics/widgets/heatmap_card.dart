import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/shared/day_status.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/widgets/med_heatmap.dart';

class HeatmapCard extends ConsumerWidget {
  final List<HeatmapDayData> heatmapData;
  final bool isLoading;

  const HeatmapCard({super.key, required this.heatmapData, this.isLoading = false});

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
                          content: Text(
                              '$formatted — ${labels[status] ?? ''}'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(
                              bottom: 80, left: 16, right: 16),
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
                    onSelectionChanged: (v) => ref
                        .read(heatmapRangeProvider.notifier)
                        .setRange(v.first),
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
                      _HmLegend(
                          color: colors.textTertiary.withAlpha(60),
                          label: 'Нет'),
                      _HmLegend(color: colors.error, label: 'Пропущено'),
                      _HmLegend(color: colors.warning, label: 'Часть'),
                      _HmLegend(color: colors.success, label: 'Всё'),
                      _HmDotLegend(
                          color: colors.info, label: 'По надобности'),
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
        SizedBox(
          width: 10,
          height: 10,
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
