import 'package:flutter/material.dart';

import 'package:au_med/src/shared/day_status.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final List<HeatmapDayData> heatmapData;
  final ValueChanged<DateTime> onSelectDate;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.heatmapData,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final weekStart = selectedDate.subtract(
      Duration(days: (selectedDate.weekday - DateTime.monday) % 7),
    );
    final weekdayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    final dayMap = <DateTime, HeatmapDayData>{};
    for (final d in heatmapData) {
      dayMap[DateTime(d.date.year, d.date.month, d.date.day)] = d;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final day = weekStart.add(Duration(days: i));
            final isSelected = day == selectedDate;
            final dayData = dayMap[day];

            Color indicatorColor;
            bool hasColor = false;

            if (dayData != null) {
              switch (dayData.status) {
                case DayStatus.completed:
                  indicatorColor = colors.success.withAlpha(180);
                  hasColor = true;
                case DayStatus.partial:
                  indicatorColor = colors.warning.withAlpha(180);
                  hasColor = true;
                case DayStatus.missed:
                  indicatorColor = colors.error.withAlpha(180);
                  hasColor = true;
                case DayStatus.empty:
                case DayStatus.future:
                  indicatorColor = Colors.transparent;
              }
            } else {
              indicatorColor = Colors.transparent;
            }

            return GestureDetector(
              onTap: () => onSelectDate(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.primary.withAlpha(100),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      weekdayNames[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: Stack(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: hasColor
                                  ? indicatorColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (dayData?.hasPrn == true)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.info,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
