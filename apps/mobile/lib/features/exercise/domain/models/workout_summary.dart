import 'workout_session.dart';

class WorkoutSummary {
  const WorkoutSummary({
    required this.session,
    required this.frequentFeedbackCodes,
  });
  final WorkoutSession session;
  final List<String> frequentFeedbackCodes;
}
