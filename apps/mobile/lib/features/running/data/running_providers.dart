import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/core/storage/daos/running_dao.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../domain/repositories/running_repository.dart';
import 'running_local_data_source.dart';
import 'running_remote_data_source.dart';
import 'running_repository_impl.dart';
import 'services/background_tracking_service.dart';
import 'services/location_service.dart';

final locationServiceProvider = Provider<LocationService>(
  (_) => PlatformLocationService(),
);
final backgroundTrackingServiceProvider = Provider(
  (_) => BackgroundTrackingService(),
);
final runningLocalDataSourceProvider = Provider((ref) {
  final db = ref.watch(localDatabaseProvider);
  return RunningLocalDataSource(db, RunningDao(db), SyncQueueDao(db));
});
final runningRepositoryProvider = Provider<RunningRepository>(
  (ref) => RunningRepositoryImpl(ref.watch(runningLocalDataSourceProvider)),
);
final runningRemoteDataSourceProvider = Provider<RunningRemoteDataSource>(
  (ref) => ApiRunningRemoteDataSource(ref.watch(apiClientProvider)),
);
final runningHistoryProvider = StreamProvider.autoDispose.family(
  (ref, String userId) =>
      ref.watch(runningRepositoryProvider).watchHistory(userId),
);
