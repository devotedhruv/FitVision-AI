import 'package:drift/drift.dart';

class RunningSessions extends Table {
  TextColumn get localId => text()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get accumulatedActiveDurationMs =>
      integer().withDefault(const Constant(0))();
  IntColumn get accumulatedPausedDurationMs =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get currentActiveSegmentStartedAt => dateTime().nullable()();
  DateTimeColumn get currentPauseStartedAt => dateTime().nullable()();
  RealColumn get totalDistanceMeters => real().withDefault(const Constant(0))();
  RealColumn get averageSpeedMps => real().nullable()();
  RealColumn get averagePaceSecondsPerKm => real().nullable()();
  RealColumn get elevationGainMeters => real().nullable()();
  IntColumn get acceptedPointCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get rejectedPointCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  IntColumn get recordVersion => integer().withDefault(const Constant(1))();
  @override
  Set<Column> get primaryKey => {localId};
}
