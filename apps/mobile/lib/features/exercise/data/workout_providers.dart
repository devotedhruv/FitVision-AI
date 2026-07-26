import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart'
    show localDatabaseProvider;
import 'package:fitvision_ai/core/sync/connectivity_monitor.dart';
import 'package:fitvision_ai/core/sync/sync_manager.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/workout_repository.dart';
import '../domain/models/workout_session.dart';
import 'workout_local_data_source.dart';
import 'workout_remote_data_source.dart';
import 'workout_repository_impl.dart';

final workoutLocalDataSourceProvider = Provider<WorkoutLocalDataSource>(
  (ref) => WorkoutLocalDataSource(ref.watch(localDatabaseProvider)),
);
final workoutRemoteDataSourceProvider = Provider<WorkoutRemoteDataSource>(
  (ref) => ApiWorkoutRemoteDataSource(ref.watch(apiClientProvider)),
);
final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepositoryImpl(ref.watch(workoutLocalDataSourceProvider)),
);
final connectivityMonitorProvider = Provider<ConnectivityMonitor>(
  (ref) => ConnectivityPlusMonitor(),
);
final syncManagerProvider = Provider<SyncManager>((ref) {
  final local = ref.watch(workoutLocalDataSourceProvider);
  final manager = SyncManager(
    queue: SyncQueueDao(ref.watch(localDatabaseProvider)),
    local: local,
    remote: ref.watch(workoutRemoteDataSourceProvider),
    auth: ref.watch(authRepositoryProvider),
    connectivity: ref.watch(connectivityMonitorProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});

final workoutDetailsProvider = FutureProvider.autoDispose
    .family<WorkoutSession?, String>(
      (ref, id) => ref.watch(workoutRepositoryProvider).get(id),
    );
final workoutHistoryProvider = StreamProvider.autoDispose
    .family<List<WorkoutSession>, String>(
      (ref, userId) =>
          ref.watch(workoutRepositoryProvider).watchHistory(userId),
    );
