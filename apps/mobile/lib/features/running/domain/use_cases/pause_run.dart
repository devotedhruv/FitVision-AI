import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class PauseRun {
  const PauseRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession> call(String id) => repository.pause(id);
}
