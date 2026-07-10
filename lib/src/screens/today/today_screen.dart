import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';

import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/database/database.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show LucideIcons;
import 'package:au_med/src/services/notification_service.dart';
import 'package:au_med/src/screens/today/widgets/date_navigation.dart';
import 'package:au_med/src/screens/today/widgets/week_calendar.dart';
import 'package:au_med/src/screens/today/widgets/progress_summary.dart';
import 'package:au_med/src/screens/today/widgets/medication_timeline.dart';
import 'package:au_med/src/screens/today/widgets/prn_section.dart';

bool _timeMatches(String scheduledTime, String timeString) {
  return scheduledTime.contains(timeString);
}

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  DateTime _selectedDate = DateTime.now();
  String _autoMarkKey = '';

  DateTime get _normalizedDate =>
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

  bool get _isToday {
    final now = DateTime.now();
    return _normalizedDate == DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final controller = FDateSelectionController.single();
    controller.value = _normalizedDate;

    final date = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: FTheme(
          data: (Theme.of(ctx).brightness == Brightness.dark
              ? FThemes.zinc.dark
              : FThemes.zinc.light
          ).desktop,
          child: SizedBox(
            width: 320,
            child: FCalendar.grid(
              selectionControl: FDateSelectionControl.managedSingle(
                controller: controller,
              ),
              onDayPress: (d) => Navigator.pop(ctx, d),
            ),
          ),
        ),
      ),
    );
    controller.dispose();
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  List<
    ({
      MedicationsTableData medication,
      String? time,
      MedicationLogsTableData? log,
    })
  >
  _buildSlots(
    List<MedicationsTableData> medications,
    List<MedicationLogsTableData> logs,
  ) {
    return medications
        .where((med) {
          if (med.startDate.isEmpty) return true;
          final startStr = med.startDate.length >= 10
              ? med.startDate.substring(0, 10)
              : med.startDate;
          final start = DateTime.tryParse(startStr);
          if (start == null) return true;
          final day = DateTime(
            _normalizedDate.year,
            _normalizedDate.month,
            _normalizedDate.day,
          );
          return !day.isBefore(start);
        })
        .expand<
          ({
            MedicationsTableData medication,
            String? time,
            MedicationLogsTableData? log,
          })
        >((med) {
          final times = med.times
              .split(',')
              .where((t) => t.isNotEmpty)
              .toList();
          if (times.isEmpty) {
            return <
              ({
                MedicationsTableData medication,
                String? time,
                MedicationLogsTableData? log,
              })
            >[];
          }
          return times.map((time) {
            final log = logs
                .where(
                  (l) =>
                      l.medicationId == med.id &&
                      _timeMatches(l.scheduledTime, time),
                )
                .firstOrNull;
            return (medication: med, time: time, log: log);
          });
        })
        .toList()
      ..sort((a, b) {
        final aTime = a.time ?? '';
        final bTime = b.time ?? '';
        return aTime.compareTo(bTime);
      });
  }

  @override
  Widget build(BuildContext context) {
    final medicationsAsync = ref.watch(activeMedicationsProvider);
    final logsAsync = ref.watch(logsForDateProvider(_normalizedDate));
    final streakAsync = ref.watch(streakDaysUpToProvider(_normalizedDate));
    final weekHeatmapAsync = ref.watch(weekHeatmapProvider(_normalizedDate));

    final dateKey = _normalizedDate.toIso8601String().substring(0, 10);
    if (_autoMarkKey != dateKey) {
      _autoMarkKey = dateKey;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final dao = ref.read(logsDaoProvider);
        final meds = await ref.read(activeMedicationsProvider.future);
        await dao.autoMarkMissedForDate(meds, _normalizedDate);
        ref.invalidate(logsForDateProvider(_normalizedDate));
        ref.invalidate(streakDaysUpToProvider(_normalizedDate));
        ref.invalidate(weekHeatmapProvider(_normalizedDate));
        ref.invalidate(heatmapDataProvider);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Сегодня',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (!_isToday)
            IconButton(
              icon: const Icon(LucideIcons.calendarDays),
              tooltip: 'Сегодня',
              onPressed: () => setState(() => _selectedDate = DateTime.now()),
            ),
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => context.push('/medications/add'),
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            setState(
              () => _selectedDate = _selectedDate.add(const Duration(days: 1)),
            );
          } else if (details.primaryVelocity! > 0) {
            setState(
              () => _selectedDate = _selectedDate.subtract(
                const Duration(days: 1),
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(activeMedicationsProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DateNavigation(
                selectedDate: _normalizedDate,
                isToday: _isToday,
                onBack: () => setState(
                  () => _selectedDate = _selectedDate.subtract(
                    const Duration(days: 1),
                  ),
                ),
                onForward: () => setState(
                  () => _selectedDate = _selectedDate.add(
                    const Duration(days: 1),
                  ),
                ),
                onTapDate: _pickDate,
              ),
              medicationsAsync.when(
                data: (medications) => logsAsync.when(
                  data: (logs) {
                    final scheduled = medications
                        .where(
                          (m) => m.times
                              .split(',')
                              .where((t) => t.isNotEmpty)
                              .isNotEmpty,
                        )
                        .toList();
                    final prn = medications
                        .where(
                          (m) => m.times
                              .split(',')
                              .where((t) => t.isNotEmpty)
                              .isEmpty,
                        )
                        .toList();
                    final slots = _buildSlots(scheduled, logs);
                    final now = DateTime.now();
                    int taken = 0, skipped = 0, missed = 0, pending = 0;
                    for (final slot in slots) {
                      final status = slot.log?.status;
                      if (status == 'taken') {
                        taken++;
                      } else if (status == 'skipped') {
                        skipped++;
                      } else if (status == 'missed') {
                        missed++;
                      } else if (status == 'scheduled') {
                        if (slot.time != null && _isToday) {
                          final parts = slot.time!.split(':');
                          final slotTime = DateTime(
                            _normalizedDate.year,
                            _normalizedDate.month,
                            _normalizedDate.day,
                            int.parse(parts[0]),
                            int.parse(parts[1]),
                          );
                          if (slotTime.isAfter(now)) {
                            pending++;
                          } else {
                            missed++;
                          }
                        } else if (slot.time != null) {
                          missed++;
                        } else {
                          pending++;
                        }
                      } else {
                        pending++;
                      }
                    }
                    int prnTaken = 0;
                    for (final med in prn) {
                      prnTaken += logs
                          .where(
                            (l) =>
                                l.medicationId == med.id && l.status == 'taken',
                          )
                          .length;
                    }
                    final total = slots.length;
                    return ProgressSummary(
                      taken: taken,
                      skipped: skipped,
                      missed: missed,
                      pending: pending,
                      total: total,
                      prnTaken: prnTaken,
                      date: _normalizedDate,
                      streak: streakAsync.value ?? 0,
                    );
                  },
                  loading: () => ProgressSummary(
                    taken: 0,
                    skipped: 0,
                    missed: 0,
                    pending: 0,
                    total: 0,
                    prnTaken: 0,
                    date: _normalizedDate,
                    streak: streakAsync.value ?? 0,
                  ),
                  error: (_, _) => ProgressSummary(
                    taken: 0,
                    skipped: 0,
                    missed: 0,
                    pending: 0,
                    total: 0,
                    prnTaken: 0,
                    date: _normalizedDate,
                    streak: streakAsync.value ?? 0,
                  ),
                ),
                loading: () => ProgressSummary(
                  taken: 0,
                  skipped: 0,
                  missed: 0,
                  pending: 0,
                  total: 0,
                  prnTaken: 0,
                  date: _normalizedDate,
                  streak: streakAsync.value ?? 0,
                ),
                error: (_, _) => ProgressSummary(
                  taken: 0,
                  skipped: 0,
                  missed: 0,
                  pending: 0,
                  total: 0,
                  prnTaken: 0,
                  date: _normalizedDate,
                  streak: streakAsync.value ?? 0,
                ),
              ),
              const SizedBox(height: 10),
              weekHeatmapAsync.when(
                data: (data) => WeekCalendar(
                  selectedDate: _normalizedDate,
                  heatmapData: data,
                  onSelectDate: (date) => setState(() => _selectedDate = date),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              medicationsAsync.when(
                data: (medications) {
                  if (medications.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return logsAsync.when(
                    data: (logs) {
                      final scheduled = medications
                          .where(
                            (m) => m.times
                                .split(',')
                                .where((t) => t.isNotEmpty)
                                .isNotEmpty,
                          )
                          .toList();
                      final prn = medications
                          .where(
                            (m) => m.times
                                .split(',')
                                .where((t) => t.isNotEmpty)
                                .isEmpty,
                          )
                          .toList();
                      final slots = _buildSlots(scheduled, logs);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MedicationTimeline(
                            slots: slots,
                            isToday: _isToday,
                            selectedDate: _normalizedDate,
                            onMarkTaken: (medicationId, time) async {
                              final dao = ref.read(logsDaoProvider);
                              final medsDao = ref.read(medicationsDaoProvider);
                              final now = DateTime.now();
                              final existingLogs = await dao
                                  .getForMedicationOnDate(
                                    medicationId,
                                    _normalizedDate,
                                  );
                              final log = existingLogs
                                  .where(
                                    (l) =>
                                        time == null ||
                                        _timeMatches(l.scheduledTime, time),
                                  )
                                  .firstOrNull;
                              final wasTaken = log?.status == 'taken';
                              if (log != null) {
                                if (wasTaken) {
                                  await dao.updateLog(
                                    log.id,
                                    MedicationLogsTableCompanion(
                                      status: const Value('scheduled'),
                                      takenTime: const Value(null),
                                    ),
                                  );
                                  await medsDao.adjustRemainingPills(
                                    medicationId,
                                    1,
                                  );
                                } else {
                                  await dao.markTaken(log.id, now);
                                  await medsDao.adjustRemainingPills(
                                    medicationId,
                                    -1,
                                  );
                                }
                              } else {
                                final scheduledTime = time != null
                                    ? '${_normalizedDate.toIso8601String().split('T').first}T$time:00'
                                    : now.toIso8601String();
                                await dao.insert(
                                  MedicationLogsTableCompanion(
                                    medicationId: Value(medicationId),
                                    scheduledTime: Value(scheduledTime),
                                    status: const Value('taken'),
                                    takenTime: Value(now.toIso8601String()),
                                    createdAt: Value(now.toIso8601String()),
                                  ),
                                );
                                await medsDao.adjustRemainingPills(
                                  medicationId,
                                  -1,
                                );
                              }
                              await NotificationService()
                                  .cancelMedicationReminders(medicationId);
                              ref.invalidate(
                                logsForDateProvider(_normalizedDate),
                              );
                              ref.invalidate(
                                  streakDaysUpToProvider(_normalizedDate));
                              ref.invalidate(
                                  weekHeatmapProvider(_normalizedDate));
                              ref.invalidate(weeklyAdherenceProvider);
                              ref.invalidate(monthlyAdherenceProvider);
                              ref.invalidate(statusDistributionProvider);
                              ref.invalidate(heatmapDataProvider);
                            },
                            onEdit: (medication) => context.push(
                              '/medications/${medication.id}/edit',
                            ),
                            onDelete: (medication) async {
                              final dao = ref.read(medicationsDaoProvider);
                              await dao.deleteMedication(medication.id);
                              ref.invalidate(activeMedicationsProvider);
                              ref.invalidate(allMedicationsProvider);
                            },
                            onArchive: (medication) async {
                              final dao = ref.read(medicationsDaoProvider);
                              await dao.archive(medication.id);
                              ref.invalidate(activeMedicationsProvider);
                              ref.invalidate(allMedicationsProvider);
                            },
                            onComplete: (medication) async {
                              final dao = ref.read(medicationsDaoProvider);
                              await dao.markCompleted(medication.id);
                              ref.invalidate(activeMedicationsProvider);
                              ref.invalidate(allMedicationsProvider);
                            },
                            onRestore: (medication) async {
                              final dao = ref.read(medicationsDaoProvider);
                              await dao.uncomplete(medication.id);
                              ref.invalidate(activeMedicationsProvider);
                              ref.invalidate(allMedicationsProvider);
                            },
                          ),
                          if (prn.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            PrnSection(
                              prn: prn,
                              logs: logs,
                              isToday: _isToday,
                              selectedDate: _normalizedDate,
                              onCancelTake: (medicationId) async {
                                final dao = ref.read(logsDaoProvider);
                                final medsDao =
                                    ref.read(medicationsDaoProvider);
                                final logs = await dao.getForMedicationOnDate(
                                  medicationId,
                                  _normalizedDate,
                                );
                                final takenLogs =
                                    logs
                                        .where((l) => l.status == 'taken')
                                        .toList()
                                      ..sort(
                                        (a, b) => b.scheduledTime.compareTo(
                                          a.scheduledTime,
                                        ),
                                      );
                                if (takenLogs.isNotEmpty) {
                                  await dao.deleteLog(takenLogs.first.id);
                                  await medsDao.adjustRemainingPills(
                                    medicationId,
                                    1,
                                  );
                                }
                                ref.invalidate(
                                  logsForDateProvider(_normalizedDate),
                                );
                                ref.invalidate(
                                    streakDaysUpToProvider(_normalizedDate));
                                ref.invalidate(
                                    weekHeatmapProvider(_normalizedDate));
                                ref.invalidate(weeklyAdherenceProvider);
                                ref.invalidate(monthlyAdherenceProvider);
                                ref.invalidate(statusDistributionProvider);
                                ref.invalidate(todayPrnTakenProvider);
                              },
                              onEdit: (medication) => context.push(
                                '/medications/${medication.id}/edit',
                              ),
                              onDelete: (medication) async {
                                final dao = ref.read(medicationsDaoProvider);
                                await dao.deleteMedication(medication.id);
                                ref.invalidate(activeMedicationsProvider);
                                ref.invalidate(allMedicationsProvider);
                              },
                              onArchive: (medication) async {
                                final dao = ref.read(medicationsDaoProvider);
                                await dao.archive(medication.id);
                                ref.invalidate(activeMedicationsProvider);
                                ref.invalidate(allMedicationsProvider);
                              },
                              onComplete: (medication) async {
                                final dao = ref.read(medicationsDaoProvider);
                                await dao.markCompleted(medication.id);
                                ref.invalidate(activeMedicationsProvider);
                                ref.invalidate(allMedicationsProvider);
                              },
                              onRestore: (medication) async {
                                final dao = ref.read(medicationsDaoProvider);
                                await dao.uncomplete(medication.id);
                                ref.invalidate(activeMedicationsProvider);
                                ref.invalidate(allMedicationsProvider);
                              },
                              onMarkTaken: (medicationId) async {
                                final dao = ref.read(logsDaoProvider);
                                final medsDao =
                                    ref.read(medicationsDaoProvider);
                                final now = DateTime.now();
                                final scheduledTime = DateTime(
                                  _normalizedDate.year,
                                  _normalizedDate.month,
                                  _normalizedDate.day,
                                  now.hour,
                                  now.minute,
                                  now.second,
                                );
                                await dao.insert(
                                  MedicationLogsTableCompanion(
                                    medicationId: Value(medicationId),
                                    scheduledTime: Value(
                                      scheduledTime.toIso8601String(),
                                    ),
                                    status: const Value('taken'),
                                    takenTime: Value(now.toIso8601String()),
                                    createdAt: Value(now.toIso8601String()),
                                  ),
                                );
                                await medsDao.adjustRemainingPills(
                                  medicationId,
                                  -1,
                                );
                                await NotificationService()
                                    .cancelMedicationReminders(medicationId);
                                ref.invalidate(
                                  logsForDateProvider(_normalizedDate),
                                );
                                ref.invalidate(
                                    streakDaysUpToProvider(_normalizedDate));
                                ref.invalidate(
                                    weekHeatmapProvider(_normalizedDate));
                                ref.invalidate(weeklyAdherenceProvider);
                                ref.invalidate(monthlyAdherenceProvider);
                                ref.invalidate(statusDistributionProvider);
                                ref.invalidate(todayPrnTakenProvider);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Ошибка: $e')),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
