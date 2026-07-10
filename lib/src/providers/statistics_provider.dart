import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/shared/day_status.dart';

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

final weeklyBarChartProvider =
    FutureProvider<List<BarChartDayData>>((ref) async {
  final dao = ref.read(statisticsDaoProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 6));
  final data = await dao.getHeatmapScheduleData(start, today.add(const Duration(days: 1)));
  final result = <BarChartDayData>[];
  for (var d = start; !d.isAfter(today); d = d.add(const Duration(days: 1))) {
    final entry = data[d];
    result.add(BarChartDayData(
      date: d,
      taken: entry?.taken ?? 0,
      missed: entry?.missed ?? 0,
      total: entry?.total ?? 0,
    ));
  }
  return result;
});

final monthlyBarChartProvider =
    FutureProvider<List<BarChartDayData>>((ref) async {
  final dao = ref.read(statisticsDaoProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 29));
  final data = await dao.getHeatmapScheduleData(start, today.add(const Duration(days: 1)));
  final result = <BarChartDayData>[];
  for (var d = start; !d.isAfter(today); d = d.add(const Duration(days: 1))) {
    final entry = data[d];
    result.add(BarChartDayData(
      date: d,
      taken: entry?.taken ?? 0,
      missed: entry?.missed ?? 0,
      total: entry?.total ?? 0,
    ));
  }
  return result;
});

class BarChartDayData {
  final DateTime date;
  final int taken;
  final int missed;
  final int total;

  const BarChartDayData({
    required this.date,
    required this.taken,
    required this.missed,
    required this.total,
  });
}

// ── Heatmap ──

DateTime _previousMonday(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: (d.weekday - DateTime.monday) % 7));
}

DateTime _nextSunday(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.add(Duration(days: (DateTime.sunday - d.weekday) % 7));
}

DayStatus _computeDayStatus(DateTime date, DateTime today,
    ({int total, int taken, int missed, int pending})? entry) {
  if (date.isAfter(today)) return DayStatus.future;
  if (entry == null) return DayStatus.empty;
  if (entry.taken == entry.total) return DayStatus.completed;
  if (entry.missed == entry.total) return DayStatus.missed;
  return DayStatus.partial;
}

List<HeatmapDayData> _buildHeatmapData(
  DateTime start,
  DateTime end,
  Map<DateTime, ({int total, int taken, int missed, int pending})> scheduleData,
  Set<DateTime> prnDays,
  DateTime today,
) {
  final result = <HeatmapDayData>[];
  var current = start;
  while (!current.isAfter(end)) {
    result.add(HeatmapDayData(
      date: current,
      status: _computeDayStatus(current, today, scheduleData[current]),
      hasPrn: prnDays.contains(current),
    ));
    current = current.add(const Duration(days: 1));
  }
  return result;
}

class HeatmapRangeNotifier extends Notifier<int> {
  @override
  int build() => 60;

  void setRange(int range) => state = range;
}

final heatmapRangeProvider = NotifierProvider<HeatmapRangeNotifier, int>(HeatmapRangeNotifier.new);

final heatmapDataProvider = FutureProvider<List<HeatmapDayData>>((ref) async {
  final range = ref.watch(heatmapRangeProvider);
  final dao = ref.read(statisticsDaoProvider);

  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final rawStart = today.subtract(Duration(days: range - 1));
  final start = _previousMonday(rawStart);
  final end = _nextSunday(today);

  final queryEnd = end.add(const Duration(days: 1));
  final scheduleData = await dao.getHeatmapScheduleData(start, queryEnd);
  final prnDays = await dao.prnDaysForPeriod(start, queryEnd);

  return _buildHeatmapData(start, end, scheduleData, prnDays, today);
});

final weekHeatmapProvider =
    FutureProvider.family<List<HeatmapDayData>, DateTime>((ref, date) async {
  final dao = ref.read(statisticsDaoProvider);

  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final monday = _previousMonday(date);
  final sunday = _nextSunday(date);

  final queryEnd = sunday.add(const Duration(days: 1));
  final scheduleData = await dao.getHeatmapScheduleData(monday, queryEnd);
  final prnDays = await dao.prnDaysForPeriod(monday, queryEnd);

  return _buildHeatmapData(monday, sunday, scheduleData, prnDays, today);
});
