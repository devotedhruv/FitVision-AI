import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class StartRun {
  const StartRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession> call(String userId) => repository.start(userId);
}
