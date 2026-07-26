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
                      Container(
                        height: 100 * e.completedReps / max,
                        width: 28,
                        color: Theme.of(context).colorScheme.primary,
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
