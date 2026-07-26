import 'package:drift/drift.dart';
import 'workout_sessions_table.dart';

class RepEvents extends Table {
  TextColumn get localId => text()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get workoutLocalId => text().references(
    WorkoutSessions,
    #localId,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get sequenceNumber => integer()();
  TextColumn get eventType => text()();
  TextColumn get exerciseType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get durationMs => integer()();
  BoolColumn get formValid => boolean()();
  RealColumn get minimumPrimaryAngle => real().nullable()();
  RealColumn get maximumPrimaryAngle => real().nullable()();
  TextColumn get feedbackCodesJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text()();
  IntColumn get recordVersion => integer().withDefault(const Constant(1))();
  @override
  Set<Column<Object>> get primaryKey => {localId};
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {workoutLocalId, sequenceNumber},
  ];
}
