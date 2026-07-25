import 'package:fitvision_ai/core/design_system/app_colors.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:fitvision_ai/features/exercise/models/exercise_session.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view_model.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LiveExerciseView extends ConsumerWidget {
  const LiveExerciseView({required this.exercise, super.key});
  final Exercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(liveExerciseProvider);
    final controller = ref.read(liveExerciseProvider.notifier);
    if (session.stage == LiveSessionStage.initial) {
      return Scaffold(
        appBar: AppBar(title: Text('${exercise.name} demo')),
        body: PermissionDialog(
          title: 'Simulated camera experience',
          explanation:
              'This prototype displays a camera placeholder only. It does not '
              'request camera permission, capture video, or analyze your form.',
          onContinue: controller.acknowledgeDemo,
        ),
      );
    }
    if (session.stage == LiveSessionStage.error) {
      return Scaffold(
        appBar: AppBar(title: Text('${exercise.name} demo')),
        body: ErrorView(
          message: session.feedback,
          actionLabel: 'Restart demo',
          onRetry: controller.reset,
        ),
      );
    }
    if (session.stage == LiveSessionStage.completed) {
      return _CompletionView(
        exercise: exercise,
        session: session,
        onAgain: controller.reset,
      );
    }
    final active = session.stage == LiveSessionStage.active;
    final paused = session.stage == LiveSessionStage.paused;
    return Scaffold(
      appBar: AppBar(title: Text('${exercise.name} • Demo')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Semantics(
              label: 'Simulated camera preview. Keep your full body in frame.',
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: const Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_off_outlined, size: 56),
                            Text('CAMERA PREVIEW PLACEHOLDER'),
                            Text('Simulated tracking only'),
                          ],
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        bottom: AppSpacing.md,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.sm),
                            child: Text(
                              'Place your device securely and keep your full body visible.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _SessionMetric(
                    label: 'Repetitions',
                    value:
                        '${session.repetitions} / ${session.targetRepetitions}',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SessionMetric(
                    label: 'Timer',
                    value: DateTimeFormatter.duration(session.elapsed),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                leading: Icon(
                  session.formStatus == FormStatus.needsAttention
                      ? Icons.info_outline
                      : Icons.check_circle_outline,
                  color: session.formStatus == FormStatus.needsAttention
                      ? AppColors.warning
                      : AppColors.success,
                ),
                title: Text(_formLabel(session.formStatus)),
                subtitle: Text(session.feedback),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (session.stage == LiveSessionStage.ready)
              FilledButton.icon(
                key: const Key('start-session'),
                onPressed: controller.start,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start simulated session'),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      key: const Key('correct-rep'),
                      onPressed: active
                          ? controller.addCorrectRepetition
                          : null,
                      icon: const Icon(Icons.add),
                      label: const Text('Correct rep'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      key: const Key('form-feedback'),
                      onPressed: active ? controller.flagForm : null,
                      icon: const Icon(Icons.feedback_outlined),
                      label: const Text('Form cue'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('pause-resume'),
                      onPressed: active
                          ? controller.pause
                          : paused
                          ? controller.resume
                          : null,
                      icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                      label: Text(paused ? 'Resume' : 'Pause'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('end-session'),
                      onPressed: active || paused ? controller.finish : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('End session'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formLabel(FormStatus status) => switch (status) {
    FormStatus.waiting => 'Waiting for demo input',
    FormStatus.good => 'Demo status: controlled',
    FormStatus.needsAttention => 'Demo status: adjust form',
  };
}

class _SessionMetric extends StatelessWidget {
  const _SessionMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(children: [Text(label), Text(value)]),
    ),
  );
}

class _CompletionView extends StatelessWidget {
  const _CompletionView({
    required this.exercise,
    required this.session,
    required this.onAgain,
  });
  final Exercise exercise;
  final ExerciseSession session;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Session complete')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.celebration_outlined, size: 64),
            Text('${exercise.name} complete'),
            const Text('Demo result — not real form analysis'),
            const SizedBox(height: AppSpacing.lg),
            Text('${session.repetitions} repetitions'),
            Text(DateTimeFormatter.duration(session.elapsed)),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: onAgain,
              child: const Text('Run demo again'),
            ),
            TextButton(
              onPressed: () => context.go('/exercises'),
              child: const Text('Back to exercises'),
            ),
          ],
        ),
      ),
    ),
  );
}
