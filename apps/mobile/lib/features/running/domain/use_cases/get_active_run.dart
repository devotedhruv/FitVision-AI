import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class GetActiveRun {
  const GetActiveRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession?> call(String userId) => repository.active(userId);
}
