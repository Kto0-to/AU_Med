import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/services/notification_service.dart';

class AllMedicationsScreen extends ConsumerStatefulWidget {
  const AllMedicationsScreen({super.key});

  @override
  ConsumerState<AllMedicationsScreen> createState() => _AllMedicationsScreenState();
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
                        .where((m) =>
                            m.name.toLowerCase().contains(_searchQuery.toLowerCase()))
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
                    return _MedicationListCard(
                      medication: med,
                      onTap: () => showDialog(
                        context: context,
                        builder: (ctx) => _MedicationDetailDialog(
                          medication: med,
                          onTake: () => _takeMedication(med),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final existingLogs = await dao.getForMedicationOnDate(medication.id, today);
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

class _MedicationListCard extends StatelessWidget {
  final MedicationsTableData medication;
  final VoidCallback onTap;
  final VoidCallback onTake;
  final VoidCallback onArchive;
  final VoidCallback onComplete;

  const _MedicationListCard({
    required this.medication,
    required this.onTap,
    required this.onTake,
    required this.onArchive,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final medColor = Color(medication.color);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: medColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  MedicationIcons.fromCodePoint(medication.icon),
                  color: medColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (medication.isCompleted) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.appColors.successBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'ЗАВЕРШЕНО',
                            style: TextStyle(
                              color: context.appColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    const SizedBox(height: 4),
                    Text(
                      '${medication.dosageValue} ${medication.dosageUnit}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    if (medication.times.isNotEmpty)
                      Text(
                        'Время: ${medication.times}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    if (medication.remainingPills != null)
                      Text(
                        'Остаток: ${medication.remainingPills}',
                        style: TextStyle(
                          color: medication.remainingPills! <= 5
                              ? Colors.red
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _MedicationDetailDialog extends StatelessWidget {
  final MedicationsTableData medication;
  final VoidCallback? onTake;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final VoidCallback onComplete;
  final VoidCallback onRestore;

  const _MedicationDetailDialog({
    required this.medication,
    this.onTake,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medColor = Color(medication.color);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  MedicationIcons.fromCodePoint(medication.icon),
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
                      medication.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${medication.dosageValue} ${medication.dosageUnit}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (medication.notes != null && medication.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              medication.notes!,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (medication.startDate.isNotEmpty) ...[
            Row(
              children: [
                Icon(Bootstrap.calendar, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Начало: ${DateFormat('d MMM yyyy', 'ru').format(DateTime.parse(medication.startDate))}',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
          if (medication.endDate != null && medication.endDate!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Bootstrap.calendar_date, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Окончание: ${DateFormat('d MMM yyyy', 'ru').format(DateTime.parse(medication.endDate!))}',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
          if (medication.remainingPills != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Bootstrap.box, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Остаток: ${medication.remainingPills}',
                  style: TextStyle(
                    fontSize: 13,
                    color: medication.remainingPills! <= 5
                        ? Colors.red
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          if (medication.times.isEmpty && onTake != null) ...[
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: onTake,
                icon: const Icon(FontAwesome.circle_check, size: 20),
                label: const Text('Принять'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DialogIconButton(
                icon: FontAwesome.pen_to_square,
                tooltip: 'Изменить',
                onTap: onEdit,
              ),
              _DialogIconButton(
                icon: Bootstrap.archive,
                tooltip: 'Архив',
                onTap: onArchive,
              ),
              medication.isCompleted
                  ? _DialogIconButton(
                      icon: IonIcons.arrow_redo,
                      tooltip: 'Возобновить',
                      onTap: onRestore,
                    )
                  : _DialogIconButton(
                      icon: FontAwesome.circle_check,
                      tooltip: 'Завершить',
                      onTap: onComplete,
                    ),
              _DialogIconButton(
                icon: FontAwesome.trash_can,
                tooltip: 'Удалить',
                onTap: onDelete,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _DialogIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  const _DialogIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnColor = color ?? theme.colorScheme.onSurfaceVariant;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: btnColor.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: btnColor, size: 22),
        ),
      ),
    );
  }
}
