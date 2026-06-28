import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';

final allMedicationsProvider = StreamProvider<List<MedicationsTableData>>((ref) {
  return ref.read(medicationsDaoProvider).watchNonArchived();
});

final activeMedicationsProvider = StreamProvider<List<MedicationsTableData>>((ref) {
  return ref.read(medicationsDaoProvider).watchActive();
});

final archivedMedicationsProvider = StreamProvider<List<MedicationsTableData>>((ref) {
  return ref.read(medicationsDaoProvider).watchArchived();
});

final completedMedicationsProvider = StreamProvider<List<MedicationsTableData>>((ref) {
  return ref.read(medicationsDaoProvider).watchCompleted();
});

final medicationByIdProvider = FutureProvider.family<MedicationsTableData?, int>((ref, id) {
  return ref.read(medicationsDaoProvider).getById(id);
});
