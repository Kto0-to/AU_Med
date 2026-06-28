import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:au_med/src/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Must be overridden in main');
});

final medicationsDaoProvider = Provider((ref) => ref.read(databaseProvider).medicationsDao);
final logsDaoProvider = Provider((ref) => ref.read(databaseProvider).logsDao);
final statisticsDaoProvider = Provider((ref) => ref.read(databaseProvider).statisticsDao);
