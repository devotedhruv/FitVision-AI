import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/exercise/data/workout_providers.dart';
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Sign in to view workout history.')),
      );
    }
    final history = ref.watch(workoutHistoryProvider(user.id));
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Local workout history could not be loaded.'),
        ),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No saved workouts yet.'))
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  for (final item in items)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          item.status == WorkoutSessionStatus.completed
                              ? Icons.check_circle_outline
                              : Icons.pause_circle_outline,
                        ),
                        title: Text(_exerciseName(item.exerciseType)),
                        subtitle: Text(
                          '${DateTimeFormatter.shortDate(item.startedAt.toLocal())} • ${item.accumulatedActiveDuration.inMinutes} min • ${item.completedRepCount} reps',
                        ),
                        trailing: _syncIcon(item.syncState),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  String _exerciseName(WorkoutExerciseType type) => switch (type) {
    WorkoutExerciseType.squat => 'Squat',
    WorkoutExerciseType.curl => 'Bicep curl',
    WorkoutExerciseType.pushup => 'Push-up',
  };
  Widget _syncIcon(WorkoutSyncState state) => Tooltip(
    message: state == WorkoutSyncState.synced ? 'Synced' : 'Saved on device',
    child: Icon(
      state == WorkoutSyncState.synced
          ? Icons.cloud_done_outlined
          : state == WorkoutSyncState.failed ||
                state == WorkoutSyncState.conflict
          ? Icons.cloud_off_outlined
          : Icons.cloud_upload_outlined,
    ),
  );
}
