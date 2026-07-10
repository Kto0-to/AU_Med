import 'package:flutter/material.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/shared/dosage_format.dart';

class CurrentDosageCard extends StatelessWidget {
  final MedicationsTableData medication;
  const CurrentDosageCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final medColor = Color(medication.color);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: medColor.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.medication,
                color: medColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medication.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'Текущая: ${formatDosage(medication.dosageValue, medication.dosageUnit)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: medColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
