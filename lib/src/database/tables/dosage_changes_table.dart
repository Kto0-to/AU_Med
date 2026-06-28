import 'package:drift/drift.dart';
import 'package:au_med/src/database/tables/medications_table.dart';

class DosageChangesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().references(MedicationsTable, #id)();
  RealColumn get oldValue => real()();
  TextColumn get oldUnit => text()();
  RealColumn get newValue => real()();
  TextColumn get newUnit => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get changedAt => text()();
}
