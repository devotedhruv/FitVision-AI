import 'package:fitvision_ai/features/exercise/domain/repositories/workout_repository.dart';
import 'package:fitvision_ai/features/running/domain/repositories/running_repository.dart';
import '../domain/models/history_filter.dart';
import '../domain/models/history_item.dart';
import '../domain/models/session_detail.dart';
import '../domain/repositories/history_repository.dart';
import 'history_local_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this.local, this.workouts, this.runs);
  final HistoryLocalDataSource local;
  final WorkoutRepository workouts;
  final RunningRepository runs;
  @override
  Future<List<HistoryItem>> page(
    String userId,
    HistoryFilter filter, {
    int page = 0,
  }) => local.page(userId, filter, page: page);
  @override
  Stream<void> changes(String userId) => local.changes(userId);
  @override
  Future<SessionDetail?> detail(
    String userId,
    String id,
    HistoryCategory category,
  ) async {
    if (category == HistoryCategory.exercise) {
      final value = await workouts.get(id);
      return value == null || value.userId != userId
          ? null
          : ExerciseSessionDetail(value);
    }
    final value = await runs.get(id);
    return value == null || value.userId != userId
        ? null
        : RunningSessionDetail(value);
  }
}
