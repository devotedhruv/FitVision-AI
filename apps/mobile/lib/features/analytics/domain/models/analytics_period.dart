enum AnalyticsPeriodType { daily, weekly, monthly }

class AnalyticsPeriod {
  const AnalyticsPeriod({
    required this.type,
    required this.startLocal,
    required this.endLocal,
    required this.comparisonStartLocal,
    required this.comparisonEndLocal,
    this.exerciseType,
  });
  final AnalyticsPeriodType type;
  final DateTime startLocal, endLocal, comparisonStartLocal, comparisonEndLocal;
  final String? exerciseType;
  ({DateTime start, DateTime end}) get utcRange =>
      (start: startLocal.toUtc(), end: endLocal.toUtc());
  ({DateTime start, DateTime end}) get comparisonUtcRange =>
      (start: comparisonStartLocal.toUtc(), end: comparisonEndLocal.toUtc());
  static AnalyticsPeriod current(
    AnalyticsPeriodType type,
    DateTime now, {
    String? exercise,
  }) {
    final day = DateTime(now.year, now.month, now.day);
    late DateTime start, end, previousStart, previousEnd;
    switch (type) {
      case AnalyticsPeriodType.daily:
        start = day;
        end = day.add(const Duration(days: 1));
        previousEnd = start;
        previousStart = start.subtract(const Duration(days: 1));
      case AnalyticsPeriodType.weekly:
        start = day.subtract(Duration(days: day.weekday - 1));
        end = start.add(const Duration(days: 7));
        previousEnd = start;
        previousStart = start.subtract(const Duration(days: 7));
      case AnalyticsPeriodType.monthly:
        start = DateTime(now.year, now.month);
        end = DateTime(now.year, now.month + 1);
        previousStart = DateTime(now.year, now.month - 1);
        previousEnd = start;
    }
    return AnalyticsPeriod(
      type: type,
      startLocal: start,
      endLocal: end,
      comparisonStartLocal: previousStart,
      comparisonEndLocal: previousEnd,
      exerciseType: exercise,
    );
  }
}
