import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../domain/models/history_filter.dart';
import '../domain/models/history_item.dart';

class HistoryLocalDataSource {
  const HistoryLocalDataSource(this.db);
  final LocalDatabase db;
  Future<List<HistoryItem>> page(
    String userId,
    HistoryFilter filter, {
    int page = 0,
    DateTime? now,
  }) async {
    final range = filter.utcRange((now ?? DateTime.now()).toLocal());
    final where = <String>['user_id = ?', 'status = \'completed\''];
    final vars = <Variable>[Variable(userId)];
    if (range.startUtc != null) {
      where.add('started_at >= ?');
      vars.add(Variable(range.startUtc));
    }
    if (range.endUtc != null) {
      where.add('started_at < ?');
      vars.add(Variable(range.endUtc));
    }
    String sync(String alias) {
      return switch (filter.sync) {
        HistorySyncFilter.all => '',
        HistorySyncFilter.synced => ' AND $alias.sync_status = \'synced\'',
        HistorySyncFilter.pending =>
          ' AND $alias.sync_status IN (\'pending\',\'syncing\')',
        HistorySyncFilter.failed =>
          ' AND $alias.sync_status IN (\'failed\',\'conflict\')',
      };
    }

    final parts = <String>[];
    if (filter.category != HistoryCategoryFilter.running) {
      final exercise = filter.exercise == HistoryExerciseFilter.all
          ? ''
          : " AND w.exercise_type = '${filter.exercise.name}'";
      parts.add(
        "SELECT local_id,remote_id,'exercise' category,exercise_type,started_at,ended_at,accumulated_active_duration_ms active_ms,sync_status,completed_rep_count,incomplete_rep_count,valid_form_rep_count,form_score,summary_json,0.0 distance,NULL pace,NULL speed,0 point_count FROM workout_sessions w WHERE ${where.join(' AND ')} AND deleted_at IS NULL$exercise${sync('w')}",
      );
    }
    if (filter.category != HistoryCategoryFilter.exercise &&
        filter.exercise == HistoryExerciseFilter.all) {
      parts.add(
        "SELECT local_id,remote_id,'running' category,NULL exercise_type,started_at,ended_at,accumulated_active_duration_ms active_ms,sync_status,NULL completed_rep_count,NULL incomplete_rep_count,NULL valid_form_rep_count,NULL form_score,NULL summary_json,total_distance_meters distance,average_pace_seconds_per_km pace,average_speed_mps speed,accepted_point_count point_count FROM running_sessions r WHERE ${where.join(' AND ')}${sync('r')}",
      );
    }
    if (parts.isEmpty) return const [];
    final duplicated = <Variable>[];
    for (var i = 0; i < parts.length; i++) {
      duplicated.addAll(vars);
    }
    final sql =
        '${parts.join(' UNION ALL ')} ORDER BY started_at DESC, local_id DESC LIMIT ? OFFSET ?';
    duplicated
      ..add(Variable(filter.pageSize))
      ..add(Variable(page * filter.pageSize));
    final rows = await db
        .customSelect(
          sql,
          variables: duplicated,
          readsFrom: {db.workoutSessions, db.runningSessions},
        )
        .get();
    return rows.map(_map).toList();
  }

  HistoryItem _map(QueryRow r) {
    final category = r.read<String>('category') == 'exercise'
        ? HistoryCategory.exercise
        : HistoryCategory.running;
    List<String> feedback = [];
    final summary = r.readNullable<String>('summary_json');
    if (summary != null) {
      try {
        feedback = List<String>.from(
          (jsonDecode(summary) as Map)['frequentFeedbackCodes'] as List? ??
              const [],
        );
      } catch (_) {}
    }
    return HistoryItem(
      localId: r.read('local_id'),
      remoteId: r.readNullable('remote_id'),
      category: category,
      exerciseType: r.readNullable('exercise_type'),
      startedAt: r.read<DateTime>('started_at'),
      endedAt: r.readNullable('ended_at'),
      activeDuration: Duration(milliseconds: r.read<int>('active_ms')),
      completed: true,
      syncStatus: r.read('sync_status'),
      completedReps: r.readNullable('completed_rep_count'),
      incompleteReps: r.readNullable('incomplete_rep_count'),
      validFormReps: r.readNullable('valid_form_rep_count'),
      formScore: r.readNullable('form_score'),
      feedbackCodes: feedback,
      distanceMeters: category == HistoryCategory.running
          ? r.read<double>('distance')
          : null,
      averagePaceSecondsPerKm: r.readNullable('pace'),
      averageSpeedMps: r.readNullable('speed'),
      routeAvailable:
          category == HistoryCategory.running && r.read<int>('point_count') > 0,
      acceptedPointCount: category == HistoryCategory.running
          ? r.read<int>('point_count')
          : null,
    );
  }

  Stream<void> changes(String userId) => db
      .select(db.workoutSessions)
      .watch()
      .map((_) {})
      .asyncExpand((_) => Stream.value(null));
}
