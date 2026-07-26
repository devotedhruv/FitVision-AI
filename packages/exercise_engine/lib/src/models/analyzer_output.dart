import '../feedback/feedback_code.dart';
import '../state_machine/exercise_state.dart';
import 'rep_result.dart';

class TrackingStatus {
  const TrackingStatus({
    required this.accepted,
    this.missing = const [],
    this.warning,
  });
  final bool accepted;
  final List<int> missing;
  final FeedbackCode? warning;
}

class AnalyzerOutput {
  const AnalyzerOutput({
    required this.exerciseType,
    required this.currentState,
    required this.stageLabel,
    required this.totalCompletedReps,
    required this.repCompleted,
    required this.incompleteRepDetected,
    required this.jointAngles,
    required this.trackingStatus,
    required this.formValid,
    required this.feedbackCodes,
    required this.timestamp,
    this.completedRep,
  });
  final ExerciseType exerciseType;
  final ExerciseState currentState;
  final String stageLabel;
  final int totalCompletedReps;
  final bool repCompleted;
  final bool incompleteRepDetected;
  final Map<String, double> jointAngles;
  final TrackingStatus trackingStatus;
  final bool formValid;
  final List<FeedbackCode> feedbackCodes;
  final RepResult? completedRep;
  final Duration timestamp;
}
