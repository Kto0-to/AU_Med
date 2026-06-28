import 'package:drift/drift.dart';
import 'package:au_med/src/database/tables/medications_table.dart';

class MedicationLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().references(MedicationsTable, #id)();
  TextColumn get scheduledTime => text()();
  TextColumn get takenTime => text().nullable()();
  TextColumn get status => text()();
  RealColumn get dosageTaken => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
}
