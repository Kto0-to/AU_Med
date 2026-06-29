import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';

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
                _FilterChip(
                  label: 'Архивные',
                  isSelected: !_showCompleted,
                  onTap: () => setState(() => _showCompleted = false),
                ),
                const SizedBox(width: 8),
                _FilterChip(
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
                          _showCompleted ? FontAwesome.circle_check : Bootstrap.archive,
                          size: 64, color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showCompleted ? 'Нет завершённых лекарств' : 'Нет архивных лекарств',
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
                    return _ArchiveCard(
                      medication: med,
                      isCompleted: _showCompleted,
                      onRestore: () => _restore(ref, med.id, _showCompleted),
                      onDelete: () => _delete(ref, med.id),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
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
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final MedicationsTableData medication;
  final bool isCompleted;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _ArchiveCard({
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
                  Text('${medication.dosageValue} ${medication.dosageUnit}',
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            IconButton(icon: const Icon(Bootstrap.archive_fill), onPressed: onRestore),
            IconButton(
                icon: const Icon(FontAwesome.trash_can),
                onPressed: onDelete,
                color: Colors.red),
          ],
        ),
      ),
    );
  }
}