import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';

class ArchiveFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ArchiveFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class ArchiveCard extends StatelessWidget {
  final MedicationsTableData medication;
  final bool isCompleted;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const ArchiveCard({
    super.key,
    required this.medication,
    required this.isCompleted,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final medColor = Color(medication.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: medColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? FontAwesome.circle_check : Bootstrap.capsule_pill,
                color: isCompleted ? Colors.green : medColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medication.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    formatDosage(medication.dosageValue, medication.dosageUnit),
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Bootstrap.archive_fill),
              onPressed: onRestore,
            ),
            IconButton(
              icon: const Icon(FontAwesome.trash_can),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
