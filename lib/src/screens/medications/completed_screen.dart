import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/screens/medications/widgets/completed_card.dart';

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
                  Icon(Icons.check_circle_outline,
                      size: 64, color: Colors.grey[400]),
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
              return CompletedCard(
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
    final dao = ref.read(medicationsDaoProvider);
    await dao.uncomplete(id);
    ref.invalidate(completedMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
  }
}
