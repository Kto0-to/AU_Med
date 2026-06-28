import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/medications_table.dart';
import 'tables/medication_logs_table.dart';
import 'tables/dosage_changes_table.dart';
import 'daos/medications_dao.dart';
import 'daos/logs_dao.dart';
import 'daos/statistics_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [MedicationsTable, MedicationLogsTable, DosageChangesTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  late final medicationsDao = MedicationsDao(this);
  late final logsDao = LogsDao(this);
  late final statisticsDao = StatisticsDao(this);

  static AppDatabase? _instance;
  static Future<AppDatabase> getInstance() async {
    if (_instance != null) return _instance!;
    final db = AppDatabase(_openConnection());
    _instance = db;
    return db;
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(medicationsTable, medicationsTable.startDate);
        await m.addColumn(medicationsTable, medicationsTable.endDate);
        await m.addColumn(medicationsTable, medicationsTable.remainingPills);
      }
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        await _seedDefaultData();
      }
    },
  );

  Future<void> _seedDefaultData() async {
    // Reserved for future default data seeding
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    await Directory(dir.path).create(recursive: true);
    final file = File(p.join(dir.path, 'med_tracker.db'));
    return NativeDatabase(file);
  });
}
