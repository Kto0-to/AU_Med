import 'package:flutter/material.dart';

import 'package:au_med/src/shared/day_status.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';

class MedHeatmap extends StatelessWidget {
  final List<HeatmapDayData> entries;
  final double? cellSize;
  final double cellSpacing;
  final double cellRadius;
  final void Function(DateTime date, DayStatus status)? onCellTap;

  const MedHeatmap({
    super.key,
    required this.entries,
    this.cellSize,
    this.cellSpacing = 3,
    this.cellRadius = 3,
    this.onCellTap,
  });

  static const _dowLabels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  static const double _labelWidth = 22;

  @override
  Widget build(BuildContext context) {
    final weeks = entries.length ~/ 7;
    if (weeks == 0) return const SizedBox.shrink();

    if (cellSize != null) {
      return _build(cellSize!, weeks, context);
    }

    return LayoutBuilder(builder: (context, constraints) {
      final labelAndSpacing = _labelWidth + cellSpacing;
      final availableWidth = constraints.maxWidth - labelAndSpacing;
      final cs = (availableWidth - (weeks - 1) * cellSpacing) / weeks;
      return _build(cs.clamp(8.0, 48.0), weeks, context);
    });
  }

  Widget _build(double cs, int weeks, BuildContext context) {
    final colors = context.appColors;
    final totalWidth = _labelWidth + cellSpacing + weeks * cs + (weeks - 1) * cellSpacing;
    final totalHeight = 7 * cs + 6 * cellSpacing;

    return SizedBox(
      height: totalHeight + 20,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          height: totalHeight + 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(7, (di) {
                  final label = _dowLabels[di];
                  return SizedBox(
                    width: _labelWidth,
                    height: cs + cellSpacing,
                    child: Padding(
                      padding: EdgeInsets.only(top: di < 6 ? cellSpacing * 0.5 : 0),
                      child: Text(
                        label,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 9,
                          color: context.appColors.textTertiary,
                          height: 1,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(width: cellSpacing),
              Row(
                spacing: cellSpacing,
                children: List.generate(weeks, (wi) {
                  final weekStart = wi * 7;
                  return Column(
                    spacing: cellSpacing,
                    children: List.generate(7, (di) {
                      final idx = weekStart + di;
                      if (idx >= entries.length) return SizedBox.square(dimension: cs);
                      final dayData = entries[idx];
                      return GestureDetector(
                        onTap: onCellTap != null
                            ? () => onCellTap!(dayData.date, dayData.status)
                            : null,
                        child: _HeatmapCell(
                          dayData: dayData,
                          size: cs,
                          radius: cellRadius,
                          colors: colors,
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  final HeatmapDayData dayData;
  final double size;
  final double radius;
  final AppColorTokens colors;

  const _HeatmapCell({
    required this.dayData,
    required this.size,
    required this.radius,
    required this.colors,
  });

  Color get _fillColor {
    switch (dayData.status) {
      case DayStatus.future:
        return colors.textTertiary;
      case DayStatus.empty:
        return colors.textTertiary.withAlpha(60);
      case DayStatus.completed:
        return colors.success;
      case DayStatus.partial:
        return colors.warning;
      case DayStatus.missed:
        return colors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dayData.hasPrn) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _fillColor,
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.info,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _fillColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
