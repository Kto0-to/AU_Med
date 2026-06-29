import 'package:flutter/material.dart';

int _dateKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

class MedHeatmap extends StatelessWidget {
  final List<({DateTime date, int value})> entries;
  final DateTime minDate;
  final DateTime maxDate;
  final double? cellSize;
  final double cellSpacing;
  final double cellRadius;
  final void Function(DateTime date, int value)? onCellTap;

  const MedHeatmap({
    super.key,
    required this.entries,
    required this.minDate,
    required this.maxDate,
    this.cellSize,
    this.cellSpacing = 3,
    this.cellRadius = 3,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final entryMap = <int, int>{};
    for (final e in entries) {
      entryMap[_dateKey(e.date)] = e.value;
    }

    final startKey = _dateKey(minDate);
    final endKey = _dateKey(maxDate);
    final totalDays = endKey - startKey + 1;
    final weeks = (totalDays / 7).ceil();

    if (cellSize != null) {
      return _build(cellSize!, entryMap, startKey, weeks, context);
    }

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final cs = (availableWidth - 6 * cellSpacing) / 7;
      return _build(cs.clamp(8.0, 48.0), entryMap, startKey, weeks, context);
    });
  }

  Widget _build(
    double cs,
    Map<int, int> entryMap,
    int startKey,
    int weeks,
    BuildContext context,
  ) {
    return SizedBox(
      height: weeks * cs + (weeks - 1) * cellSpacing,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(7, (dow) {
          return Padding(
            padding: EdgeInsets.only(right: dow < 6 ? cellSpacing : 0),
            child: Column(
              children: List.generate(weeks, (week) {
                final dayOffset = week * 7 + dow;
                final date = minDate.add(Duration(days: dayOffset));
                final key = _dateKey(date);
                final value = entryMap[key] ?? 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: week < weeks - 1 ? cellSpacing : 0),
                  child: GestureDetector(
                    onTap: onCellTap != null ? () => onCellTap!(date, value) : null,
                    child: SizedBox(
                      width: cs,
                      height: cs,
                      child: value == 3
                          ? Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withAlpha(45),
                                    borderRadius: BorderRadius.circular(cellRadius),
                                  ),
                                ),
                                Positioned(
                                  right: 0.5,
                                  top: 0.5,
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(150),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: _colorForValue(value),
                                borderRadius: BorderRadius.circular(cellRadius),
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Color _colorForValue(int value) {
    switch (value) {
      case 0:
        return Colors.grey.withAlpha(45);
      case 1:
        return Colors.orange.withAlpha(100);
      case 2:
        return Colors.green.withAlpha(100);
      default:
        return Colors.grey.withAlpha(45);
    }
  }

}
