import 'package:drift/drift.dart';
import 'package:au_med/src/database/database.dart';

class StatisticsDao {
  final AppDatabase _db;
  StatisticsDao(this._db);

  Future<int> totalLogsForPeriod(DateTime start, DateTime end) =>
      (_db.select(_db.medicationLogsTable)
            ..where((t) => t.scheduledTime.isBetweenValues(
                start.toIso8601String(), end.toIso8601String())))
          .map((row) => row.id)
          .get()
          .then((rows) => rows.length);

  Future<int> takenLogsForPeriod(DateTime start, DateTime end) =>
      (_db.select(_db.medicationLogsTable)
            ..where((t) =>
                t.status.equals('taken') &
                t.scheduledTime.isBetweenValues(
                    start.toIso8601String(), end.toIso8601String())))
          .map((row) => row.id)
          .get()
          .then((rows) => rows.length);

  Future<int> missedLogsForPeriod(DateTime start, DateTime end) =>
      (_db.select(_db.medicationLogsTable)
            ..where((t) =>
                t.status.equals('missed') &
                t.scheduledTime.isBetweenValues(
                    start.toIso8601String(), end.toIso8601String())))
          .map((row) => row.id)
          .get()
          .then((rows) => rows.length);

  Future<double> adherenceRate(DateTime start, DateTime end) async {
    final total = await totalLogsForPeriod(start, end);
    if (total == 0) return 0.0;
    final taken = await takenLogsForPeriod(start, end);
    return taken / total;
  }

  Future<Map<DateTime, List<bool>>> getDailyLogs(
      DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.medicationLogsTable).join([
      innerJoin(
        _db.medicationsTable,
        _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
      ),
    ])
      ..where(
        _db.medicationLogsTable.scheduledTime.isBetweenValues(
            start.toIso8601String(), end.toIso8601String()) &
        _db.medicationsTable.times.equals('').not(),
      ))
      .get();

    final result = <DateTime, List<bool>>{};
    for (final row in rows) {
      final log = row.readTable(_db.medicationLogsTable);
      if (log.status == 'scheduled') continue;
      final day = DateTime.parse(log.scheduledTime);
      final dayKey = DateTime(day.year, day.month, day.day);
      result.putIfAbsent(dayKey, () => []);
      result[dayKey]!.add(log.status == 'taken');
    }
    return result;
  }

  Future<Map<String, int>> getStatusDistribution(
      DateTime start, DateTime end) async {
    final logs = await (_db.select(_db.medicationLogsTable)
          ..where((t) => t.scheduledTime.isBetweenValues(
              start.toIso8601String(), end.toIso8601String())))
        .get();

    final map = <String, int>{
      'taken': 0,
      'missed': 0,
      'skipped': 0,
      'scheduled': 0
    };
    for (final log in logs) {
      map[log.status] = (map[log.status] ?? 0) + 1;
    }
    return map;
  }

  Future<int> prnTakenForPeriod(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.medicationLogsTable).join([
      innerJoin(
        _db.medicationsTable,
        _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
      ),
    ])
      ..where(
        _db.medicationLogsTable.status.equals('taken') &
        _db.medicationLogsTable.scheduledTime.isBetweenValues(
            start.toIso8601String(), end.toIso8601String()) &
        _db.medicationsTable.times.equals(''),
      ))
      .get();
    return rows.length;
  }

  Future<Set<DateTime>> missedDaysForPeriod(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.medicationLogsTable).join([
      innerJoin(
        _db.medicationsTable,
        _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
      ),
    ])
      ..where(
        _db.medicationLogsTable.status.equals('missed') &
        _db.medicationLogsTable.scheduledTime.isBetweenValues(
            start.toIso8601String(), end.toIso8601String()) &
        _db.medicationsTable.times.equals('').not(),
      ))
      .get();

    final result = <DateTime>{};
    for (final row in rows) {
      final log = row.readTable(_db.medicationLogsTable);
      final day = DateTime.parse(log.scheduledTime);
      result.add(DateTime(day.year, day.month, day.day));
    }
    return result;
  }

  Future<Set<DateTime>> pendingDaysForPeriod(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.medicationLogsTable).join([
      innerJoin(
        _db.medicationsTable,
        _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
      ),
    ])
      ..where(
        _db.medicationLogsTable.status.equals('scheduled') &
        _db.medicationLogsTable.scheduledTime.isBetweenValues(
            start.toIso8601String(), end.toIso8601String()) &
        _db.medicationsTable.times.equals('').not(),
      ))
      .get();

    final result = <DateTime>{};
    for (final row in rows) {
      final log = row.readTable(_db.medicationLogsTable);
      final day = DateTime.parse(log.scheduledTime);
      result.add(DateTime(day.year, day.month, day.day));
    }
    return result;
  }

  Future<Set<DateTime>> prnDaysForPeriod(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.medicationLogsTable).join([
      innerJoin(
        _db.medicationsTable,
        _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
      ),
    ])
      ..where(
        _db.medicationLogsTable.status.equals('taken') &
        _db.medicationLogsTable.scheduledTime.isBetweenValues(
            start.toIso8601String(), end.toIso8601String()) &
        _db.medicationsTable.times.equals(''),
      ))
      .get();

    final result = <DateTime>{};
    for (final row in rows) {
      final log = row.readTable(_db.medicationLogsTable);
      final day = DateTime.parse(log.scheduledTime);
      result.add(DateTime(day.year, day.month, day.day));
    }
    return result;
  }

  Future<int> streakDays() async {
    return streakDaysUpTo(DateTime.now());
  }

  Future<int> streakDaysUpTo(DateTime date) async {
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final day = date.subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final results = await (_db.select(_db.medicationLogsTable).join([
        innerJoin(
          _db.medicationsTable,
          _db.medicationsTable.id.equalsExp(_db.medicationLogsTable.medicationId),
        ),
      ])
            ..where(
              _db.medicationLogsTable.scheduledTime.isBetweenValues(
                  dayStart.toIso8601String(), dayEnd.toIso8601String()) &
              _db.medicationsTable.times.equals('').not(),
            ))
          .get();
      if (results.isEmpty) continue;
      if (results.every((r) => r.readTable(_db.medicationLogsTable).status == 'scheduled')) continue;
      if (results.every((r) => r.readTable(_db.medicationLogsTable).status == 'taken')) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
