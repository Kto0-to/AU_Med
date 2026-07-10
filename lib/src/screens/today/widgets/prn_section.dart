import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/widgets/medication_detail_dialog.dart';

class PrnSection extends StatelessWidget {
  final List<MedicationsTableData> prn;
  final List<MedicationLogsTableData> logs;
  final bool isToday;
  final DateTime selectedDate;
  final Function(int medicationId) onMarkTaken;
  final Function(int medicationId) onCancelTake;
  final Function(MedicationsTableData medication) onEdit;
  final Function(MedicationsTableData medication) onDelete;
  final Function(MedicationsTableData medication) onArchive;
  final Function(MedicationsTableData medication) onComplete;
  final Function(MedicationsTableData medication) onRestore;

  const PrnSection({
    super.key,
    required this.prn,
    required this.logs,
    required this.isToday,
    required this.selectedDate,
    required this.onMarkTaken,
    required this.onCancelTake,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'По требованию',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        ...prn.map((med) {
          final medLogs =
              logs.where((l) => l.medicationId == med.id).toList();
          final takenCount = medLogs.where((l) => l.status == 'taken').length;
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => MedicationDetailDialog(
                  medication: med,
                  isTaken: takenCount > 0,
                  onTake: () {
                    Navigator.pop(ctx);
                    onMarkTaken(med.id);
                  },
                  onCancelTake: () {
                    Navigator.pop(ctx);
                    onCancelTake(med.id);
                  },
                  onEdit: () {
                    Navigator.pop(ctx);
                    onEdit(med);
                  },
                  onDelete: () {
                    Navigator.pop(ctx);
                    onDelete(med);
                  },
                  onArchive: () {
                    Navigator.pop(ctx);
                    onArchive(med);
                  },
                  onComplete: () {
                    Navigator.pop(ctx);
                    onComplete(med);
                  },
                  onRestore: () {
                    Navigator.pop(ctx);
                    onRestore(med);
                  },
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(med.color).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        MedicationIcons.fromCodePoint(med.icon),
                        color: Color(med.color),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatDosage(med.dosageValue, med.dosageUnit),
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (med.remainingPills != null)
                            Text(
                              'Остаток: ${med.remainingPills}',
                              style: TextStyle(
                                color: med.remainingPills! <= 5
                                    ? Colors.red
                                    : theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (takenCount > 0)
                      Chip(
                        avatar: Icon(
                          FontAwesome.circle_check,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          takenCount > 1
                              ? 'Принято x$takenCount'
                              : 'Принято',
                          style: const TextStyle(fontSize: 12),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.only(right: 4),
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(25),
                        side: BorderSide.none,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
