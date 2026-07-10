import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/screens/medications/widgets/archive_card.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final dataAsync = _showCompleted
        ? ref.watch(completedMedicationsProvider)
        : ref.watch(archivedMedicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_showCompleted ? 'Завершённые' : 'Архив'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                ArchiveFilterChip(
                  label: 'Архивные',
                  isSelected: !_showCompleted,
                  onTap: () => setState(() => _showCompleted = false),
                ),
                const SizedBox(width: 8),
                ArchiveFilterChip(
                  label: 'Завершённые',
                  isSelected: _showCompleted,
                  onTap: () => setState(() => _showCompleted = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: dataAsync.when(
              data: (medications) {
                if (medications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _showCompleted
                              ? Icons.check_circle_outline
                              : Icons.archive_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showCompleted
                              ? 'Нет завершённых лекарств'
                              : 'Нет архивных лекарств',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final med = medications[index];
                    return ArchiveCard(
                      medication: med,
                      isCompleted: _showCompleted,
                      onRestore: () =>
                          _restore(ref, med.id, _showCompleted),
                      onDelete: () => _delete(ref, med.id),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _restore(WidgetRef ref, int id, bool isCompleted) async {
    final dao = ref.read(medicationsDaoProvider);
    if (isCompleted) {
      await dao.uncomplete(id);
    } else {
      await dao.unarchive(id);
    }
    ref.invalidate(archivedMedicationsProvider);
    ref.invalidate(completedMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    await ref.read(medicationsDaoProvider).deleteMedication(id);
    ref.invalidate(archivedMedicationsProvider);
    ref.invalidate(completedMedicationsProvider);
  }
}
