import 'rep_event.dart';

enum WorkoutExerciseType { squat, curl, pushup }

enum WorkoutSessionStatus { active, paused, completed, abandoned, failed }

enum WorkoutSyncState { pending, syncing, synced, failed, conflict }

class WorkoutSession {
  const WorkoutSession({
    required this.localId,
    this.remoteId,
    required this.userId,
    required this.exerciseType,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.accumulatedActiveDuration,
    this.currentActiveSegmentStartedAt,
    required this.completedRepCount,
    required this.incompleteRepCount,
    required this.validFormRepCount,
    required this.repEvents,
    required this.syncState,
    required this.createdAt,
    required this.updatedAt,
    this.averageRepDuration,
    this.summaryJson,
    this.lastSyncedAt,
    this.recordVersion = 1,
  });

  final String localId;
  final String? remoteId;
  final String userId;
  final WorkoutExerciseType exerciseType;
  final WorkoutSessionStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration accumulatedActiveDuration;
  final DateTime? currentActiveSegmentStartedAt;
  final int completedRepCount;
  final int incompleteRepCount;
  final int validFormRepCount;
  final Duration? averageRepDuration;
  final String? summaryJson;
  final List<RepEvent> repEvents;
  final WorkoutSyncState syncState;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final int recordVersion;

  int get totalRepCount => completedRepCount + incompleteRepCount;
  Duration activeDurationAt(DateTime now) {
    if (status != WorkoutSessionStatus.active ||
        currentActiveSegmentStartedAt == null) {
      return accumulatedActiveDuration;
    }
    final difference = now.toUtc().difference(
      currentActiveSegmentStartedAt!.toUtc(),
    );
    return accumulatedActiveDuration +
        (difference.isNegative ? Duration.zero : difference);
  }
}
