import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutResultView extends StatelessWidget {
  const WorkoutResultView({required this.result, super.key});
  final WorkoutResultData result;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Camera session result')),
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
          'Phase 4 tracking summary — no rep or form score generated',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        _ResultTile(
          label: 'Duration',
          value: DateTimeFormatter.duration(result.duration),
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
        const _ResultTile(
          label: 'Rep count',
          value: 'Unavailable until Phase 5',
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () => context.go('/exercises'),
          child: const Text('Back to exercises'),
        ),
      ],
    ),
  );
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
