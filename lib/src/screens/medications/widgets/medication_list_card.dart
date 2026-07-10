import 'package:flutter/material.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/theme/app_theme.dart';

class MedicationListCard extends StatelessWidget {
  final MedicationsTableData medication;
  final VoidCallback onTap;
  final VoidCallback onTake;
  final VoidCallback onArchive;
  final VoidCallback onComplete;

  const MedicationListCard({
    super.key,
    required this.medication,
    required this.onTap,
    required this.onTake,
    required this.onArchive,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final medColor = Color(medication.color);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: medColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  MedicationIcons.fromCodePoint(medication.icon),
                  color: medColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
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
                    if (medication.isCompleted) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.appColors.successBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'ЗАВЕРШЕНО',
                          style: TextStyle(
                            color: context.appColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      formatDosage(
                          medication.dosageValue, medication.dosageUnit),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    if (medication.times.isNotEmpty)
                      Text(
                        'Время: ${medication.times}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
