import 'dart:math' as math;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:forui/forui.dart';

import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/providers/statistics_provider.dart';
import 'package:au_med/src/shared/day_status.dart';
import 'package:au_med/src/shared/dosage_format.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/theme/app_color_tokens.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/services/notification_service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show LucideIcons;

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
              _DateNavigation(
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
                    return _ProgressSummary(
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
                  loading: () => _ProgressSummary(
                    taken: 0,
                    skipped: 0,
                    missed: 0,
                    pending: 0,
                    total: 0,
                    prnTaken: 0,
                    date: _normalizedDate,
                    streak: streakAsync.value ?? 0,
                  ),
                  error: (_, _) => _ProgressSummary(
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
                loading: () => _ProgressSummary(
                  taken: 0,
                  skipped: 0,
                  missed: 0,
                  pending: 0,
                  total: 0,
                  prnTaken: 0,
                  date: _normalizedDate,
                  streak: streakAsync.value ?? 0,
                ),
                error: (_, _) => _ProgressSummary(
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
                data: (data) => _WeekCalendar(
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
                    return _EmptyState();
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
                          _MedicationTimeline(
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
                              ref.invalidate(streakDaysUpToProvider(_normalizedDate));
                              ref.invalidate(weekHeatmapProvider(_normalizedDate));
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
                            _PrnSection(
                              prn: prn,
                              logs: logs,
                              isToday: _isToday,
                              selectedDate: _normalizedDate,
                              onCancelTake: (medicationId) async {
                                final dao = ref.read(logsDaoProvider);
                                final medsDao = ref.read(medicationsDaoProvider);
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
                                ref.invalidate(streakDaysUpToProvider(_normalizedDate));
                                ref.invalidate(weekHeatmapProvider(_normalizedDate));
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
                                final medsDao = ref.read(medicationsDaoProvider);
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
                                ref.invalidate(streakDaysUpToProvider(_normalizedDate));
                                ref.invalidate(weekHeatmapProvider(_normalizedDate));
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final bool isToday;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onTapDate;

  const _DateNavigation({
    required this.selectedDate,
    required this.isToday,
    required this.onBack,
    required this.onForward,
    required this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft),
              onPressed: onBack,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapDate,
                child: Text(
                  DateFormat('d MMMM yyyy', 'ru').format(selectedDate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.chevronRight),
              onPressed: isToday ? null : onForward,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final List<HeatmapDayData> heatmapData;
  final ValueChanged<DateTime> onSelectDate;

  const _WeekCalendar({
    required this.selectedDate,
    required this.heatmapData,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final weekStart = selectedDate.subtract(
      Duration(days: (selectedDate.weekday - DateTime.monday) % 7),
    );
    final weekdayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    final dayMap = <DateTime, HeatmapDayData>{};
    for (final d in heatmapData) {
      dayMap[DateTime(d.date.year, d.date.month, d.date.day)] = d;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final day = weekStart.add(Duration(days: i));
            final isSelected = day == selectedDate;
            final dayData = dayMap[day];

            Color indicatorColor;
            bool hasColor = false;

            if (dayData != null) {
              switch (dayData.status) {
                case DayStatus.completed:
                  indicatorColor = colors.success.withAlpha(180);
                  hasColor = true;
                case DayStatus.partial:
                  indicatorColor = colors.warning.withAlpha(180);
                  hasColor = true;
                case DayStatus.missed:
                  indicatorColor = colors.error.withAlpha(180);
                  hasColor = true;
                case DayStatus.empty:
                case DayStatus.future:
                  indicatorColor = Colors.transparent;
              }
            } else {
              indicatorColor = Colors.transparent;
            }

            return GestureDetector(
              onTap: () => onSelectDate(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.primary.withAlpha(100),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      weekdayNames[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: Stack(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: hasColor ? indicatorColor : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (dayData?.hasPrn == true)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.info,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DayProgressPainter extends CustomPainter {
  final int taken;
  final int skipped;
  final int missed;
  final int pending;
  final Color takenColor;
  final Color skippedColor;
  final Color missedColor;

  _DayProgressPainter({
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.pending,
    required this.takenColor,
    required this.skippedColor,
    required this.missedColor,
  });

  int get _total => taken + skipped + missed + pending;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2 - 6);

    if (_total == 0) {
      final paint = Paint()
        ..color = Colors.grey.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    const gapAngle = 0.04;
    final totalArc = 2 * math.pi - gapAngle * 4;
    double startAngle = -math.pi / 2;

    void drawArc(int count, Color color) {
      if (count == 0) return;
      final sweep = totalArc * count / _total - gapAngle;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gapAngle / 2,
        sweep,
        false,
        paint,
      );
      startAngle += gapAngle + sweep + gapAngle;
    }
    drawArc(taken, takenColor);
    drawArc(skipped, skippedColor);
    drawArc(missed, missedColor);
    drawArc(pending, Colors.grey);
  }

  @override
  bool shouldRepaint(covariant _DayProgressPainter old) =>
      taken != old.taken ||
      skipped != old.skipped ||
      missed != old.missed ||
      pending != old.pending ||
      takenColor != old.takenColor ||
      skippedColor != old.skippedColor ||
      missedColor != old.missedColor;
}

class _ProgressSummary extends StatelessWidget {
  final int taken;
  final int skipped;
  final int missed;
  final int pending;
  final int total;
  final int prnTaken;
  final DateTime date;
  final int streak;

  const _ProgressSummary({
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.pending,
    required this.total,
    required this.prnTaken,
    required this.date,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday =
        DateTime(date.year, date.month, date.day) ==
        DateTime(now.year, now.month, now.day);

    String dayLabel(int n) {
      if (n % 10 == 1 && n % 100 != 11) return 'день';
      if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) return 'дня';
      return 'дней';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$taken/$total",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isToday
                        ? 'принято сегодня'
                        : "принято ${DateFormat('d MMM', 'ru').format(date)}",
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  if (prnTaken > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.squareCheck,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'По надобности: $prnTaken',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: _DayProgressPainter(
                  taken: taken,
                  skipped: skipped,
                  missed: missed,
                  pending: pending,
                  takenColor: context.appColors.success,
                  skippedColor: context.appColors.warning,
                  missedColor: context.appColors.error,
                ),
                child: Center(
                  child: Text(
                    total > 0 ? '${(taken * 100 ~/ total)}%' : '0%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: total == 0 ? Colors.grey : context.appColors.success,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 26),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.flame,
                      color: streak > 0 ? Colors.orange : Colors.grey,
                      size: 38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: streak > 0 ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  dayLabel(streak),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(Bootstrap.capsule_pill, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет лекарств',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первое лекарство для отслеживания',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationTimeline extends StatelessWidget {
  final List<
    ({
      MedicationsTableData medication,
      String? time,
      MedicationLogsTableData? log,
    })
  >
  slots;
  final bool isToday;
  final DateTime selectedDate;
  final Function(int medicationId, String? time) onMarkTaken;
  final Function(MedicationsTableData medication) onEdit;
  final Function(MedicationsTableData medication) onDelete;
  final Function(MedicationsTableData medication) onArchive;
  final Function(MedicationsTableData medication) onComplete;
  final Function(MedicationsTableData medication) onRestore;

  const _MedicationTimeline({
    required this.slots,
    required this.isToday,
    required this.selectedDate,
    required this.onMarkTaken,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return _EmptyState();
    }

    final theme = Theme.of(context);
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          isToday
              ? 'Расписание на сегодня'
              : "Расписание на ${DateFormat('d MMMM', 'ru').format(selectedDate)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    ];

    for (final slot in slots) {
      final isTaken = slot.log?.status == 'taken';
      children.add(
        _MedicationTimeSlot(
          medication: slot.medication,
          time: slot.time,
          log: slot.log,
          isToday: isToday,
          selectedDate: selectedDate,
          onMarkTaken: () => onMarkTaken(slot.medication.id, slot.time),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => _MedicationDetailDialog(
                medication: slot.medication,
                time: slot.time,
                isTaken: isTaken,
                onTake: () {
                  Navigator.pop(context);
                  onMarkTaken(slot.medication.id, slot.time);
                },
                onEdit: () {
                  Navigator.pop(context);
                  onEdit(slot.medication);
                },
                onDelete: () {
                  Navigator.pop(context);
                  onDelete(slot.medication);
                },
                onArchive: () {
                  Navigator.pop(context);
                  onArchive(slot.medication);
                },
                onComplete: () {
                  Navigator.pop(context);
                  onComplete(slot.medication);
                },
                onRestore: () {
                  Navigator.pop(context);
                  onRestore(slot.medication);
                },
              ),
            );
          },
        ),
      );
      children.add(const SizedBox(height: 8));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _PrnSection extends StatelessWidget {
  final List<MedicationsTableData> prn;
  final List<MedicationLogsTableData> logs;
  final bool isToday;
  final DateTime selectedDate;
  final Function(int medicationId) onMarkTaken;
  final Function(int medicationId) onCancelTake;
  final Function(MedicationsTableData medication) onEdit;
  final Function(MedicationsTableData medication) onDelete;
  final Function(MedicationsTableData medication) onArchive;
  final Function(MedicationsTableData medication) onComplete;
  final Function(MedicationsTableData medication) onRestore;

  const _PrnSection({
    required this.prn,
    required this.logs,
    required this.isToday,
    required this.selectedDate,
    required this.onMarkTaken,
    required this.onCancelTake,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'По требованию',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        ...prn.map((med) {
          final medLogs = logs.where((l) => l.medicationId == med.id).toList();
          final takenCount = medLogs.where((l) => l.status == 'taken').length;
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => _MedicationDetailDialog(
                  medication: med,
                  isTaken: takenCount > 0,
                  onTake: () {
                    Navigator.pop(ctx);
                    onMarkTaken(med.id);
                  },
                  onCancelTake: () {
                    Navigator.pop(ctx);
                    onCancelTake(med.id);
                  },
                  onEdit: () {
                    Navigator.pop(ctx);
                    onEdit(med);
                  },
                  onDelete: () {
                    Navigator.pop(ctx);
                    onDelete(med);
                  },
                  onArchive: () {
                    Navigator.pop(ctx);
                    onArchive(med);
                  },
                  onComplete: () {
                    Navigator.pop(ctx);
                    onComplete(med);
                  },
                  onRestore: () {
                    Navigator.pop(ctx);
                    onRestore(med);
                  },
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(med.color).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        MedicationIcons.fromCodePoint(med.icon),
                        color: Color(med.color),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatDosage(med.dosageValue, med.dosageUnit),
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (med.remainingPills != null)
                            Text(
                              'Остаток: ${med.remainingPills}',
                              style: TextStyle(
                                color: med.remainingPills! <= 5
                                    ? Colors.red
                                    : theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (takenCount > 0)
                      Chip(
                        avatar: Icon(
                          FontAwesome.circle_check,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          takenCount > 1 ? 'Принято x$takenCount' : 'Принято',
                          style: const TextStyle(fontSize: 12),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.only(right: 4),
                        backgroundColor: theme.colorScheme.primary.withAlpha(
                          25,
                        ),
                        side: BorderSide.none,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _MedicationTimeSlot extends StatelessWidget {
  final MedicationsTableData medication;
  final String? time;
  final MedicationLogsTableData? log;
  final bool isToday;
  final DateTime selectedDate;
  final VoidCallback? onMarkTaken;
  final VoidCallback? onTap;

  const _MedicationTimeSlot({
    required this.medication,
    this.time,
    this.log,
    required this.isToday,
    required this.selectedDate,
    this.onMarkTaken,
    this.onTap,
  });

  bool _isPast() {
    if (log?.status == 'taken') return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (selectedDay.isAfter(today)) return false;
    if (selectedDay.isBefore(today)) return true;
    if (time == null) return false;
    final parts = time!.split(':');
    final slotTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    return slotTime.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medColor = Color(medication.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: medColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  MedicationIcons.fromCodePoint(medication.icon),
                  color: medColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDosage(medication.dosageValue, medication.dosageUnit),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
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
                    if (time != null)
                      Text(
                        time!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      )
                    else
                      Text(
                        'По необходимости',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              _StatusChip(log: log, isPast: _isPast()),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final MedicationLogsTableData? log;
  final bool isPast;

  const _StatusChip({required this.log, required this.isPast});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    if (log?.status == 'taken') {
      bgColor = context.appColors.successBg;
      textColor = context.appColors.success;
      label = 'Принято';
    } else if (isPast || log?.status == 'missed') {
      bgColor = context.appColors.errorBg;
      textColor = context.appColors.error;
      label = 'Пропущено';
    } else {
      bgColor = Colors.grey.withAlpha(20);
      textColor = Colors.grey;
      label = 'Ожидает';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MedicationDetailDialog extends StatefulWidget {
  final MedicationsTableData medication;
  final String? time;
  final bool isTaken;
  final VoidCallback onTake;
  final VoidCallback? onCancelTake;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final VoidCallback onComplete;
  final VoidCallback onRestore;

  const _MedicationDetailDialog({
    required this.medication,
    this.time,
    required this.isTaken,
    required this.onTake,
    this.onCancelTake,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    required this.onComplete,
    required this.onRestore,
  });

  @override
  State<_MedicationDetailDialog> createState() =>
      _MedicationDetailDialogState();
}

class _MedicationDetailDialogState extends State<_MedicationDetailDialog> {
  late bool _isTaken;

  @override
  void initState() {
    super.initState();
    _isTaken = widget.isTaken;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medColor = Color(widget.medication.color);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
                  MedicationIcons.fromCodePoint(widget.medication.icon),
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
                      widget.medication.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDosage(widget.medication.dosageValue, widget.medication.dosageUnit),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (widget.medication.remainingPills != null)
                      Text(
                        'Остаток: ${widget.medication.remainingPills}',
                        style: TextStyle(
                          color: widget.medication.remainingPills! <= 5
                              ? Colors.red
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    if (widget.time != null)
                      Text(
                        widget.time!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.medication.notes != null &&
              widget.medication.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              widget.medication.notes!,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
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
                onTap: widget.onEdit,
              ),
              _DialogIconButton(
                icon: Bootstrap.archive,
                tooltip: 'Архив',
                onTap: widget.onArchive,
              ),
              widget.medication.isCompleted
                  ? _DialogIconButton(
                      icon: IonIcons.arrow_redo,
                      tooltip: 'Возобновить',
                      onTap: widget.onRestore,
                    )
                  : _DialogIconButton(
                      icon: FontAwesome.circle_check,
                      tooltip: 'Завершить',
                      onTap: widget.onComplete,
                    ),
              _DialogIconButton(
                icon: FontAwesome.trash_can,
                tooltip: 'Удалить',
                onTap: widget.onDelete,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.time != null)
                IconButton(
                  icon: const Icon(FontAwesome.clock, size: 20),
                  onPressed: widget.onEdit,
                  tooltip: 'Изменить время',
                ),
              const Spacer(),
              if (widget.time == null && widget.onCancelTake != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: widget.onCancelTake,
                    child: const Text('Отменить'),
                  ),
                ),
              FilledButton.tonalIcon(
                onPressed: () {
                  if (widget.time != null) {
                    setState(() => _isTaken = !_isTaken);
                  }
                  widget.onTake();
                },
                icon: _isTaken && widget.time != null
                    ? const Icon(FontAwesome.circle_check, size: 20)
                    : const Icon(FontAwesome.circle_check, size: 20),
                label: Text(
                  _isTaken && widget.time != null ? 'Принято' : 'Принять',
                ),
              ),
            ],
          ),
        ],
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
