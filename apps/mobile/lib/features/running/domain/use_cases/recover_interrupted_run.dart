import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class RecoverInterruptedRun {
  const RecoverInterruptedRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession?> call(String userId) => repository.recover(userId);
}
