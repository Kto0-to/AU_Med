import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';

class LogCard extends StatelessWidget {
  final MedicationLogsTableData log;
  final Color color;
  final VoidCallback onEdit;

  const LogCard({
    super.key,
    required this.log,
    required this.color,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheduled = DateTime.parse(log.scheduledTime);
    final theme = Theme.of(context);
    final statusColor = switch (log.status) {
      'taken' => context.appColors.success,
      'missed' => context.appColors.error,
      'skipped' => context.appColors.warning,
      _ => context.appColors.info,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM d, yyyy  HH:mm').format(scheduled),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            log.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(FontAwesome.pen_to_square,
                  size: 18, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
