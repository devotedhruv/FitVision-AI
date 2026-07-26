// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accumulatedActiveDurationMsMeta =
      const VerificationMeta('accumulatedActiveDurationMs');
  @override
  late final GeneratedColumn<int> accumulatedActiveDurationMs =
      GeneratedColumn<int>(
        'accumulated_active_duration_ms',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _currentActiveSegmentStartedAtMeta =
      const VerificationMeta('currentActiveSegmentStartedAt');
  @override
  late final GeneratedColumn<DateTime> currentActiveSegmentStartedAt =
      GeneratedColumn<DateTime>(
        'current_active_segment_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedRepCountMeta = const VerificationMeta(
    'completedRepCount',
  );
  @override
  late final GeneratedColumn<int> completedRepCount = GeneratedColumn<int>(
    'completed_rep_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incompleteRepCountMeta =
      const VerificationMeta('incompleteRepCount');
  @override
  late final GeneratedColumn<int> incompleteRepCount = GeneratedColumn<int>(
    'incomplete_rep_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _validFormRepCountMeta = const VerificationMeta(
    'validFormRepCount',
  );
  @override
  late final GeneratedColumn<int> validFormRepCount = GeneratedColumn<int>(
    'valid_form_rep_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalRepCountMeta = const VerificationMeta(
    'totalRepCount',
  );
  @override
  late final GeneratedColumn<int> totalRepCount = GeneratedColumn<int>(
    'total_rep_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _averageRepDurationMsMeta =
      const VerificationMeta('averageRepDurationMs');
  @override
  late final GeneratedColumn<int> averageRepDurationMs = GeneratedColumn<int>(
    'average_rep_duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formScoreMeta = const VerificationMeta(
    'formScore',
  );
  @override
  late final GeneratedColumn<double> formScore = GeneratedColumn<double>(
    'form_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordVersionMeta = const VerificationMeta(
    'recordVersion',
  );
  @override
  late final GeneratedColumn<int> recordVersion = GeneratedColumn<int>(
    'record_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    userId,
    exerciseType,
    status,
    startedAt,
    endedAt,
    accumulatedActiveDurationMs,
    currentActiveSegmentStartedAt,
    completedRepCount,
    incompleteRepCount,
    validFormRepCount,
    totalRepCount,
    averageRepDurationMs,
    formScore,
    summaryJson,
    createdAt,
    updatedAt,
    syncStatus,
    lastSyncedAt,
    recordVersion,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('accumulated_active_duration_ms')) {
      context.handle(
        _accumulatedActiveDurationMsMeta,
        accumulatedActiveDurationMs.isAcceptableOrUnknown(
          data['accumulated_active_duration_ms']!,
          _accumulatedActiveDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('current_active_segment_started_at')) {
      context.handle(
        _currentActiveSegmentStartedAtMeta,
        currentActiveSegmentStartedAt.isAcceptableOrUnknown(
          data['current_active_segment_started_at']!,
          _currentActiveSegmentStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('completed_rep_count')) {
      context.handle(
        _completedRepCountMeta,
        completedRepCount.isAcceptableOrUnknown(
          data['completed_rep_count']!,
          _completedRepCountMeta,
        ),
      );
    }
    if (data.containsKey('incomplete_rep_count')) {
      context.handle(
        _incompleteRepCountMeta,
        incompleteRepCount.isAcceptableOrUnknown(
          data['incomplete_rep_count']!,
          _incompleteRepCountMeta,
        ),
      );
    }
    if (data.containsKey('valid_form_rep_count')) {
      context.handle(
        _validFormRepCountMeta,
        validFormRepCount.isAcceptableOrUnknown(
          data['valid_form_rep_count']!,
          _validFormRepCountMeta,
        ),
      );
    }
    if (data.containsKey('total_rep_count')) {
      context.handle(
        _totalRepCountMeta,
        totalRepCount.isAcceptableOrUnknown(
          data['total_rep_count']!,
          _totalRepCountMeta,
        ),
      );
    }
    if (data.containsKey('average_rep_duration_ms')) {
      context.handle(
        _averageRepDurationMsMeta,
        averageRepDurationMs.isAcceptableOrUnknown(
          data['average_rep_duration_ms']!,
          _averageRepDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('form_score')) {
      context.handle(
        _formScoreMeta,
        formScore.isAcceptableOrUnknown(data['form_score']!, _formScoreMeta),
      );
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('record_version')) {
      context.handle(
        _recordVersionMeta,
        recordVersion.isAcceptableOrUnknown(
          data['record_version']!,
          _recordVersionMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, localId},
  ];
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      accumulatedActiveDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accumulated_active_duration_ms'],
      )!,
      currentActiveSegmentStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}current_active_segment_started_at'],
      ),
      completedRepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_rep_count'],
      )!,
      incompleteRepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incomplete_rep_count'],
      )!,
      validFormRepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_form_rep_count'],
      )!,
      totalRepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_rep_count'],
      )!,
      averageRepDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_rep_duration_ms'],
      ),
      formScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}form_score'],
      ),
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      recordVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_version'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String localId;
  final String? remoteId;
  final String userId;
  final String exerciseType;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int accumulatedActiveDurationMs;
  final DateTime? currentActiveSegmentStartedAt;
  final int completedRepCount;
  final int incompleteRepCount;
  final int validFormRepCount;
  final int totalRepCount;
  final int? averageRepDurationMs;
  final double? formScore;
  final String? summaryJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final int recordVersion;
  final DateTime? deletedAt;
  const WorkoutSession({
    required this.localId,
    this.remoteId,
    required this.userId,
    required this.exerciseType,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.accumulatedActiveDurationMs,
    this.currentActiveSegmentStartedAt,
    required this.completedRepCount,
    required this.incompleteRepCount,
    required this.validFormRepCount,
    required this.totalRepCount,
    this.averageRepDurationMs,
    this.formScore,
    this.summaryJson,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.lastSyncedAt,
    required this.recordVersion,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['user_id'] = Variable<String>(userId);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['accumulated_active_duration_ms'] = Variable<int>(
      accumulatedActiveDurationMs,
    );
    if (!nullToAbsent || currentActiveSegmentStartedAt != null) {
      map['current_active_segment_started_at'] = Variable<DateTime>(
        currentActiveSegmentStartedAt,
      );
    }
    map['completed_rep_count'] = Variable<int>(completedRepCount);
    map['incomplete_rep_count'] = Variable<int>(incompleteRepCount);
    map['valid_form_rep_count'] = Variable<int>(validFormRepCount);
    map['total_rep_count'] = Variable<int>(totalRepCount);
    if (!nullToAbsent || averageRepDurationMs != null) {
      map['average_rep_duration_ms'] = Variable<int>(averageRepDurationMs);
    }
    if (!nullToAbsent || formScore != null) {
      map['form_score'] = Variable<double>(formScore);
    }
    if (!nullToAbsent || summaryJson != null) {
      map['summary_json'] = Variable<String>(summaryJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['record_version'] = Variable<int>(recordVersion);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      userId: Value(userId),
      exerciseType: Value(exerciseType),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      accumulatedActiveDurationMs: Value(accumulatedActiveDurationMs),
      currentActiveSegmentStartedAt:
          currentActiveSegmentStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(currentActiveSegmentStartedAt),
      completedRepCount: Value(completedRepCount),
      incompleteRepCount: Value(incompleteRepCount),
      validFormRepCount: Value(validFormRepCount),
      totalRepCount: Value(totalRepCount),
      averageRepDurationMs: averageRepDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(averageRepDurationMs),
      formScore: formScore == null && nullToAbsent
          ? const Value.absent()
          : Value(formScore),
      summaryJson: summaryJson == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      recordVersion: Value(recordVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      userId: serializer.fromJson<String>(json['userId']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      accumulatedActiveDurationMs: serializer.fromJson<int>(
        json['accumulatedActiveDurationMs'],
      ),
      currentActiveSegmentStartedAt: serializer.fromJson<DateTime?>(
        json['currentActiveSegmentStartedAt'],
      ),
      completedRepCount: serializer.fromJson<int>(json['completedRepCount']),
      incompleteRepCount: serializer.fromJson<int>(json['incompleteRepCount']),
      validFormRepCount: serializer.fromJson<int>(json['validFormRepCount']),
      totalRepCount: serializer.fromJson<int>(json['totalRepCount']),
      averageRepDurationMs: serializer.fromJson<int?>(
        json['averageRepDurationMs'],
      ),
      formScore: serializer.fromJson<double?>(json['formScore']),
      summaryJson: serializer.fromJson<String?>(json['summaryJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      recordVersion: serializer.fromJson<int>(json['recordVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'userId': serializer.toJson<String>(userId),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'accumulatedActiveDurationMs': serializer.toJson<int>(
        accumulatedActiveDurationMs,
      ),
      'currentActiveSegmentStartedAt': serializer.toJson<DateTime?>(
        currentActiveSegmentStartedAt,
      ),
      'completedRepCount': serializer.toJson<int>(completedRepCount),
      'incompleteRepCount': serializer.toJson<int>(incompleteRepCount),
      'validFormRepCount': serializer.toJson<int>(validFormRepCount),
      'totalRepCount': serializer.toJson<int>(totalRepCount),
      'averageRepDurationMs': serializer.toJson<int?>(averageRepDurationMs),
      'formScore': serializer.toJson<double?>(formScore),
      'summaryJson': serializer.toJson<String?>(summaryJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'recordVersion': serializer.toJson<int>(recordVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  WorkoutSession copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? userId,
    String? exerciseType,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? accumulatedActiveDurationMs,
    Value<DateTime?> currentActiveSegmentStartedAt = const Value.absent(),
    int? completedRepCount,
    int? incompleteRepCount,
    int? validFormRepCount,
    int? totalRepCount,
    Value<int?> averageRepDurationMs = const Value.absent(),
    Value<double?> formScore = const Value.absent(),
    Value<String?> summaryJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    int? recordVersion,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => WorkoutSession(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    userId: userId ?? this.userId,
    exerciseType: exerciseType ?? this.exerciseType,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    accumulatedActiveDurationMs:
        accumulatedActiveDurationMs ?? this.accumulatedActiveDurationMs,
    currentActiveSegmentStartedAt: currentActiveSegmentStartedAt.present
        ? currentActiveSegmentStartedAt.value
        : this.currentActiveSegmentStartedAt,
    completedRepCount: completedRepCount ?? this.completedRepCount,
    incompleteRepCount: incompleteRepCount ?? this.incompleteRepCount,
    validFormRepCount: validFormRepCount ?? this.validFormRepCount,
    totalRepCount: totalRepCount ?? this.totalRepCount,
    averageRepDurationMs: averageRepDurationMs.present
        ? averageRepDurationMs.value
        : this.averageRepDurationMs,
    formScore: formScore.present ? formScore.value : this.formScore,
    summaryJson: summaryJson.present ? summaryJson.value : this.summaryJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    recordVersion: recordVersion ?? this.recordVersion,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      userId: data.userId.present ? data.userId.value : this.userId,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      accumulatedActiveDurationMs: data.accumulatedActiveDurationMs.present
          ? data.accumulatedActiveDurationMs.value
          : this.accumulatedActiveDurationMs,
      currentActiveSegmentStartedAt: data.currentActiveSegmentStartedAt.present
          ? data.currentActiveSegmentStartedAt.value
          : this.currentActiveSegmentStartedAt,
      completedRepCount: data.completedRepCount.present
          ? data.completedRepCount.value
          : this.completedRepCount,
      incompleteRepCount: data.incompleteRepCount.present
          ? data.incompleteRepCount.value
          : this.incompleteRepCount,
      validFormRepCount: data.validFormRepCount.present
          ? data.validFormRepCount.value
          : this.validFormRepCount,
      totalRepCount: data.totalRepCount.present
          ? data.totalRepCount.value
          : this.totalRepCount,
      averageRepDurationMs: data.averageRepDurationMs.present
          ? data.averageRepDurationMs.value
          : this.averageRepDurationMs,
      formScore: data.formScore.present ? data.formScore.value : this.formScore,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      recordVersion: data.recordVersion.present
          ? data.recordVersion.value
          : this.recordVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('userId: $userId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('accumulatedActiveDurationMs: $accumulatedActiveDurationMs, ')
          ..write(
            'currentActiveSegmentStartedAt: $currentActiveSegmentStartedAt, ',
          )
          ..write('completedRepCount: $completedRepCount, ')
          ..write('incompleteRepCount: $incompleteRepCount, ')
          ..write('validFormRepCount: $validFormRepCount, ')
          ..write('totalRepCount: $totalRepCount, ')
          ..write('averageRepDurationMs: $averageRepDurationMs, ')
          ..write('formScore: $formScore, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('recordVersion: $recordVersion, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    remoteId,
    userId,
    exerciseType,
    status,
    startedAt,
    endedAt,
    accumulatedActiveDurationMs,
    currentActiveSegmentStartedAt,
    completedRepCount,
    incompleteRepCount,
    validFormRepCount,
    totalRepCount,
    averageRepDurationMs,
    formScore,
    summaryJson,
    createdAt,
    updatedAt,
    syncStatus,
    lastSyncedAt,
    recordVersion,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.userId == this.userId &&
          other.exerciseType == this.exerciseType &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.accumulatedActiveDurationMs ==
              this.accumulatedActiveDurationMs &&
          other.currentActiveSegmentStartedAt ==
              this.currentActiveSegmentStartedAt &&
          other.completedRepCount == this.completedRepCount &&
          other.incompleteRepCount == this.incompleteRepCount &&
          other.validFormRepCount == this.validFormRepCount &&
          other.totalRepCount == this.totalRepCount &&
          other.averageRepDurationMs == this.averageRepDurationMs &&
          other.formScore == this.formScore &&
          other.summaryJson == this.summaryJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.recordVersion == this.recordVersion &&
          other.deletedAt == this.deletedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> userId;
  final Value<String> exerciseType;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> accumulatedActiveDurationMs;
  final Value<DateTime?> currentActiveSegmentStartedAt;
  final Value<int> completedRepCount;
  final Value<int> incompleteRepCount;
  final Value<int> validFormRepCount;
  final Value<int> totalRepCount;
  final Value<int?> averageRepDurationMs;
  final Value<double?> formScore;
  final Value<String?> summaryJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> recordVersion;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.userId = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.accumulatedActiveDurationMs = const Value.absent(),
    this.currentActiveSegmentStartedAt = const Value.absent(),
    this.completedRepCount = const Value.absent(),
    this.incompleteRepCount = const Value.absent(),
    this.validFormRepCount = const Value.absent(),
    this.totalRepCount = const Value.absent(),
    this.averageRepDurationMs = const Value.absent(),
    this.formScore = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.recordVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String localId,
    this.remoteId = const Value.absent(),
    required String userId,
    required String exerciseType,
    required String status,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.accumulatedActiveDurationMs = const Value.absent(),
    this.currentActiveSegmentStartedAt = const Value.absent(),
    this.completedRepCount = const Value.absent(),
    this.incompleteRepCount = const Value.absent(),
    this.validFormRepCount = const Value.absent(),
    this.totalRepCount = const Value.absent(),
    this.averageRepDurationMs = const Value.absent(),
    this.formScore = const Value.absent(),
    this.summaryJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String syncStatus,
    this.lastSyncedAt = const Value.absent(),
    this.recordVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       exerciseType = Value(exerciseType),
       status = Value(status),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus);
  static Insertable<WorkoutSession> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? userId,
    Expression<String>? exerciseType,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? accumulatedActiveDurationMs,
    Expression<DateTime>? currentActiveSegmentStartedAt,
    Expression<int>? completedRepCount,
    Expression<int>? incompleteRepCount,
    Expression<int>? validFormRepCount,
    Expression<int>? totalRepCount,
    Expression<int>? averageRepDurationMs,
    Expression<double>? formScore,
    Expression<String>? summaryJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? recordVersion,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (userId != null) 'user_id': userId,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (accumulatedActiveDurationMs != null)
        'accumulated_active_duration_ms': accumulatedActiveDurationMs,
      if (currentActiveSegmentStartedAt != null)
        'current_active_segment_started_at': currentActiveSegmentStartedAt,
      if (completedRepCount != null) 'completed_rep_count': completedRepCount,
      if (incompleteRepCount != null)
        'incomplete_rep_count': incompleteRepCount,
      if (validFormRepCount != null) 'valid_form_rep_count': validFormRepCount,
      if (totalRepCount != null) 'total_rep_count': totalRepCount,
      if (averageRepDurationMs != null)
        'average_rep_duration_ms': averageRepDurationMs,
      if (formScore != null) 'form_score': formScore,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (recordVersion != null) 'record_version': recordVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? userId,
    Value<String>? exerciseType,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? accumulatedActiveDurationMs,
    Value<DateTime?>? currentActiveSegmentStartedAt,
    Value<int>? completedRepCount,
    Value<int>? incompleteRepCount,
    Value<int>? validFormRepCount,
    Value<int>? totalRepCount,
    Value<int?>? averageRepDurationMs,
    Value<double?>? formScore,
    Value<String?>? summaryJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? recordVersion,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      exerciseType: exerciseType ?? this.exerciseType,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      accumulatedActiveDurationMs:
          accumulatedActiveDurationMs ?? this.accumulatedActiveDurationMs,
      currentActiveSegmentStartedAt:
          currentActiveSegmentStartedAt ?? this.currentActiveSegmentStartedAt,
      completedRepCount: completedRepCount ?? this.completedRepCount,
      incompleteRepCount: incompleteRepCount ?? this.incompleteRepCount,
      validFormRepCount: validFormRepCount ?? this.validFormRepCount,
      totalRepCount: totalRepCount ?? this.totalRepCount,
      averageRepDurationMs: averageRepDurationMs ?? this.averageRepDurationMs,
      formScore: formScore ?? this.formScore,
      summaryJson: summaryJson ?? this.summaryJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      recordVersion: recordVersion ?? this.recordVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (accumulatedActiveDurationMs.present) {
      map['accumulated_active_duration_ms'] = Variable<int>(
        accumulatedActiveDurationMs.value,
      );
    }
    if (currentActiveSegmentStartedAt.present) {
      map['current_active_segment_started_at'] = Variable<DateTime>(
        currentActiveSegmentStartedAt.value,
      );
    }
    if (completedRepCount.present) {
      map['completed_rep_count'] = Variable<int>(completedRepCount.value);
    }
    if (incompleteRepCount.present) {
      map['incomplete_rep_count'] = Variable<int>(incompleteRepCount.value);
    }
    if (validFormRepCount.present) {
      map['valid_form_rep_count'] = Variable<int>(validFormRepCount.value);
    }
    if (totalRepCount.present) {
      map['total_rep_count'] = Variable<int>(totalRepCount.value);
    }
    if (averageRepDurationMs.present) {
      map['average_rep_duration_ms'] = Variable<int>(
        averageRepDurationMs.value,
      );
    }
    if (formScore.present) {
      map['form_score'] = Variable<double>(formScore.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (recordVersion.present) {
      map['record_version'] = Variable<int>(recordVersion.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('userId: $userId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('accumulatedActiveDurationMs: $accumulatedActiveDurationMs, ')
          ..write(
            'currentActiveSegmentStartedAt: $currentActiveSegmentStartedAt, ',
          )
          ..write('completedRepCount: $completedRepCount, ')
          ..write('incompleteRepCount: $incompleteRepCount, ')
          ..write('validFormRepCount: $validFormRepCount, ')
          ..write('totalRepCount: $totalRepCount, ')
          ..write('averageRepDurationMs: $averageRepDurationMs, ')
          ..write('formScore: $formScore, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('recordVersion: $recordVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepEventsTable extends RepEvents
    with TableInfo<$RepEventsTable, RepEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutLocalIdMeta = const VerificationMeta(
    'workoutLocalId',
  );
  @override
  late final GeneratedColumn<String> workoutLocalId = GeneratedColumn<String>(
    'workout_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (local_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sequenceNumberMeta = const VerificationMeta(
    'sequenceNumber',
  );
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
    'sequence_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formValidMeta = const VerificationMeta(
    'formValid',
  );
  @override
  late final GeneratedColumn<bool> formValid = GeneratedColumn<bool>(
    'form_valid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("form_valid" IN (0, 1))',
    ),
  );
  static const VerificationMeta _minimumPrimaryAngleMeta =
      const VerificationMeta('minimumPrimaryAngle');
  @override
  late final GeneratedColumn<double> minimumPrimaryAngle =
      GeneratedColumn<double>(
        'minimum_primary_angle',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _maximumPrimaryAngleMeta =
      const VerificationMeta('maximumPrimaryAngle');
  @override
  late final GeneratedColumn<double> maximumPrimaryAngle =
      GeneratedColumn<double>(
        'maximum_primary_angle',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _feedbackCodesJsonMeta = const VerificationMeta(
    'feedbackCodesJson',
  );
  @override
  late final GeneratedColumn<String> feedbackCodesJson =
      GeneratedColumn<String>(
        'feedback_codes_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordVersionMeta = const VerificationMeta(
    'recordVersion',
  );
  @override
  late final GeneratedColumn<int> recordVersion = GeneratedColumn<int>(
    'record_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    workoutLocalId,
    sequenceNumber,
    eventType,
    exerciseType,
    startedAt,
    endedAt,
    durationMs,
    formValid,
    minimumPrimaryAngle,
    maximumPrimaryAngle,
    feedbackCodesJson,
    createdAt,
    syncStatus,
    recordVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rep_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('workout_local_id')) {
      context.handle(
        _workoutLocalIdMeta,
        workoutLocalId.isAcceptableOrUnknown(
          data['workout_local_id']!,
          _workoutLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutLocalIdMeta);
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
        _sequenceNumberMeta,
        sequenceNumber.isAcceptableOrUnknown(
          data['sequence_number']!,
          _sequenceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceNumberMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('form_valid')) {
      context.handle(
        _formValidMeta,
        formValid.isAcceptableOrUnknown(data['form_valid']!, _formValidMeta),
      );
    } else if (isInserting) {
      context.missing(_formValidMeta);
    }
    if (data.containsKey('minimum_primary_angle')) {
      context.handle(
        _minimumPrimaryAngleMeta,
        minimumPrimaryAngle.isAcceptableOrUnknown(
          data['minimum_primary_angle']!,
          _minimumPrimaryAngleMeta,
        ),
      );
    }
    if (data.containsKey('maximum_primary_angle')) {
      context.handle(
        _maximumPrimaryAngleMeta,
        maximumPrimaryAngle.isAcceptableOrUnknown(
          data['maximum_primary_angle']!,
          _maximumPrimaryAngleMeta,
        ),
      );
    }
    if (data.containsKey('feedback_codes_json')) {
      context.handle(
        _feedbackCodesJsonMeta,
        feedbackCodesJson.isAcceptableOrUnknown(
          data['feedback_codes_json']!,
          _feedbackCodesJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('record_version')) {
      context.handle(
        _recordVersionMeta,
        recordVersion.isAcceptableOrUnknown(
          data['record_version']!,
          _recordVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutLocalId, sequenceNumber},
  ];
  @override
  RepEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepEvent(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      workoutLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_local_id'],
      )!,
      sequenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_number'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      formValid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}form_valid'],
      )!,
      minimumPrimaryAngle: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}minimum_primary_angle'],
      ),
      maximumPrimaryAngle: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}maximum_primary_angle'],
      ),
      feedbackCodesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback_codes_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      recordVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_version'],
      )!,
    );
  }

  @override
  $RepEventsTable createAlias(String alias) {
    return $RepEventsTable(attachedDatabase, alias);
  }
}

class RepEvent extends DataClass implements Insertable<RepEvent> {
  final String localId;
  final String? remoteId;
  final String workoutLocalId;
  final int sequenceNumber;
  final String eventType;
  final String exerciseType;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMs;
  final bool formValid;
  final double? minimumPrimaryAngle;
  final double? maximumPrimaryAngle;
  final String? feedbackCodesJson;
  final DateTime createdAt;
  final String syncStatus;
  final int recordVersion;
  const RepEvent({
    required this.localId,
    this.remoteId,
    required this.workoutLocalId,
    required this.sequenceNumber,
    required this.eventType,
    required this.exerciseType,
    required this.startedAt,
    required this.endedAt,
    required this.durationMs,
    required this.formValid,
    this.minimumPrimaryAngle,
    this.maximumPrimaryAngle,
    this.feedbackCodesJson,
    required this.createdAt,
    required this.syncStatus,
    required this.recordVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['workout_local_id'] = Variable<String>(workoutLocalId);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    map['event_type'] = Variable<String>(eventType);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_ms'] = Variable<int>(durationMs);
    map['form_valid'] = Variable<bool>(formValid);
    if (!nullToAbsent || minimumPrimaryAngle != null) {
      map['minimum_primary_angle'] = Variable<double>(minimumPrimaryAngle);
    }
    if (!nullToAbsent || maximumPrimaryAngle != null) {
      map['maximum_primary_angle'] = Variable<double>(maximumPrimaryAngle);
    }
    if (!nullToAbsent || feedbackCodesJson != null) {
      map['feedback_codes_json'] = Variable<String>(feedbackCodesJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['record_version'] = Variable<int>(recordVersion);
    return map;
  }

  RepEventsCompanion toCompanion(bool nullToAbsent) {
    return RepEventsCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      workoutLocalId: Value(workoutLocalId),
      sequenceNumber: Value(sequenceNumber),
      eventType: Value(eventType),
      exerciseType: Value(exerciseType),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationMs: Value(durationMs),
      formValid: Value(formValid),
      minimumPrimaryAngle: minimumPrimaryAngle == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumPrimaryAngle),
      maximumPrimaryAngle: maximumPrimaryAngle == null && nullToAbsent
          ? const Value.absent()
          : Value(maximumPrimaryAngle),
      feedbackCodesJson: feedbackCodesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(feedbackCodesJson),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      recordVersion: Value(recordVersion),
    );
  }

  factory RepEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepEvent(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      workoutLocalId: serializer.fromJson<String>(json['workoutLocalId']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      eventType: serializer.fromJson<String>(json['eventType']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      formValid: serializer.fromJson<bool>(json['formValid']),
      minimumPrimaryAngle: serializer.fromJson<double?>(
        json['minimumPrimaryAngle'],
      ),
      maximumPrimaryAngle: serializer.fromJson<double?>(
        json['maximumPrimaryAngle'],
      ),
      feedbackCodesJson: serializer.fromJson<String?>(
        json['feedbackCodesJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      recordVersion: serializer.fromJson<int>(json['recordVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'workoutLocalId': serializer.toJson<String>(workoutLocalId),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'eventType': serializer.toJson<String>(eventType),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'formValid': serializer.toJson<bool>(formValid),
      'minimumPrimaryAngle': serializer.toJson<double?>(minimumPrimaryAngle),
      'maximumPrimaryAngle': serializer.toJson<double?>(maximumPrimaryAngle),
      'feedbackCodesJson': serializer.toJson<String?>(feedbackCodesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'recordVersion': serializer.toJson<int>(recordVersion),
    };
  }

  RepEvent copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? workoutLocalId,
    int? sequenceNumber,
    String? eventType,
    String? exerciseType,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationMs,
    bool? formValid,
    Value<double?> minimumPrimaryAngle = const Value.absent(),
    Value<double?> maximumPrimaryAngle = const Value.absent(),
    Value<String?> feedbackCodesJson = const Value.absent(),
    DateTime? createdAt,
    String? syncStatus,
    int? recordVersion,
  }) => RepEvent(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    workoutLocalId: workoutLocalId ?? this.workoutLocalId,
    sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    eventType: eventType ?? this.eventType,
    exerciseType: exerciseType ?? this.exerciseType,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationMs: durationMs ?? this.durationMs,
    formValid: formValid ?? this.formValid,
    minimumPrimaryAngle: minimumPrimaryAngle.present
        ? minimumPrimaryAngle.value
        : this.minimumPrimaryAngle,
    maximumPrimaryAngle: maximumPrimaryAngle.present
        ? maximumPrimaryAngle.value
        : this.maximumPrimaryAngle,
    feedbackCodesJson: feedbackCodesJson.present
        ? feedbackCodesJson.value
        : this.feedbackCodesJson,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    recordVersion: recordVersion ?? this.recordVersion,
  );
  RepEvent copyWithCompanion(RepEventsCompanion data) {
    return RepEvent(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      workoutLocalId: data.workoutLocalId.present
          ? data.workoutLocalId.value
          : this.workoutLocalId,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      formValid: data.formValid.present ? data.formValid.value : this.formValid,
      minimumPrimaryAngle: data.minimumPrimaryAngle.present
          ? data.minimumPrimaryAngle.value
          : this.minimumPrimaryAngle,
      maximumPrimaryAngle: data.maximumPrimaryAngle.present
          ? data.maximumPrimaryAngle.value
          : this.maximumPrimaryAngle,
      feedbackCodesJson: data.feedbackCodesJson.present
          ? data.feedbackCodesJson.value
          : this.feedbackCodesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      recordVersion: data.recordVersion.present
          ? data.recordVersion.value
          : this.recordVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepEvent(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('workoutLocalId: $workoutLocalId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('eventType: $eventType, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('formValid: $formValid, ')
          ..write('minimumPrimaryAngle: $minimumPrimaryAngle, ')
          ..write('maximumPrimaryAngle: $maximumPrimaryAngle, ')
          ..write('feedbackCodesJson: $feedbackCodesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('recordVersion: $recordVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    workoutLocalId,
    sequenceNumber,
    eventType,
    exerciseType,
    startedAt,
    endedAt,
    durationMs,
    formValid,
    minimumPrimaryAngle,
    maximumPrimaryAngle,
    feedbackCodesJson,
    createdAt,
    syncStatus,
    recordVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepEvent &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.workoutLocalId == this.workoutLocalId &&
          other.sequenceNumber == this.sequenceNumber &&
          other.eventType == this.eventType &&
          other.exerciseType == this.exerciseType &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMs == this.durationMs &&
          other.formValid == this.formValid &&
          other.minimumPrimaryAngle == this.minimumPrimaryAngle &&
          other.maximumPrimaryAngle == this.maximumPrimaryAngle &&
          other.feedbackCodesJson == this.feedbackCodesJson &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.recordVersion == this.recordVersion);
}

class RepEventsCompanion extends UpdateCompanion<RepEvent> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> workoutLocalId;
  final Value<int> sequenceNumber;
  final Value<String> eventType;
  final Value<String> exerciseType;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationMs;
  final Value<bool> formValid;
  final Value<double?> minimumPrimaryAngle;
  final Value<double?> maximumPrimaryAngle;
  final Value<String?> feedbackCodesJson;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> recordVersion;
  final Value<int> rowid;
  const RepEventsCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.workoutLocalId = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.eventType = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.formValid = const Value.absent(),
    this.minimumPrimaryAngle = const Value.absent(),
    this.maximumPrimaryAngle = const Value.absent(),
    this.feedbackCodesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepEventsCompanion.insert({
    required String localId,
    this.remoteId = const Value.absent(),
    required String workoutLocalId,
    required int sequenceNumber,
    required String eventType,
    required String exerciseType,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationMs,
    required bool formValid,
    this.minimumPrimaryAngle = const Value.absent(),
    this.maximumPrimaryAngle = const Value.absent(),
    this.feedbackCodesJson = const Value.absent(),
    required DateTime createdAt,
    required String syncStatus,
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       workoutLocalId = Value(workoutLocalId),
       sequenceNumber = Value(sequenceNumber),
       eventType = Value(eventType),
       exerciseType = Value(exerciseType),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationMs = Value(durationMs),
       formValid = Value(formValid),
       createdAt = Value(createdAt),
       syncStatus = Value(syncStatus);
  static Insertable<RepEvent> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? workoutLocalId,
    Expression<int>? sequenceNumber,
    Expression<String>? eventType,
    Expression<String>? exerciseType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMs,
    Expression<bool>? formValid,
    Expression<double>? minimumPrimaryAngle,
    Expression<double>? maximumPrimaryAngle,
    Expression<String>? feedbackCodesJson,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? recordVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (workoutLocalId != null) 'workout_local_id': workoutLocalId,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (eventType != null) 'event_type': eventType,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (formValid != null) 'form_valid': formValid,
      if (minimumPrimaryAngle != null)
        'minimum_primary_angle': minimumPrimaryAngle,
      if (maximumPrimaryAngle != null)
        'maximum_primary_angle': maximumPrimaryAngle,
      if (feedbackCodesJson != null) 'feedback_codes_json': feedbackCodesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (recordVersion != null) 'record_version': recordVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepEventsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? workoutLocalId,
    Value<int>? sequenceNumber,
    Value<String>? eventType,
    Value<String>? exerciseType,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationMs,
    Value<bool>? formValid,
    Value<double?>? minimumPrimaryAngle,
    Value<double?>? maximumPrimaryAngle,
    Value<String?>? feedbackCodesJson,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? recordVersion,
    Value<int>? rowid,
  }) {
    return RepEventsCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      workoutLocalId: workoutLocalId ?? this.workoutLocalId,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      eventType: eventType ?? this.eventType,
      exerciseType: exerciseType ?? this.exerciseType,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMs: durationMs ?? this.durationMs,
      formValid: formValid ?? this.formValid,
      minimumPrimaryAngle: minimumPrimaryAngle ?? this.minimumPrimaryAngle,
      maximumPrimaryAngle: maximumPrimaryAngle ?? this.maximumPrimaryAngle,
      feedbackCodesJson: feedbackCodesJson ?? this.feedbackCodesJson,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      recordVersion: recordVersion ?? this.recordVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (workoutLocalId.present) {
      map['workout_local_id'] = Variable<String>(workoutLocalId.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (formValid.present) {
      map['form_valid'] = Variable<bool>(formValid.value);
    }
    if (minimumPrimaryAngle.present) {
      map['minimum_primary_angle'] = Variable<double>(
        minimumPrimaryAngle.value,
      );
    }
    if (maximumPrimaryAngle.present) {
      map['maximum_primary_angle'] = Variable<double>(
        maximumPrimaryAngle.value,
      );
    }
    if (feedbackCodesJson.present) {
      map['feedback_codes_json'] = Variable<String>(feedbackCodesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (recordVersion.present) {
      map['record_version'] = Variable<int>(recordVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepEventsCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('workoutLocalId: $workoutLocalId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('eventType: $eventType, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('formValid: $formValid, ')
          ..write('minimumPrimaryAngle: $minimumPrimaryAngle, ')
          ..write('maximumPrimaryAngle: $maximumPrimaryAngle, ')
          ..write('feedbackCodesJson: $feedbackCodesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('recordVersion: $recordVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityLocalIdMeta = const VerificationMeta(
    'entityLocalId',
  );
  @override
  late final GeneratedColumn<String> entityLocalId = GeneratedColumn<String>(
    'entity_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorCodeMeta = const VerificationMeta(
    'lastErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastErrorCode = GeneratedColumn<String>(
    'last_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMessageMeta = const VerificationMeta(
    'lastErrorMessage',
  );
  @override
  late final GeneratedColumn<String> lastErrorMessage = GeneratedColumn<String>(
    'last_error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityLocalId,
    operation,
    payloadJson,
    status,
    attemptCount,
    nextAttemptAt,
    lastAttemptAt,
    lastErrorCode,
    lastErrorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_local_id')) {
      context.handle(
        _entityLocalIdMeta,
        entityLocalId.isAcceptableOrUnknown(
          data['entity_local_id']!,
          _entityLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityLocalIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error_code')) {
      context.handle(
        _lastErrorCodeMeta,
        lastErrorCode.isAcceptableOrUnknown(
          data['last_error_code']!,
          _lastErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('last_error_message')) {
      context.handle(
        _lastErrorMessageMeta,
        lastErrorMessage.isAcceptableOrUnknown(
          data['last_error_message']!,
          _lastErrorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entityType, entityLocalId, operation},
  ];
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_local_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      lastErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_code'],
      ),
      lastErrorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final String id;
  final String entityType;
  final String entityLocalId;
  final String operation;
  final String payloadJson;
  final String status;
  final int attemptCount;
  final DateTime nextAttemptAt;
  final DateTime? lastAttemptAt;
  final String? lastErrorCode;
  final String? lastErrorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityLocalId,
    required this.operation,
    required this.payloadJson,
    required this.status,
    required this.attemptCount,
    required this.nextAttemptAt,
    this.lastAttemptAt,
    this.lastErrorCode,
    this.lastErrorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_local_id'] = Variable<String>(entityLocalId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || lastErrorCode != null) {
      map['last_error_code'] = Variable<String>(lastErrorCode);
    }
    if (!nullToAbsent || lastErrorMessage != null) {
      map['last_error_message'] = Variable<String>(lastErrorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityLocalId: Value(entityLocalId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextAttemptAt: Value(nextAttemptAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      lastErrorCode: lastErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCode),
      lastErrorMessage: lastErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityLocalId: serializer.fromJson<String>(json['entityLocalId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      lastErrorCode: serializer.fromJson<String?>(json['lastErrorCode']),
      lastErrorMessage: serializer.fromJson<String?>(json['lastErrorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityLocalId': serializer.toJson<String>(entityLocalId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'lastErrorCode': serializer.toJson<String?>(lastErrorCode),
      'lastErrorMessage': serializer.toJson<String?>(lastErrorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueItem copyWith({
    String? id,
    String? entityType,
    String? entityLocalId,
    String? operation,
    String? payloadJson,
    String? status,
    int? attemptCount,
    DateTime? nextAttemptAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<String?> lastErrorCode = const Value.absent(),
    Value<String?> lastErrorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueItem(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityLocalId: entityLocalId ?? this.entityLocalId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    lastErrorCode: lastErrorCode.present
        ? lastErrorCode.value
        : this.lastErrorCode,
    lastErrorMessage: lastErrorMessage.present
        ? lastErrorMessage.value
        : this.lastErrorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityLocalId: data.entityLocalId.present
          ? data.entityLocalId.value
          : this.entityLocalId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      lastErrorCode: data.lastErrorCode.present
          ? data.lastErrorCode.value
          : this.lastErrorCode,
      lastErrorMessage: data.lastErrorMessage.present
          ? data.lastErrorMessage.value
          : this.lastErrorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityLocalId,
    operation,
    payloadJson,
    status,
    attemptCount,
    nextAttemptAt,
    lastAttemptAt,
    lastErrorCode,
    lastErrorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityLocalId == this.entityLocalId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastErrorCode == this.lastErrorCode &&
          other.lastErrorMessage == this.lastErrorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityLocalId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<DateTime> nextAttemptAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> lastErrorCode;
  final Value<String?> lastErrorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityLocalId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    required String id,
    required String entityType,
    required String entityLocalId,
    required String operation,
    required String payloadJson,
    required String status,
    this.attemptCount = const Value.absent(),
    required DateTime nextAttemptAt,
    this.lastAttemptAt = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityLocalId = Value(entityLocalId),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       status = Value(status),
       nextAttemptAt = Value(nextAttemptAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncQueueItem> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityLocalId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextAttemptAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? lastErrorCode,
    Expression<String>? lastErrorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityLocalId != null) 'entity_local_id': entityLocalId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (lastErrorCode != null) 'last_error_code': lastErrorCode,
      if (lastErrorMessage != null) 'last_error_message': lastErrorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityLocalId,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<DateTime>? nextAttemptAt,
    Value<DateTime?>? lastAttemptAt,
    Value<String?>? lastErrorCode,
    Value<String?>? lastErrorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityLocalId: entityLocalId ?? this.entityLocalId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityLocalId.present) {
      map['entity_local_id'] = Variable<String>(entityLocalId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (lastErrorCode.present) {
      map['last_error_code'] = Variable<String>(lastErrorCode.value);
    }
    if (lastErrorMessage.present) {
      map['last_error_message'] = Variable<String>(lastErrorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $RepEventsTable repEvents = $RepEventsTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    repEvents,
    syncQueueItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rep_events', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String localId,
      Value<String?> remoteId,
      required String userId,
      required String exerciseType,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> accumulatedActiveDurationMs,
      Value<DateTime?> currentActiveSegmentStartedAt,
      Value<int> completedRepCount,
      Value<int> incompleteRepCount,
      Value<int> validFormRepCount,
      Value<int> totalRepCount,
      Value<int?> averageRepDurationMs,
      Value<double?> formScore,
      Value<String?> summaryJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> recordVersion,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> userId,
      Value<String> exerciseType,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> accumulatedActiveDurationMs,
      Value<DateTime?> currentActiveSegmentStartedAt,
      Value<int> completedRepCount,
      Value<int> incompleteRepCount,
      Value<int> validFormRepCount,
      Value<int> totalRepCount,
      Value<int?> averageRepDurationMs,
      Value<double?> formScore,
      Value<String?> summaryJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> recordVersion,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$LocalDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RepEventsTable, List<RepEvent>>
  _repEventsRefsTable(_$LocalDatabase db) => MultiTypedResultKey.fromTable(
    db.repEvents,
    aliasName: 'workout_sessions__local_id__rep_events__workout_local_id',
  );

  $$RepEventsTableProcessedTableManager get repEventsRefs {
    final manager = $$RepEventsTableTableManager($_db, $_db.repEvents).filter(
      (f) =>
          f.workoutLocalId.localId.sqlEquals($_itemColumn<String>('local_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_repEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$LocalDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accumulatedActiveDurationMs => $composableBuilder(
    column: $table.accumulatedActiveDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get currentActiveSegmentStartedAt =>
      $composableBuilder(
        column: $table.currentActiveSegmentStartedAt,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get completedRepCount => $composableBuilder(
    column: $table.completedRepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incompleteRepCount => $composableBuilder(
    column: $table.incompleteRepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validFormRepCount => $composableBuilder(
    column: $table.validFormRepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRepCount => $composableBuilder(
    column: $table.totalRepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageRepDurationMs => $composableBuilder(
    column: $table.averageRepDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get formScore => $composableBuilder(
    column: $table.formScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> repEventsRefs(
    Expression<bool> Function($$RepEventsTableFilterComposer f) f,
  ) {
    final $$RepEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.repEvents,
      getReferencedColumn: (t) => t.workoutLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepEventsTableFilterComposer(
            $db: $db,
            $table: $db.repEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accumulatedActiveDurationMs => $composableBuilder(
    column: $table.accumulatedActiveDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get currentActiveSegmentStartedAt =>
      $composableBuilder(
        column: $table.currentActiveSegmentStartedAt,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get completedRepCount => $composableBuilder(
    column: $table.completedRepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incompleteRepCount => $composableBuilder(
    column: $table.incompleteRepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validFormRepCount => $composableBuilder(
    column: $table.validFormRepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRepCount => $composableBuilder(
    column: $table.totalRepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageRepDurationMs => $composableBuilder(
    column: $table.averageRepDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get formScore => $composableBuilder(
    column: $table.formScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get accumulatedActiveDurationMs => $composableBuilder(
    column: $table.accumulatedActiveDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get currentActiveSegmentStartedAt =>
      $composableBuilder(
        column: $table.currentActiveSegmentStartedAt,
        builder: (column) => column,
      );

  GeneratedColumn<int> get completedRepCount => $composableBuilder(
    column: $table.completedRepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incompleteRepCount => $composableBuilder(
    column: $table.incompleteRepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get validFormRepCount => $composableBuilder(
    column: $table.validFormRepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRepCount => $composableBuilder(
    column: $table.totalRepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get averageRepDurationMs => $composableBuilder(
    column: $table.averageRepDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get formScore =>
      $composableBuilder(column: $table.formScore, builder: (column) => column);

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> repEventsRefs<T extends Object>(
    Expression<T> Function($$RepEventsTableAnnotationComposer a) f,
  ) {
    final $$RepEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.repEvents,
      getReferencedColumn: (t) => t.workoutLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.repEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool repEventsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$LocalDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> accumulatedActiveDurationMs = const Value.absent(),
                Value<DateTime?> currentActiveSegmentStartedAt =
                    const Value.absent(),
                Value<int> completedRepCount = const Value.absent(),
                Value<int> incompleteRepCount = const Value.absent(),
                Value<int> validFormRepCount = const Value.absent(),
                Value<int> totalRepCount = const Value.absent(),
                Value<int?> averageRepDurationMs = const Value.absent(),
                Value<double?> formScore = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> recordVersion = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                localId: localId,
                remoteId: remoteId,
                userId: userId,
                exerciseType: exerciseType,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                accumulatedActiveDurationMs: accumulatedActiveDurationMs,
                currentActiveSegmentStartedAt: currentActiveSegmentStartedAt,
                completedRepCount: completedRepCount,
                incompleteRepCount: incompleteRepCount,
                validFormRepCount: validFormRepCount,
                totalRepCount: totalRepCount,
                averageRepDurationMs: averageRepDurationMs,
                formScore: formScore,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                recordVersion: recordVersion,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> remoteId = const Value.absent(),
                required String userId,
                required String exerciseType,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> accumulatedActiveDurationMs = const Value.absent(),
                Value<DateTime?> currentActiveSegmentStartedAt =
                    const Value.absent(),
                Value<int> completedRepCount = const Value.absent(),
                Value<int> incompleteRepCount = const Value.absent(),
                Value<int> validFormRepCount = const Value.absent(),
                Value<int> totalRepCount = const Value.absent(),
                Value<int?> averageRepDurationMs = const Value.absent(),
                Value<double?> formScore = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                required String syncStatus,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> recordVersion = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                userId: userId,
                exerciseType: exerciseType,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                accumulatedActiveDurationMs: accumulatedActiveDurationMs,
                currentActiveSegmentStartedAt: currentActiveSegmentStartedAt,
                completedRepCount: completedRepCount,
                incompleteRepCount: incompleteRepCount,
                validFormRepCount: validFormRepCount,
                totalRepCount: totalRepCount,
                averageRepDurationMs: averageRepDurationMs,
                formScore: formScore,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                recordVersion: recordVersion,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (repEventsRefs) db.repEvents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (repEventsRefs)
                    await $_getPrefetchedData<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      RepEvent
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._repEventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).repEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.workoutLocalId == item.localId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool repEventsRefs})
    >;
typedef $$RepEventsTableCreateCompanionBuilder =
    RepEventsCompanion Function({
      required String localId,
      Value<String?> remoteId,
      required String workoutLocalId,
      required int sequenceNumber,
      required String eventType,
      required String exerciseType,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationMs,
      required bool formValid,
      Value<double?> minimumPrimaryAngle,
      Value<double?> maximumPrimaryAngle,
      Value<String?> feedbackCodesJson,
      required DateTime createdAt,
      required String syncStatus,
      Value<int> recordVersion,
      Value<int> rowid,
    });
typedef $$RepEventsTableUpdateCompanionBuilder =
    RepEventsCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> workoutLocalId,
      Value<int> sequenceNumber,
      Value<String> eventType,
      Value<String> exerciseType,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationMs,
      Value<bool> formValid,
      Value<double?> minimumPrimaryAngle,
      Value<double?> maximumPrimaryAngle,
      Value<String?> feedbackCodesJson,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> recordVersion,
      Value<int> rowid,
    });

final class $$RepEventsTableReferences
    extends BaseReferences<_$LocalDatabase, $RepEventsTable, RepEvent> {
  $$RepEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _workoutLocalIdTable(_$LocalDatabase db) => db
      .workoutSessions
      .createAlias('rep_events__workout_local_id__workout_sessions__local_id');

  $$WorkoutSessionsTableProcessedTableManager get workoutLocalId {
    final $_column = $_itemColumn<String>('workout_local_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepEventsTableFilterComposer
    extends Composer<_$LocalDatabase, $RepEventsTable> {
  $$RepEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get formValid => $composableBuilder(
    column: $table.formValid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minimumPrimaryAngle => $composableBuilder(
    column: $table.minimumPrimaryAngle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maximumPrimaryAngle => $composableBuilder(
    column: $table.maximumPrimaryAngle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedbackCodesJson => $composableBuilder(
    column: $table.feedbackCodesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get workoutLocalId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLocalId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepEventsTableOrderingComposer
    extends Composer<_$LocalDatabase, $RepEventsTable> {
  $$RepEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get formValid => $composableBuilder(
    column: $table.formValid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minimumPrimaryAngle => $composableBuilder(
    column: $table.minimumPrimaryAngle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maximumPrimaryAngle => $composableBuilder(
    column: $table.maximumPrimaryAngle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackCodesJson => $composableBuilder(
    column: $table.feedbackCodesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get workoutLocalId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLocalId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepEventsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $RepEventsTable> {
  $$RepEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get formValid =>
      $composableBuilder(column: $table.formValid, builder: (column) => column);

  GeneratedColumn<double> get minimumPrimaryAngle => $composableBuilder(
    column: $table.minimumPrimaryAngle,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maximumPrimaryAngle => $composableBuilder(
    column: $table.maximumPrimaryAngle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feedbackCodesJson => $composableBuilder(
    column: $table.feedbackCodesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get workoutLocalId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLocalId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepEventsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $RepEventsTable,
          RepEvent,
          $$RepEventsTableFilterComposer,
          $$RepEventsTableOrderingComposer,
          $$RepEventsTableAnnotationComposer,
          $$RepEventsTableCreateCompanionBuilder,
          $$RepEventsTableUpdateCompanionBuilder,
          (RepEvent, $$RepEventsTableReferences),
          RepEvent,
          PrefetchHooks Function({bool workoutLocalId})
        > {
  $$RepEventsTableTableManager(_$LocalDatabase db, $RepEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> workoutLocalId = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<bool> formValid = const Value.absent(),
                Value<double?> minimumPrimaryAngle = const Value.absent(),
                Value<double?> maximumPrimaryAngle = const Value.absent(),
                Value<String?> feedbackCodesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepEventsCompanion(
                localId: localId,
                remoteId: remoteId,
                workoutLocalId: workoutLocalId,
                sequenceNumber: sequenceNumber,
                eventType: eventType,
                exerciseType: exerciseType,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                formValid: formValid,
                minimumPrimaryAngle: minimumPrimaryAngle,
                maximumPrimaryAngle: maximumPrimaryAngle,
                feedbackCodesJson: feedbackCodesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> remoteId = const Value.absent(),
                required String workoutLocalId,
                required int sequenceNumber,
                required String eventType,
                required String exerciseType,
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationMs,
                required bool formValid,
                Value<double?> minimumPrimaryAngle = const Value.absent(),
                Value<double?> maximumPrimaryAngle = const Value.absent(),
                Value<String?> feedbackCodesJson = const Value.absent(),
                required DateTime createdAt,
                required String syncStatus,
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepEventsCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                workoutLocalId: workoutLocalId,
                sequenceNumber: sequenceNumber,
                eventType: eventType,
                exerciseType: exerciseType,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                formValid: formValid,
                minimumPrimaryAngle: minimumPrimaryAngle,
                maximumPrimaryAngle: maximumPrimaryAngle,
                feedbackCodesJson: feedbackCodesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutLocalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutLocalId,
                                referencedTable: $$RepEventsTableReferences
                                    ._workoutLocalIdTable(db),
                                referencedColumn: $$RepEventsTableReferences
                                    ._workoutLocalIdTable(db)
                                    .localId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $RepEventsTable,
      RepEvent,
      $$RepEventsTableFilterComposer,
      $$RepEventsTableOrderingComposer,
      $$RepEventsTableAnnotationComposer,
      $$RepEventsTableCreateCompanionBuilder,
      $$RepEventsTableUpdateCompanionBuilder,
      (RepEvent, $$RepEventsTableReferences),
      RepEvent,
      PrefetchHooks Function({bool workoutLocalId})
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      required String id,
      required String entityType,
      required String entityLocalId,
      required String operation,
      required String payloadJson,
      required String status,
      Value<int> attemptCount,
      required DateTime nextAttemptAt,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastErrorCode,
      Value<String?> lastErrorMessage,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityLocalId,
      Value<String> operation,
      Value<String> payloadJson,
      Value<String> status,
      Value<int> attemptCount,
      Value<DateTime> nextAttemptAt,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastErrorCode,
      Value<String?> lastErrorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityLocalId => $composableBuilder(
    column: $table.entityLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityLocalId => $composableBuilder(
    column: $table.entityLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityLocalId => $composableBuilder(
    column: $table.entityLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<
              _$LocalDatabase,
              $SyncQueueItemsTable,
              SyncQueueItem
            >,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$LocalDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityLocalId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                entityType: entityType,
                entityLocalId: entityLocalId,
                operation: operation,
                payloadJson: payloadJson,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lastAttemptAt: lastAttemptAt,
                lastErrorCode: lastErrorCode,
                lastErrorMessage: lastErrorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityLocalId,
                required String operation,
                required String payloadJson,
                required String status,
                Value<int> attemptCount = const Value.absent(),
                required DateTime nextAttemptAt,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                entityType: entityType,
                entityLocalId: entityLocalId,
                operation: operation,
                payloadJson: payloadJson,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lastAttemptAt: lastAttemptAt,
                lastErrorCode: lastErrorCode,
                lastErrorMessage: lastErrorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$LocalDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$RepEventsTableTableManager get repEvents =>
      $$RepEventsTableTableManager(_db, _db.repEvents);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
}
