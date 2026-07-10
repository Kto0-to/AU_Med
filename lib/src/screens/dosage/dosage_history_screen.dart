import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:drift/drift.dart' hide Column;
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/screens/dosage/widgets/current_dosage_card.dart';
import 'package:au_med/src/screens/dosage/widgets/log_card.dart';

class DosageHistoryScreen extends ConsumerStatefulWidget {
  final int medicationId;

  const DosageHistoryScreen({super.key, required this.medicationId});

  @override
  ConsumerState<DosageHistoryScreen> createState() =>
      _DosageHistoryScreenState();
}

class _DosageHistoryScreenState extends ConsumerState<DosageHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final medAsync = ref.watch(medicationByIdProvider(widget.medicationId));
    final logsAsync = ref.watch(logsForMedicationProvider(widget.medicationId));
    return Scaffold(
      appBar: AppBar(
        title: medAsync.when(
          data: (med) => Text(med?.name ?? 'История дозировок'),
          loading: () => const Text('История дозировок'),
          error: (_, _) => const Text('История дозировок'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDosageChangeDialog,
            tooltip: 'Записать изменение дозировки',
          ),
        ],
      ),
      body: medAsync.when(
        data: (med) {
          if (med == null) {
            return const Center(child: Text('Лекарство не найдено'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CurrentDosageCard(medication: med),
              const SizedBox(height: 16),
              const Text('Журнал приёма',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              logsAsync.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                            child: Text('Нет записей',
                                style: TextStyle(color: Colors.grey[600]))),
                      ),
                    );
                  }
                  return Column(
                    children: logs
                        .map((log) => LogCard(
                              log: log,
                              color: Color(med.color),
                              onEdit: () {
                                context.push(
                                    '/medications/${widget.medicationId}/logs/${log.id}');
                              },
                            ))
                        .toList(),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddDosageChangeDialog() {
    final oldValueController = TextEditingController();
    final newValueController = TextEditingController();
    String oldUnit = 'mg';
    String newUnit = 'mg';
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменение дозировки'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldValueController,
                decoration:
                    const InputDecoration(labelText: 'Старое значение'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newValueController,
                decoration:
                    const InputDecoration(labelText: 'Новое значение'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                    labelText: 'Причина (необязательно)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (oldValueController.text.isEmpty ||
                  newValueController.text.isEmpty) {
                return;
              }
              final db = ref.read(databaseProvider);
              await db.into(db.dosageChangesTable).insert(
                    DosageChangesTableCompanion(
                      medicationId: Value(widget.medicationId),
                      oldValue: Value(
                          double.parse(oldValueController.text)),
                      oldUnit: Value(oldUnit),
                      newValue: Value(
                          double.parse(newValueController.text)),
                      newUnit: Value(newUnit),
                      reason: Value(reasonController.text.isEmpty
                          ? null
                          : reasonController.text),
                      changedAt:
                          Value(DateTime.now().toIso8601String()),
                    ),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
