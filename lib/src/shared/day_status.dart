enum DayStatus { future, empty, completed, partial, missed }

class HeatmapDayData {
  final DateTime date;
  final DayStatus status;
  final bool hasPrn;

  const HeatmapDayData({
    required this.date,
    required this.status,
    this.hasPrn = false,
  });
}
