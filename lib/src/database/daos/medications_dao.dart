import 'package:drift/drift.dart';
import 'package:au_med/src/database/database.dart';

class MedicationsDao {
  final AppDatabase _db;
  MedicationsDao(this._db);

  Stream<List<MedicationsTableData>> watchAll() =>
      _db.select(_db.medicationsTable).watch();

  Stream<List<MedicationsTableData>> watchNonArchived() =>
      (_db.select(_db.medicationsTable)
            ..where((t) => t.isArchived.equals(false)))
          .watch();

  Stream<List<MedicationsTableData>> watchActive() {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return (_db.select(_db.medicationsTable)
          ..where((t) =>
              t.isArchived.equals(false) & t.isCompleted.equals(false)))
        .watch()
        .map((list) => list.where((m) {
              if (m.startDate.isEmpty) return true;
              final s = m.startDate.length >= 10
                  ? m.startDate.substring(0, 10)
                  : m.startDate;
              return s.compareTo(todayStr) <= 0;
            }).toList());
  }

  Stream<List<MedicationsTableData>> watchArchived() =>
      (_db.select(_db.medicationsTable)
            ..where((t) => t.isArchived.equals(true)))
          .watch();

  Stream<List<MedicationsTableData>> watchCompleted() =>
      (_db.select(_db.medicationsTable)
            ..where((t) => t.isCompleted.equals(true)))
          .watch();

  Future<MedicationsTableData?> getById(int id) =>
      (_db.select(_db.medicationsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insert(MedicationsTableCompanion entry) =>
      _db.into(_db.medicationsTable).insert(entry);

  Future<bool> updateEntry(MedicationsTableCompanion entry) =>
      _db.update(_db.medicationsTable).replace(entry);

  Future<void> deleteMedication(int id) =>
      (_db.delete(_db.medicationsTable)..where((t) => t.id.equals(id))).go();

  Future<void> archive(int id) =>
      (_db.update(_db.medicationsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationsTableCompanion(isArchived: Value(true)));

  Future<void> unarchive(int id) =>
      (_db.update(_db.medicationsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationsTableCompanion(isArchived: Value(false)));

  Future<void> markCompleted(int id) =>
      (_db.update(_db.medicationsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationsTableCompanion(isCompleted: Value(true)));

  Future<void> uncomplete(int id) =>
      (_db.update(_db.medicationsTable)..where((t) => t.id.equals(id)))
          .write(const MedicationsTableCompanion(isCompleted: Value(false)));

  Future<List<MedicationsTableData>> search(String query) =>
      (_db.select(_db.medicationsTable)
            ..where((t) => t.name.like('%$query%'))
            ..limit(20))
        .get();

  Future<void> adjustRemainingPills(int id, int sign) async {
    final med = await getById(id);
    if (med == null || med.remainingPills == null) return;
    final step = med.dosageValue.ceil().clamp(1, 999999);
    final next = (med.remainingPills! + sign * step).clamp(0, 100000000);
    await (_db.update(_db.medicationsTable)..where((t) => t.id.equals(id)))
        .write(MedicationsTableCompanion(remainingPills: Value(next)));
  }
}
