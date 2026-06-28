import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';

final todayLogsProvider = StreamProvider<List<MedicationLogsTableData>>((ref) {
  return ref.read(logsDaoProvider).watchTodayLogs();
});

final logsForDateProvider =
    StreamProvider.family<List<MedicationLogsTableData>, DateTime>((ref, date) {
  return ref.read(logsDaoProvider).watchForDate(date);
});

final logsForMedicationProvider =
    StreamProvider.family<List<MedicationLogsTableData>, int>((ref, medicationId) {
  return ref.read(logsDaoProvider).watchForMedication(medicationId);
});
