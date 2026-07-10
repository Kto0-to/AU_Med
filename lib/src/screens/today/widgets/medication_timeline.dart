import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/screens/today/widgets/empty_state.dart';
import 'package:au_med/src/screens/today/widgets/medication_time_slot.dart';
import 'package:au_med/src/widgets/medication_detail_dialog.dart';

class MedicationTimeline extends StatelessWidget {
  final List<
    ({
      MedicationsTableData medication,
      String? time,
      MedicationLogsTableData? log,
    })
  >
  slots;
  final bool isToday;
  final DateTime selectedDate;
  final Function(int medicationId, String? time) onMarkTaken;
  final Function(MedicationsTableData medication) onEdit;
  final Function(MedicationsTableData medication) onDelete;
  final Function(MedicationsTableData medication) onArchive;
  final Function(MedicationsTableData medication) onComplete;
  final Function(MedicationsTableData medication) onRestore;

  const MedicationTimeline({
    super.key,
    required this.slots,
    required this.isToday,
    required this.selectedDate,
    required this.onMarkTaken,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const EmptyState();
    }

    final theme = Theme.of(context);
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          isToday
              ? 'Расписание на сегодня'
              : "Расписание на ${DateFormat('d MMMM', 'ru').format(selectedDate)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    ];

    for (final slot in slots) {
      final isTaken = slot.log?.status == 'taken';
      children.add(
        MedicationTimeSlot(
          medication: slot.medication,
          time: slot.time,
          log: slot.log,
          isToday: isToday,
          selectedDate: selectedDate,
          onMarkTaken: () => onMarkTaken(slot.medication.id, slot.time),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => MedicationDetailDialog(
                medication: slot.medication,
                time: slot.time,
                isTaken: isTaken,
                onTake: () {
                  Navigator.pop(context);
                  onMarkTaken(slot.medication.id, slot.time);
                },
                onEdit: () {
                  Navigator.pop(context);
                  onEdit(slot.medication);
                },
                onDelete: () {
                  Navigator.pop(context);
                  onDelete(slot.medication);
                },
                onArchive: () {
                  Navigator.pop(context);
                  onArchive(slot.medication);
                },
                onComplete: () {
                  Navigator.pop(context);
                  onComplete(slot.medication);
                },
                onRestore: () {
                  Navigator.pop(context);
                  onRestore(slot.medication);
                },
              ),
            );
          },
        ),
      );
      children.add(const SizedBox(height: 8));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
