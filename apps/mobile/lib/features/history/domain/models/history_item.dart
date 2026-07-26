enum HistoryCategory { exercise, running }

class HistoryItem {
  const HistoryItem({
    required this.localId,
    this.remoteId,
    required this.category,
    this.exerciseType,
    required this.startedAt,
    this.endedAt,
    required this.activeDuration,
    required this.completed,
    required this.syncStatus,
    this.completedReps,
    this.incompleteReps,
    this.validFormReps,
    this.formScore,
    this.feedbackCodes = const [],
    this.distanceMeters,
    this.averagePaceSecondsPerKm,
    this.averageSpeedMps,
    this.routeAvailable = false,
    this.acceptedPointCount,
  });
  final String localId;
  final String? remoteId, exerciseType;
  final HistoryCategory category;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration activeDuration;
  final bool completed;
  final String syncStatus;
  final int? completedReps, incompleteReps, validFormReps, acceptedPointCount;
  final double? formScore,
      distanceMeters,
      averagePaceSecondsPerKm,
      averageSpeedMps;
  final List<String> feedbackCodes;
  final bool routeAvailable;
}
