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
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  _iconFor(exercise.category),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 32,
                ),
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
                      exercise.targetMuscles.join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        _Meta(
                          icon: Icons.timer_outlined,
                          label: '${exercise.estimatedDuration.inMinutes} min',
                        ),
                        _Meta(
                          icon: Icons.signal_cellular_alt,
                          label: exercise.difficultyLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ),
  );

  IconData _iconFor(ExerciseCategory category) => switch (category) {
    ExerciseCategory.strength => Icons.fitness_center,
    ExerciseCategory.mobility => Icons.accessibility_new,
    ExerciseCategory.cardio => Icons.monitor_heart_outlined,
    ExerciseCategory.core => Icons.self_improvement,
  };
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: AppSpacing.xxs),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ],
  );
}
