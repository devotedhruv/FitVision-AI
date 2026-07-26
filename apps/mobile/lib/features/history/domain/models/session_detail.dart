import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:fitvision_ai/features/running/domain/models/running_session.dart';

sealed class SessionDetail {
  const SessionDetail();
}

final class ExerciseSessionDetail extends SessionDetail {
  const ExerciseSessionDetail(this.session);
  final WorkoutSession session;
}

final class RunningSessionDetail extends SessionDetail {
  const RunningSessionDetail(this.session);
  final RunningSession session;
}
