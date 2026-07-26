import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'database_migrations.dart';
import 'tables/rep_events_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/workout_sessions_table.dart';
import 'tables/running_sessions_table.dart';
import 'tables/running_points_table.dart';

part 'local_database.g.dart';

@DriftDatabase(
  tables: [
    WorkoutSessions,
    RepEvents,
    SyncQueueItems,
    RunningSessions,
    RunningPoints,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
  LocalDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => DatabaseMigrations.schemaVersion;
  @override
  MigrationStrategy get migration => DatabaseMigrations.strategy(this);
}

QueryExecutor _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  return NativeDatabase.createInBackground(
    File(p.join(directory.path, 'fitvision.sqlite')),
  );
});

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  final database =
      ref.watch(appConfigProvider).environment == AppEnvironment.testing
      ? LocalDatabase.forTesting(NativeDatabase.memory())
      : LocalDatabase();
  ref.onDispose(database.close);
  return database;
});
