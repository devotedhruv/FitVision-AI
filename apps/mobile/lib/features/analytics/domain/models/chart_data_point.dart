enum ChartMetric {
  sessions,
  completedReps,
  validReps,
  formScore,
  runningDistance,
  runningDuration,
  runningPace,
}

enum DataAvailability { available, missing, partial }

class ChartDataPoint {
  const ChartDataPoint({
    required this.periodStart,
    required this.periodEnd,
    required this.value,
    required this.metric,
    this.label,
    this.availability = DataAvailability.available,
  });
  final DateTime periodStart, periodEnd;
  final double? value;
  final ChartMetric metric;
  final String? label;
  final DataAvailability availability;
}
