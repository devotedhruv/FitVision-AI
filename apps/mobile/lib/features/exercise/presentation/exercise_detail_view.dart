import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExerciseDetailView extends StatelessWidget {
  const ExerciseDetailView({required this.exercise, super.key});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(exercise.name)),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            exercise.illustration,
            style: AppTypography.pageTitle(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(exercise.name, style: AppTypography.pageTitle(context)),
        Text('${exercise.categoryLabel} • ${exercise.difficultyLabel}'),
        const SizedBox(height: AppSpacing.md),
        Text(exercise.description),
        const SizedBox(height: AppSpacing.lg),
        _InfoCard(
          title: 'Session overview',
          lines: [
            'Target muscles: ${exercise.targetMuscles.join(', ')}',
            'Equipment: ${exercise.equipment.join(', ')}',
            'Estimated duration: ${exercise.estimatedDuration.inMinutes} minutes',
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('How to perform', style: AppTypography.sectionTitle(context)),
        const SizedBox(height: AppSpacing.xs),
        for (var i = 0; i < exercise.instructions.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text(exercise.instructions[i]),
          ),
        const SizedBox(height: AppSpacing.md),
        const _InfoCard(
          title: 'Basic safety guidance',
          lines: [
            'Use a comfortable range and clear surrounding space.',
            'Stop if you feel pain, dizziness, or unusual discomfort.',
            'FitVision AI is not a medical or injury-diagnosis tool.',
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: ListTile(
            leading: Icon(
              exercise.supportsPoseDemo
                  ? Icons.videocam_outlined
                  : Icons.touch_app_outlined,
            ),
            title: Text(
              exercise.supportsPoseDemo
                  ? 'On-device pose tracking available'
                  : 'Manual demo session',
            ),
            subtitle: Text(
              exercise.supportsPoseDemo
                  ? 'Camera frames stay on your phone. Phase 4 detects body '
                        'landmarks but does not count reps or score form.'
                  : 'Automated tracking is not supported for this exercise yet.',
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: exercise.supportsPoseDemo
              ? 'Open Camera Guide'
              : 'Start Manual Demo',
          icon: Icons.play_arrow,
          onPressed: () => context.push('/exercises/${exercise.id}/live'),
        ),
      ],
    ),
  );
}

class InvalidExerciseView extends StatelessWidget {
  const InvalidExerciseView({required this.exerciseId, super.key});
  final String exerciseId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Exercise not found')),
    body: ErrorView(
      message: 'No exercise exists for “$exerciseId”.',
      actionLabel: 'Browse exercises',
      onRetry: () => context.go('/exercises'),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.cardTitle(context)),
          const SizedBox(height: AppSpacing.xs),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Text(line),
            ),
        ],
      ),
    ),
  );
}
