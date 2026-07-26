import '../models/rep_event.dart';
import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class RecordRepEvent {
  const RecordRepEvent(this.repository);
  final WorkoutRepository repository;
  Future<WorkoutSession> call(RepEvent event) => repository.recordRep(event);
}
