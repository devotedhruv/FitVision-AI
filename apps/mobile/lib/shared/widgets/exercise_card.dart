import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({required this.exercise, required this.onTap, super.key});
  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Open ${exercise.name}, ${exercise.difficultyLabel}',
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(exercise.illustration),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${exercise.targetMuscles.join(' • ')}\n'
                      '${exercise.estimatedDuration.inMinutes} min',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Chip(label: Text(exercise.difficultyLabel)),
            ],
          ),
        ),
      ),
    ),
  );
}
