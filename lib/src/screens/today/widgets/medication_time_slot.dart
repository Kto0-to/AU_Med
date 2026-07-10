import 'package:flutter/material.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final MedicationLogsTableData? log;
  final bool isPast;

  const StatusChip({super.key, required this.log, required this.isPast});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    if (log?.status == 'taken') {
      bgColor = context.appColors.successBg;
      textColor = context.appColors.success;
      label = 'Принято';
    } else if (isPast || log?.status == 'missed') {
      bgColor = context.appColors.errorBg;
      textColor = context.appColors.error;
      label = 'Пропущено';
    } else {
      bgColor = Colors.grey.withAlpha(20);
      textColor = Colors.grey;
      label = 'Ожидает';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MedicationTimeSlot extends StatelessWidget {
  final MedicationsTableData medication;
  final String? time;
  final MedicationLogsTableData? log;
  final bool isToday;
  final DateTime selectedDate;
  final VoidCallback? onMarkTaken;
  final VoidCallback? onTap;

  const MedicationTimeSlot({
    super.key,
    required this.medication,
    this.time,
    this.log,
    required this.isToday,
    required this.selectedDate,
    this.onMarkTaken,
    this.onTap,
  });

  bool _isPast() {
    if (log?.status == 'taken') return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (selectedDay.isAfter(today)) return false;
    if (selectedDay.isBefore(today)) return true;
    if (time == null) return false;
    final parts = time!.split(':');
    final slotTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    return slotTime.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medColor = Color(medication.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: medColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  MedicationIcons.fromCodePoint(medication.icon),
                  color: medColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDosage(
                        medication.dosageValue,
                        medication.dosageUnit,
                      ),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    if (medication.remainingPills != null)
                      Text(
                        'Остаток: ${medication.remainingPills}',
                        style: TextStyle(
                          color: medication.remainingPills! <= 5
                              ? Colors.red
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    if (time != null)
                      Text(
                        time!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      )
                    else
                      Text(
                        'По необходимости',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              StatusChip(log: log, isPast: _isPast()),
            ],
          ),
        ),
      ),
    );
  }
}
