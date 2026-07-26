import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_detail_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExerciseRouteDestination { detail, live }

class ExerciseRouteView extends ConsumerWidget {
  const ExerciseRouteView({
    required this.exerciseId,
    required this.destination,
    super.key,
  });

  final String exerciseId;
  final ExerciseRouteDestination destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(exerciseByIdProvider(exerciseId));
    return exercise.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading exercise')),
        body: const LoadingIndicator(label: 'Loading exercise details'),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: const Text('Exercise unavailable')),
        body: ErrorView(
          message: 'We could not load this exercise from the catalogue.',
          actionLabel: 'Retry',
          onRetry: () {
            ref
              ..invalidate(exerciseCatalogueProvider)
              ..invalidate(exerciseByIdProvider(exerciseId));
          },
        ),
      ),
      data: (value) {
        if (value == null) return InvalidExerciseView(exerciseId: exerciseId);
        return switch (destination) {
          ExerciseRouteDestination.detail => ExerciseDetailView(
            exercise: value,
          ),
          ExerciseRouteDestination.live => LiveExerciseView(exercise: value),
        };
      },
    );
  }
}
