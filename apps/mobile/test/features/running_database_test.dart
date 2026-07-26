import 'package:drift/native.dart';
import 'package:fitvision_ai/core/storage/daos/running_dao.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import 'package:fitvision_ai/features/running/data/running_local_data_source.dart';
import 'package:fitvision_ai/features/running/domain/models/location_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalDatabase db;
  late RunningLocalDataSource local;
  setUp(() {
    db = LocalDatabase.forTesting(NativeDatabase.memory());
    local = RunningLocalDataSource(
      db,
      RunningDao(db),
      SyncQueueDao(db),
      clock: () => DateTime.utc(2026, 1, 1, 10),
    );
  });
  tearDown(() => db.close());
  test('schema version 2 creates running tables', () async {
    expect(db.schemaVersion, 2);
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    expect(
      rows.map((r) => r.read<String>('name')),
      containsAll(['running_sessions', 'running_points']),
    );
  });
  test('run and ordered points persist transactionally', () async {
    final s = await local.start('user');
    await local.record(
      LocationPoint(
        localId: 'p1',
        runningSessionLocalId: s.localId,
        sequenceNumber: 0,
        latitude: 27,
        longitude: 85,
        horizontalAccuracy: 5,
        recordedAt: DateTime.utc(2026, 1, 1, 10),
        status: LocationPointStatus.accepted,
        distanceFromPreviousMeters: 12,
      ),
    );
    final saved = await local.get(s.localId);
    expect(saved!.distanceMeters, 12);
    expect(saved.routePoints.single.sequenceNumber, 0);
  });
  test(
    'point sequence duplicates are ignored and foreign key cascades',
    () async {
      final s = await local.start('user');
      LocationPoint p(String id) => LocationPoint(
        localId: id,
        runningSessionLocalId: s.localId,
        sequenceNumber: 0,
        latitude: 27,
        longitude: 85,
        horizontalAccuracy: 5,
        recordedAt: DateTime.utc(2026),
        status: LocationPointStatus.accepted,
      );
      await local.record(p('one'));
      await local.record(p('two'));
      expect((await RunningDao(db).points(s.localId)).length, 1);
      await (db.delete(
        db.runningSessions,
      )..where((r) => r.localId.equals(s.localId))).go();
      expect(await RunningDao(db).points(s.localId), isEmpty);
    },
  );
  test('finish is idempotent and makes local history available', () async {
    final s = await local.start('user');
    final a = await local.finish(s.localId);
    final b = await local.finish(s.localId);
    expect(a.localId, b.localId);
    expect((await local.dao.history('user')).length, 1);
  });
}
