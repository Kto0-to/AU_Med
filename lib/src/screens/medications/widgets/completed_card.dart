import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';

class CompletedCard extends StatelessWidget {
  final MedicationsTableData medication;
  final VoidCallback onReopen;

  const CompletedCard({
    super.key,
    required this.medication,
    required this.onReopen,
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
              child: const Icon(
                FontAwesome.circle_check,
                color: Colors.green,
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
            TextButton(
              onPressed: onReopen,
              child: const Text('Возобновить'),
            ),
          ],
        ),
      ),
    );
  }
}
