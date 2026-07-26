import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import 'package:fitvision_ai/features/exercise/data/workout_providers.dart';
import 'package:fitvision_ai/features/running/data/running_providers.dart';
import '../domain/repositories/history_repository.dart';
import 'history_local_data_source.dart';
import 'history_repository_impl.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(
    HistoryLocalDataSource(ref.watch(localDatabaseProvider)),
    ref.watch(workoutRepositoryProvider),
    ref.watch(runningRepositoryProvider),
  ),
);
