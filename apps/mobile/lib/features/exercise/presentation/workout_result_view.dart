import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/exercise/data/workout_providers.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutResultView extends ConsumerWidget {
  const WorkoutResultView({required this.result, super.key});
  final WorkoutResultData result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = result.workoutLocalId == null
        ? null
        : ref.watch(workoutDetailsProvider(result.workoutLocalId!));
    final session = local?.value;
    final syncState = session?.syncState.name ?? result.syncState;
    return Scaffold(
      appBar: AppBar(title: const Text('Workout result')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Icon(Icons.check_circle_outline, size: 72),
          Text(
            result.exerciseName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Text(
            'Saved on-device movement analysis summary',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ResultTile(
            label: 'Duration',
            value: DateTimeFormatter.duration(
              session?.accumulatedActiveDuration ?? result.duration,
            ),
          ),
          _ResultTile(
            label: 'Camera',
            value: result.frontCamera ? 'Front' : 'Back',
          ),
          _ResultTile(
            label: 'Frames with pose',
            value: '${result.detectedFramePercentage.toStringAsFixed(1)}%',
          ),
          _ResultTile(
            label: 'Average inference latency',
            value: '${result.averageLatencyMs.toStringAsFixed(1)} ms',
          ),
          _ResultTile(
            label: 'Completed reps',
            value: '${session?.completedRepCount ?? result.completedReps}',
          ),
          _ResultTile(
            label: 'Incomplete reps',
            value: '${session?.incompleteRepCount ?? result.incompleteReps}',
          ),
          _ResultTile(
            label: 'Valid-form reps',
            value: '${session?.validFormRepCount ?? result.validFormReps}',
          ),
          _ResultTile(label: 'Sync', value: _syncLabel(syncState)),
          if (syncState == WorkoutSyncState.failed.name ||
              syncState == WorkoutSyncState.conflict.name)
            OutlinedButton.icon(
              onPressed: () =>
                  ref.read(syncManagerProvider).synchronize(manual: true),
              icon: const Icon(Icons.sync),
              label: const Text('Retry sync'),
            ),
          if (result.feedbackSummary.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Session feedback',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...result.feedbackSummary.map(
              (item) => ListTile(
                leading: const Icon(Icons.tips_and_updates_outlined),
                title: Text(item),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => context.go('/exercises'),
            child: const Text('Back to exercises'),
          ),
        ],
      ),
    );
  }

  String _syncLabel(String value) => switch (value) {
    'synced' => 'Synced',
    'syncing' => 'Syncing',
    'failed' || 'conflict' => 'Sync failed — saved on device',
    _ => 'Saved on device',
  };
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(label), trailing: Text(value)),
  );
}
