enum SyncJobStatus { pending, processing, failed, completed }

enum SyncEntityType { workoutSession, repEvent }

enum SyncOperation { create, update, delete }

enum SyncManagerState {
  idle,
  syncing,
  pending,
  failed,
  offline,
  authenticationRequired,
}
