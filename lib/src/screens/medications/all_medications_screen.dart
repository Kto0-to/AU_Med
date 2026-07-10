import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/services/notification_service.dart';
import 'package:au_med/src/screens/medications/widgets/medication_list_card.dart';
import 'package:au_med/src/widgets/medication_detail_dialog.dart';

class AllMedicationsScreen extends ConsumerStatefulWidget {
  const AllMedicationsScreen({super.key});

  @override
  ConsumerState<AllMedicationsScreen> createState() =>
      _AllMedicationsScreenState();
}

class _AllMedicationsScreenState extends ConsumerState<AllMedicationsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicationsAsync = ref.watch(allMedicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Все лекарства'),
        actions: [
          IconButton(
            icon: const Icon(Bootstrap.archive),
            onPressed: () => context.push('/archive'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск лекарств...',
                prefixIcon: const Icon(Bootstrap.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Bootstrap.x, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: medicationsAsync.when(
              data: (medications) {
                final filtered = _searchQuery.isEmpty
                    ? medications
                    : medications
                        .where((m) => m.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Bootstrap.capsule_pill,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Нет лекарств'
                              : 'Лекарства не найдены',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final med = filtered[index];
                    return MedicationListCard(
                      medication: med,
                      onTap: () => showDialog(
                        context: context,
                        builder: (ctx) => MedicationDetailDialog(
                          medication: med,
                          onTake: () {
                            Navigator.pop(ctx);
                            _takeMedication(med);
                          },
                          onEdit: () {
                            Navigator.pop(ctx);
                            context.push('/medications/${med.id}/edit');
                          },
                          onDelete: () async {
                            Navigator.pop(ctx);
                            final dao = ref.read(medicationsDaoProvider);
                            await dao.deleteMedication(med.id);
                            ref.invalidate(allMedicationsProvider);
                            ref.invalidate(activeMedicationsProvider);
                          },
                          onArchive: () async {
                            Navigator.pop(ctx);
                            final dao = ref.read(medicationsDaoProvider);
                            await dao.archive(med.id);
                            ref.invalidate(allMedicationsProvider);
                            ref.invalidate(activeMedicationsProvider);
                          },
                          onComplete: () async {
                            Navigator.pop(ctx);
                            final dao = ref.read(medicationsDaoProvider);
                            await dao.markCompleted(med.id);
                            ref.invalidate(allMedicationsProvider);
                            ref.invalidate(activeMedicationsProvider);
                          },
                          onRestore: () async {
                            Navigator.pop(ctx);
                            final dao = ref.read(medicationsDaoProvider);
                            await dao.uncomplete(med.id);
                            ref.invalidate(allMedicationsProvider);
                            ref.invalidate(activeMedicationsProvider);
                          },
                        ),
                      ),
                      onTake: () => _takeMedication(med),
                      onArchive: () => _archiveMedication(med.id),
                      onComplete: () => _completeMedication(med.id),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/medications/add'),
        child: const Icon(Bootstrap.plus_lg),
      ),
    );
  }

  Future<void> _takeMedication(MedicationsTableData medication) async {
    final dao = ref.read(logsDaoProvider);
    final medsDao = ref.read(medicationsDaoProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final existingLogs =
        await dao.getForMedicationOnDate(medication.id, today);
    final alreadyTaken = existingLogs.any((l) => l.status == 'taken');
    if (existingLogs.isNotEmpty) {
      await dao.markTaken(existingLogs.first.id, now);
    } else {
      final scheduledTime = now.toIso8601String();
      await dao.insert(MedicationLogsTableCompanion(
        medicationId: Value(medication.id),
        scheduledTime: Value(scheduledTime),
        status: const Value('taken'),
        takenTime: Value(now.toIso8601String()),
        createdAt: Value(now.toIso8601String()),
      ));
    }
    if (!alreadyTaken) {
      await medsDao.adjustRemainingPills(medication.id, -1);
    }
    await NotificationService().cancelMedicationReminders(medication.id);
    ref.invalidate(allMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
    ref.invalidate(logsForDateProvider(today));
    ref.invalidate(todayPrnTakenProvider);
    ref.invalidate(streakDaysProvider);
    ref.invalidate(dailyLogsProvider);
    ref.invalidate(missedDaysProvider);
    ref.invalidate(pendingDaysProvider);
    ref.invalidate(weeklyAdherenceProvider);
    ref.invalidate(monthlyAdherenceProvider);
    ref.invalidate(statusDistributionProvider);
  }

  Future<void> _archiveMedication(int id) async {
    final dao = ref.read(medicationsDaoProvider);
    await dao.archive(id);
    ref.invalidate(allMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
  }

  Future<void> _completeMedication(int id) async {
    final dao = ref.read(medicationsDaoProvider);
    await dao.markCompleted(id);
    ref.invalidate(allMedicationsProvider);
    ref.invalidate(activeMedicationsProvider);
  }
}
