import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:intl/intl.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/widgets/dialog_icon_button.dart';

class MedicationDetailDialog extends StatefulWidget {
  final MedicationsTableData medication;
  final String? time;
  final bool isTaken;
  final VoidCallback onTake;
  final VoidCallback? onCancelTake;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final VoidCallback onComplete;
  final VoidCallback onRestore;

  const MedicationDetailDialog({
    super.key,
    required this.medication,
    this.time,
    this.isTaken = false,
    required this.onTake,
    this.onCancelTake,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  State<MedicationDetailDialog> createState() =>
      _MedicationDetailDialogState();
}

class _MedicationDetailDialogState extends State<MedicationDetailDialog> {
  late bool _isTaken;

  @override
  void initState() {
    super.initState();
    _isTaken = widget.isTaken;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medColor = Color(widget.medication.color);
    final med = widget.medication;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: medColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  MedicationIcons.fromCodePoint(med.icon),
                  color: medColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDosage(med.dosageValue, med.dosageUnit),
                      style: TextStyle(
                        fontSize: 14,
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
                    if (widget.time != null)
                      Text(
                        widget.time!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (med.notes != null && med.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              med.notes!,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
          if (med.startDate.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Bootstrap.calendar,
                    size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Начало: ${DateFormat('d MMM yyyy', 'ru').format(DateTime.parse(med.startDate))}',
                  style: TextStyle(
                      fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
          if (med.endDate != null && med.endDate!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Bootstrap.calendar_date,
                    size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Окончание: ${DateFormat('d MMM yyyy', 'ru').format(DateTime.parse(med.endDate!))}',
                  style: TextStyle(
                      fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialogIconButton(
                icon: FontAwesome.pen_to_square,
                tooltip: 'Изменить',
                onTap: widget.onEdit,
              ),
              DialogIconButton(
                icon: Bootstrap.archive,
                tooltip: 'Архив',
                onTap: widget.onArchive,
              ),
              med.isCompleted
                  ? DialogIconButton(
                      icon: IonIcons.arrow_redo,
                      tooltip: 'Возобновить',
                      onTap: widget.onRestore,
                    )
                  : DialogIconButton(
                      icon: FontAwesome.circle_check,
                      tooltip: 'Завершить',
                      onTap: widget.onComplete,
                    ),
              DialogIconButton(
                icon: FontAwesome.trash_can,
                tooltip: 'Удалить',
                onTap: widget.onDelete,
                color: Colors.red,
              ),
            ],
          ),
          if (widget.time != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(FontAwesome.clock, size: 20),
                  onPressed: widget.onEdit,
                  tooltip: 'Изменить время',
                ),
                const Spacer(),
                if (widget.time == null && widget.onCancelTake != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: widget.onCancelTake,
                      child: const Text('Отменить'),
                    ),
                  ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    if (widget.time != null) {
                      setState(() => _isTaken = !_isTaken);
                    }
                    widget.onTake();
                  },
                  icon: const Icon(FontAwesome.circle_check, size: 20),
                  label: Text(
                    _isTaken && widget.time != null ? 'Принято' : 'Принять',
                  ),
                ),
              ],
            ),
          ] else if (widget.onCancelTake != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: widget.onCancelTake,
                    child: const Text('Отменить'),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: widget.onTake,
                  icon: const Icon(FontAwesome.circle_check, size: 20),
                  label: const Text('Принять'),
                ),
              ],
            ),
          ] else if (med.times.isEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: widget.onTake,
                icon: const Icon(FontAwesome.circle_check, size: 20),
                label: const Text('Принять'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
