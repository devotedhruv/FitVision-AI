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

  Future<void> deleteUserData(String userId) => transaction(() async {
    await customStatement(
      'DELETE FROM sync_queue_items WHERE entity_local_id IN '
      '(SELECT local_id FROM rep_events WHERE workout_local_id IN '
      '(SELECT local_id FROM workout_sessions WHERE user_id = ?)) '
      'OR entity_local_id IN (SELECT local_id FROM running_points WHERE '
      'running_session_local_id IN (SELECT local_id FROM running_sessions '
      'WHERE user_id = ?)) OR entity_local_id IN '
      '(SELECT local_id FROM workout_sessions WHERE user_id = ?) '
      'OR entity_local_id IN (SELECT local_id FROM running_sessions '
      'WHERE user_id = ?)',
      [userId, userId, userId, userId],
    );
    await customStatement('DELETE FROM workout_sessions WHERE user_id = ?', [
      userId,
    ]);
    await customStatement('DELETE FROM running_sessions WHERE user_id = ?', [
      userId,
    ]);
  });
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
