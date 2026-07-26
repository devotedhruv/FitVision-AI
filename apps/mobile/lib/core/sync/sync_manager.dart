import 'dart:async';
import 'dart:convert';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/exercise/data/workout_local_data_source.dart';
import 'package:fitvision_ai/features/exercise/data/workout_remote_data_source.dart';
import 'package:fitvision_ai/features/running/data/running_remote_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'connectivity_monitor.dart';
import 'retry_policy.dart';
import 'sync_status.dart';

class SyncManager extends ChangeNotifier {
  SyncManager({
    required this.queue,
    required this.local,
    required this.remote,
    required this.auth,
    required this.connectivity,
    RetryPolicy? retryPolicy,
    DateTime Function()? clock,
    this.runningRemote,
  }) : retryPolicy = retryPolicy ?? RetryPolicy(),
       clock = clock ?? DateTime.now;
  final SyncQueueDao queue;
  final WorkoutLocalDataSource local;
  final WorkoutRemoteDataSource remote;
  final AuthRepository auth;
  final ConnectivityMonitor connectivity;
  final RetryPolicy retryPolicy;
  final RunningRemoteDataSource? runningRemote;
  final DateTime Function() clock;
  StreamSubscription<void>? _connectivitySubscription;
  StreamSubscription<AuthUser?>? _authSubscription;
  bool _running = false;
  SyncManagerState state = SyncManagerState.idle;
  bool get isRunning => _running;

  Future<void> initialize() async {
    await queue.recoverStuck(clock().toUtc());
    _connectivitySubscription ??= connectivity.reconnects.listen(
      (_) => unawaited(synchronize()),
    );
    _authSubscription ??= auth.authStateChanges.listen((user) {
      if (user != null) unawaited(synchronize());
    });
    await synchronize();
  }

  Future<void> synchronize({bool manual = false}) async {
    if (_running) return;
    _running = true;
    if (auth.currentUser == null || auth.currentAccessToken == null) {
      _setState(SyncManagerState.authenticationRequired);
      _running = false;
      return;
    }
    if (!manual && !await connectivity.hasNetworkInterface) {
      _setState(SyncManagerState.offline);
      _running = false;
      return;
    }
    _setState(SyncManagerState.syncing);
    try {
      final jobs = await queue.eligible(clock().toUtc());
      for (final job in jobs) {
        await _process(job);
      }
      _setState(
        await queue.pendingCount() == 0
            ? SyncManagerState.idle
            : SyncManagerState.pending,
      );
    } finally {
      _running = false;
    }
  }

  Future<void> _process(SyncQueueItem job) async {
    final now = clock().toUtc();
    await queue.updateItem(
      job.id,
      SyncQueueItemsCompanion(
        status: const Value('processing'),
        lastAttemptAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    if (job.entityType == 'running_session') {
      await _markRun(job.entityLocalId, 'syncing');
    } else {
      await local.markWorkoutSyncing(job.entityLocalId);
    }
    try {
      final payload = Map<String, Object?>.from(
        jsonDecode(job.payloadJson) as Map,
      );
      if (job.entityType == 'running_session') {
        final result = await runningRemote!.createOrGet(payload);
        await _markRun(job.entityLocalId, 'synced', result.remoteId);
      } else {
        final result = await remote.createOrGet(payload);
        await local.markWorkoutSynced(job.entityLocalId, result.remoteId);
      }
      await queue.remove(job.id);
    } on AppException catch (error) {
      await _fail(job, error.failure, error.cause);
    } catch (error) {
      await _fail(job, const ServerFailure(), error.runtimeType);
    }
  }

  Future<void> _fail(SyncQueueItem job, Failure failure, Object? cause) async {
    final retryable =
        failure is NetworkFailure ||
        failure is TimeoutFailure ||
        failure is ServerFailure;
    final attempt = job.attemptCount + 1;
    final canRetry = retryable && retryPolicy.canRetry(attempt);
    final now = clock().toUtc();
    if (job.entityType == 'running_session') {
      await _markRun(job.entityLocalId, retryable ? 'failed' : 'conflict');
    } else {
      await local.markWorkoutSyncFailed(
        job.entityLocalId,
        conflict: !retryable && failure is! UnauthorizedFailure,
      );
    }
    await queue.updateItem(
      job.id,
      SyncQueueItemsCompanion(
        status: Value(canRetry ? 'failed' : 'completed'),
        attemptCount: Value(attempt),
        nextAttemptAt: Value(
          canRetry ? now.add(retryPolicy.delayForAttempt(attempt)) : now,
        ),
        lastAttemptAt: Value(now),
        lastErrorCode: Value(failure.runtimeType.toString()),
        lastErrorMessage: Value(_sanitize(failure.message)),
        updatedAt: Value(now),
      ),
    );
    _setState(
      failure is UnauthorizedFailure
          ? SyncManagerState.authenticationRequired
          : SyncManagerState.failed,
    );
  }

  Future<void> _markRun(String id, String status, [String? remoteId]) async {
    await (queue.database.update(
      queue.database.runningSessions,
    )..where((row) => row.localId.equals(id))).write(
      RunningSessionsCompanion(
        syncStatus: Value(status),
        remoteId: remoteId == null ? const Value.absent() : Value(remoteId),
        lastSyncedAt: status == 'synced'
            ? Value(clock().toUtc())
            : const Value.absent(),
        updatedAt: Value(clock().toUtc()),
      ),
    );
  }

  String _sanitize(String message) {
    final sanitized = message.replaceAll(
      RegExp(r'https?://\S+|Bearer\s+\S+', caseSensitive: false),
      '[redacted]',
    );
    return sanitized.substring(
      0,
      sanitized.length > 200 ? 200 : sanitized.length,
    );
  }

  void _setState(SyncManagerState value) {
    state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_connectivitySubscription?.cancel());
    unawaited(_authSubscription?.cancel());
    super.dispose();
  }
}
