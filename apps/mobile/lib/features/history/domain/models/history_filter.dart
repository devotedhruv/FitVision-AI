enum HistoryDatePreset { allTime, today, last7Days, last30Days, custom }

enum HistoryCategoryFilter { all, exercise, running }

enum HistoryExerciseFilter { all, squat, curl, pushup }

enum HistorySyncFilter { all, synced, pending, failed }

class HistoryFilter {
  const HistoryFilter({
    this.datePreset = HistoryDatePreset.allTime,
    this.category = HistoryCategoryFilter.all,
    this.exercise = HistoryExerciseFilter.all,
    this.sync = HistorySyncFilter.all,
    this.customStart,
    this.customEnd,
    this.pageSize = 25,
  });
  final HistoryDatePreset datePreset;
  final HistoryCategoryFilter category;
  final HistoryExerciseFilter exercise;
  final HistorySyncFilter sync;
  final DateTime? customStart, customEnd;
  final int pageSize;
  ({DateTime? startUtc, DateTime? endUtc}) utcRange(DateTime nowLocal) {
    DateTime? start, end;
    switch (datePreset) {
      case HistoryDatePreset.allTime:
        break;
      case HistoryDatePreset.today:
        start = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
        end = start.add(const Duration(days: 1));
      case HistoryDatePreset.last7Days:
        end = DateTime(
          nowLocal.year,
          nowLocal.month,
          nowLocal.day,
        ).add(const Duration(days: 1));
        start = end.subtract(const Duration(days: 7));
      case HistoryDatePreset.last30Days:
        end = DateTime(
          nowLocal.year,
          nowLocal.month,
          nowLocal.day,
        ).add(const Duration(days: 1));
        start = end.subtract(const Duration(days: 30));
      case HistoryDatePreset.custom:
        if (customStart == null ||
            customEnd == null ||
            customEnd!.isBefore(customStart!)) {
          throw ArgumentError('Invalid custom date range');
        }
        start = DateTime(
          customStart!.year,
          customStart!.month,
          customStart!.day,
        );
        end = DateTime(
          customEnd!.year,
          customEnd!.month,
          customEnd!.day,
        ).add(const Duration(days: 1));
    }
    return (startUtc: start?.toUtc(), endUtc: end?.toUtc());
  }

  HistoryFilter copyWith({
    HistoryDatePreset? datePreset,
    HistoryCategoryFilter? category,
    HistoryExerciseFilter? exercise,
    HistorySyncFilter? sync,
    DateTime? customStart,
    DateTime? customEnd,
  }) => HistoryFilter(
    datePreset: datePreset ?? this.datePreset,
    category: category ?? this.category,
    exercise: exercise ?? this.exercise,
    sync: sync ?? this.sync,
    customStart: customStart ?? this.customStart,
    customEnd: customEnd ?? this.customEnd,
    pageSize: pageSize,
  );
}
