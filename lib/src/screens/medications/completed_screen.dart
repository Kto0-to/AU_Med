import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:drift/drift.dart' hide Column;
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/providers/medications_provider.dart';

class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(completedMedicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Завершённые')),
      body: completedAsync.when(
        data: (medications) {
          if (medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesome.circle_check, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Нет завершённых лекарств',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final med = medications[index];
              return _CompletedCard(
                medication: med,
                onReopen: () => _reopen(ref, med.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _reopen(WidgetRef ref, int id) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.medicationsTable)..where((t) => t.id.equals(id)))
        .write(const MedicationsTableCompanion(isCompleted: Value(false)));
    ref.invalidate(completedMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
  }
}

class _CompletedCard extends StatelessWidget {
  final MedicationsTableData medication;
  final VoidCallback onReopen;

  const _CompletedCard({
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
              child: const Icon(FontAwesome.circle_check, color: Colors.green, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medication.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(formatDosage(medication.dosageValue, medication.dosageUnit),
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            TextButton(onPressed: onReopen, child: const Text('Возобновить')),
          ],
        ),
      ),
    );
  }
}
