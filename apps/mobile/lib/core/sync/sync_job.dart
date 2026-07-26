import 'sync_status.dart';

class SyncJob {
  const SyncJob({
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
  final String id;
  final SyncEntityType entityType;
  final String entityLocalId;
  final SyncOperation operation;
  final String payloadJson;
  final SyncJobStatus status;
  final int attemptCount;
  final DateTime nextAttemptAt;
  final DateTime? lastAttemptAt;
  final String? lastErrorCode;
  final String? lastErrorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
}
