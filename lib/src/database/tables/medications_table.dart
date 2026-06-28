import 'package:drift/drift.dart';

class MedicationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get dosageValue => real()();
  TextColumn get dosageUnit => text()();
  IntColumn get frequencyPerDay => integer().nullable()();
  RealColumn get intervalHours => real().nullable()();
  TextColumn get times => text()();
  IntColumn get color => integer()();
  TextColumn get icon => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get startDate => text().withDefault(const Constant(''))();
  TextColumn get endDate => text().nullable()();
  IntColumn get remainingPills => integer().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}
