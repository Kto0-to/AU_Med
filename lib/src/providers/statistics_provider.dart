import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:au_med/src/providers/database_provider.dart';

final weeklyAdherenceProvider = FutureProvider<double>((ref) {
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  return ref.read(statisticsDaoProvider).adherenceRate(weekAgo, now);
});

final monthlyAdherenceProvider = FutureProvider<double>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  return ref.read(statisticsDaoProvider).adherenceRate(monthAgo, now);
});

final statusDistributionProvider = FutureProvider<Map<String, int>>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  return ref.read(statisticsDaoProvider).getStatusDistribution(monthAgo, now);
});

final streakDaysProvider = FutureProvider<int>((ref) {
  return ref.read(statisticsDaoProvider).streakDays();
});

final streakDaysUpToProvider = FutureProvider.family<int, DateTime>((ref, date) {
  return ref.read(statisticsDaoProvider).streakDaysUpTo(date);
});

final missedDaysProvider = FutureProvider<Set<DateTime>>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  return ref.read(statisticsDaoProvider).missedDaysForPeriod(monthAgo, endOfDay);
});

final pendingDaysProvider = FutureProvider<Set<DateTime>>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  return ref.read(statisticsDaoProvider).pendingDaysForPeriod(monthAgo, endOfDay);
});

final dailyLogsProvider = FutureProvider<Map<DateTime, List<bool>>>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  return ref.read(statisticsDaoProvider).getDailyLogs(monthAgo, now);
});

final todayPrnTakenProvider = FutureProvider<int>((ref) {
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  return ref.read(statisticsDaoProvider).prnTakenForPeriod(dayStart, dayEnd);
});

final prnDaysLast30Provider = FutureProvider<Set<DateTime>>((ref) {
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  return ref.read(statisticsDaoProvider).prnDaysForPeriod(monthAgo, now);
});

final todayTakenCountProvider = FutureProvider<int>((ref) {
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  return ref.read(statisticsDaoProvider).takenLogsForPeriod(dayStart, dayEnd);
});

final todayTotalCountProvider = FutureProvider<int>((ref) {
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  return ref.read(statisticsDaoProvider).totalLogsForPeriod(dayStart, dayEnd);
});
