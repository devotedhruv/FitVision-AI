import 'workout_session.dart';

enum RepEventType { completed, incomplete, formWarning }

class RepEvent {
  const RepEvent({
    required this.localId,
    this.remoteId,
    required this.workoutLocalId,
    required this.sequenceNumber,
    required this.eventType,
    required this.exerciseType,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
    required this.formValid,
    this.minimumPrimaryAngle,
    this.maximumPrimaryAngle,
    required this.feedbackCodes,
    required this.createdAt,
    this.recordVersion = 1,
  });
  final String localId;
  final String? remoteId;
  final String workoutLocalId;
  final int sequenceNumber;
  final RepEventType eventType;
  final WorkoutExerciseType exerciseType;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;
  final bool formValid;
  final double? minimumPrimaryAngle;
  final double? maximumPrimaryAngle;
  final List<String> feedbackCodes;
  final DateTime createdAt;
  final int recordVersion;
}
