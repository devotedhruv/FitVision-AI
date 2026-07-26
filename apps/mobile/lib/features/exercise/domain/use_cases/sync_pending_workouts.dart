import 'package:fitvision_ai/core/sync/sync_manager.dart';

class SyncPendingWorkouts {
  const SyncPendingWorkouts(this.manager);
  final SyncManager manager;
  Future<void> call({bool manual = false}) =>
      manager.synchronize(manual: manual);
}
