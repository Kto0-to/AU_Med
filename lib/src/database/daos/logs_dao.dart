import 'package:drift/drift.dart';
import 'package:au_med/src/database/database.dart';

class LogsDao {
  final AppDatabase _db;
  LogsDao(this._db);

  Stream<List<MedicationLogsTableData>> watchForMedication(
          int medicationId) =>
      (_db.select(_db.medicationLogsTable)
            ..where((t) => t.medicationId.equals(medicationId))
            ..orderBy([(t) => OrderingTerm.desc(t.scheduledTime)]))
          .watch();

  Future<List<MedicationLogsTableData>> getForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.medicationLogsTable)
          ..where((t) => t.scheduledTime.isBetweenValues(
              dayStart.toIso8601String(), dayEnd.toIso8601String())))
        .get();
  }

  Future<List<MedicationLogsTableData>> getForMedicationOnDate(
      int medicationId, DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.medicationLogsTable)
          ..where((t) =>
              t.medicationId.equals(medicationId) &
              t.scheduledTime.isBetweenValues(
                  dayStart.toIso8601String(), dayEnd.toIso8601String())))
        .get();
  }

  Future<int> insert(MedicationLogsTableCompanion entry) =>
      _db.into(_db.medicationLogsTable).insert(entry);

  Future<void> markTaken(int id, DateTime takenTime) =>
      (_db.update(_db.medicationLogsTable)..where((t) => t.id.equals(id)))
          .write(
            MedicationLogsTableCompanion(
              status: const Value('taken'),
              takenTime: Value(takenTime.toIso8601String()),
            ),
          );

  Future<void> markMissed(int id) =>
      (_db.update(_db.medicationLogsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationLogsTableCompanion(status: Value('missed')));

  Future<void> markSkipped(int id) =>
      (_db.update(_db.medicationLogsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationLogsTableCompanion(status: Value('skipped')));

  Future<void> updateLog(int id, MedicationLogsTableCompanion entry) =>
      (_db.update(_db.medicationLogsTable)..where((t) => t.id.equals(id)))
          .write(entry);

  Future<void> deleteLog(int id) =>
      (_db.delete(_db.medicationLogsTable)..where((t) => t.id.equals(id)))
          .go();

  Future<void> autoMarkMissedForDate(
      List<MedicationsTableData> medications, DateTime date) async {
    final now = DateTime.now();
    final dayStart = DateTime(date.year, date.month, date.day);

    for (final med in medications) {
      if (med.startDate.isNotEmpty) {
        final s = med.startDate.length >= 10
            ? med.startDate.substring(0, 10)
            : med.startDate;
        final parsed = DateTime.tryParse(s);
        if (parsed != null && parsed.isAfter(dayStart)) continue;
      }
      if (med.endDate != null && med.endDate!.isNotEmpty) {
        final e = med.endDate!.length >= 10
            ? med.endDate!.substring(0, 10)
            : med.endDate!;
        final parsed = DateTime.tryParse(e);
        if (parsed != null && parsed.isBefore(dayStart)) continue;
      }
      final times =
          med.times.split(',').where((t) => t.isNotEmpty).toList();
      if (times.isEmpty) continue;

      final existingLogs = await getForMedicationOnDate(med.id, date);

      for (final time in times) {
        final parts = time.split(':');
        final slotTime = DateTime(dayStart.year, dayStart.month, dayStart.day,
            int.parse(parts[0]), int.parse(parts[1]));

        if (slotTime.isAfter(now)) continue;

        final existingTaken =
            existingLogs.any((l) => l.scheduledTime.contains(time) && l.status == 'taken');
        if (existingTaken) continue;

        final existingLog =
            existingLogs.where((l) => l.scheduledTime.contains(time)).firstOrNull;
        if (existingLog != null) {
          if (existingLog.status == 'scheduled') {
            await markMissed(existingLog.id);
          }
        } else {
          await insert(MedicationLogsTableCompanion(
            medicationId: Value(med.id),
            scheduledTime: Value(slotTime.toIso8601String()),
            status: const Value('missed'),
            createdAt: Value(now.toIso8601String()),
          ));
        }
      }
    }
  }

  Stream<List<MedicationLogsTableData>> watchForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.medicationLogsTable)
          ..where((t) => t.scheduledTime.isBetweenValues(
              dayStart.toIso8601String(), dayEnd.toIso8601String())))
        .watch();
  }

  Stream<List<MedicationLogsTableData>> watchTodayLogs() => watchForDate(DateTime.now());
}
