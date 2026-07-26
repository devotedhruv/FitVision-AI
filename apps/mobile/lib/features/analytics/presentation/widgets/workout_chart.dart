import 'package:flutter/material.dart';
import '../../domain/models/exercise_progress.dart';

class WorkoutChart extends StatelessWidget {
  const WorkoutChart({required this.items, super.key});
  final List<ExerciseProgress> items;
  @override
  Widget build(BuildContext context) {
    final max = items.fold<int>(
      1,
      (v, e) => e.completedReps > v ? e.completedReps : v,
    );
    return Semantics(
      label: 'Completed repetitions by exercise',
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: items
              .map(
                (e) => Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${e.completedReps}'),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 100 * e.completedReps / max,
                        width: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: .32),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                      Text(e.exerciseType),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
