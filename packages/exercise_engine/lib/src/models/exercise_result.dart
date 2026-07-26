import '../feedback/feedback_code.dart';
import '../state_machine/exercise_state.dart';
import 'rep_result.dart';

class ExerciseResult {
  const ExerciseResult({
    required this.exerciseType,
    required this.completedRepCount,
    required this.incompleteRepCount,
    required this.validFormRepCount,
    required this.sessionStart,
    required this.sessionEnd,
    required this.repResults,
    required this.feedbackSummary,
  });
  final ExerciseType exerciseType;
  final int completedRepCount;
  final int incompleteRepCount;
  final int validFormRepCount;
  final Duration sessionStart;
  final Duration sessionEnd;
  final List<RepResult> repResults;
  final List<FeedbackCode> feedbackSummary;
}
