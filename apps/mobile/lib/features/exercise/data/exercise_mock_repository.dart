import 'package:fitvision_ai/core/constants/app_constants.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/network/api_client.dart';

enum MockDataMode { data, empty, error }

abstract interface class ExerciseRepository {
  Future<List<Exercise>> fetchExercises();
}

class ExerciseMockRepository implements ExerciseRepository {
  const ExerciseMockRepository({this.mode = MockDataMode.data});
  final MockDataMode mode;

  @override
  Future<List<Exercise>> fetchExercises() async {
    await Future<void>.delayed(AppConstants.mockDelay);
    if (mode == MockDataMode.error) {
      throw StateError('The demo exercise catalogue could not be loaded.');
    }
    if (mode == MockDataMode.empty) return const [];
    return exercises;
  }

  Exercise? findById(String id) {
    for (final exercise in exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  static const exercises = <Exercise>[
    Exercise(
      id: 'squat',
      name: 'Squat',
      category: ExerciseCategory.strength,
      difficulty: ExerciseDifficulty.beginner,
      description:
          'A controlled lower-body movement focused on steady posture.',
      instructions: [
        'Stand with feet comfortably apart.',
        'Lower with your chest lifted.',
        'Press through your feet to stand.',
      ],
      targetMuscles: ['Quadriceps', 'Glutes', 'Core'],
      estimatedDuration: Duration(minutes: 8),
      equipment: ['None'],
      illustration: 'SQ',
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: true,
    ),
    Exercise(
      id: 'push-up',
      name: 'Push-up',
      category: ExerciseCategory.strength,
      difficulty: ExerciseDifficulty.intermediate,
      description: 'An upper-body movement performed with a stable body line.',
      instructions: [
        'Place hands beneath shoulders.',
        'Lower under control.',
        'Press back to the starting position.',
      ],
      targetMuscles: ['Chest', 'Triceps', 'Shoulders'],
      estimatedDuration: Duration(minutes: 7),
      equipment: ['Exercise mat (optional)'],
      illustration: 'PU',
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: false,
    ),
    Exercise(
      id: 'bicep-curl',
      name: 'Bicep curl',
      category: ExerciseCategory.strength,
      difficulty: ExerciseDifficulty.beginner,
      description: 'A controlled arm exercise using a comfortable resistance.',
      instructions: [
        'Keep elbows near your sides.',
        'Curl without swinging.',
        'Lower the weight slowly.',
      ],
      targetMuscles: ['Biceps', 'Forearms'],
      estimatedDuration: Duration(minutes: 6),
      equipment: ['Dumbbells or resistance band'],
      illustration: 'BC',
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: true,
    ),
    Exercise(
      id: 'shoulder-press',
      name: 'Shoulder press',
      category: ExerciseCategory.strength,
      difficulty: ExerciseDifficulty.intermediate,
      description: 'An overhead press performed with manageable resistance.',
      instructions: [
        'Brace your torso.',
        'Press weights overhead.',
        'Lower to shoulder level.',
      ],
      targetMuscles: ['Shoulders', 'Triceps'],
      estimatedDuration: Duration(minutes: 8),
      equipment: ['Dumbbells'],
      illustration: 'SP',
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: false,
    ),
    Exercise(
      id: 'lunges',
      name: 'Lunges',
      category: ExerciseCategory.mobility,
      difficulty: ExerciseDifficulty.intermediate,
      description:
          'Alternating steps that train balance and lower-body control.',
      instructions: [
        'Step forward comfortably.',
        'Lower both knees under control.',
        'Push back and switch sides.',
      ],
      targetMuscles: ['Quadriceps', 'Glutes', 'Hamstrings'],
      estimatedDuration: Duration(minutes: 9),
      equipment: ['None'],
      illustration: 'LU',
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: false,
    ),
    Exercise(
      id: 'plank',
      name: 'Plank',
      category: ExerciseCategory.core,
      difficulty: ExerciseDifficulty.beginner,
      description: 'A timed core hold with a neutral, comfortable alignment.',
      instructions: [
        'Set elbows beneath shoulders.',
        'Create a steady body line.',
        'Breathe normally and stop if uncomfortable.',
      ],
      targetMuscles: ['Core', 'Shoulders'],
      estimatedDuration: Duration(minutes: 5),
      equipment: ['Exercise mat'],
      illustration: 'PL',
      trackingMode: TrackingMode.manualDemo,
      beginnerFriendly: true,
    ),
    Exercise(
      id: 'jumping-jack',
      name: 'Jumping jack',
      category: ExerciseCategory.cardio,
      difficulty: ExerciseDifficulty.beginner,
      description:
          'A rhythmic full-body cardio movement at a comfortable pace.',
      instructions: [
        'Start with feet together.',
        'Step or jump feet apart as arms rise.',
        'Return softly to the start.',
      ],
      targetMuscles: ['Full body'],
      estimatedDuration: Duration(minutes: 5),
      equipment: ['None'],
      illustration: 'JJ',
      trackingMode: TrackingMode.manualDemo,
      beginnerFriendly: true,
    ),
  ];
}

class ExerciseApiRepository implements ExerciseRepository {
  const ExerciseApiRepository(this.client);
  final ApiClient client;

  @override
  Future<List<Exercise>> fetchExercises() async {
    final items = await client.getJsonList('/api/v1/exercises');
    return items.map(_mapExercise).toList();
  }

  Exercise _mapExercise(Map<String, dynamic> json) {
    final rawInstructions = json['instructions'] as List<dynamic>? ?? const [];
    return Exercise(
      id: json['slug'] as String,
      name: json['name'] as String,
      category: _category(json['category'] as String?),
      difficulty: ExerciseDifficulty.beginner,
      description: json['description'] as String,
      instructions: rawInstructions
          .map(
            (item) => (item as Map<String, dynamic>)['step'] as String? ?? '',
          )
          .where((item) => item.isNotEmpty)
          .toList(),
      targetMuscles: const [],
      estimatedDuration: const Duration(minutes: 8),
      equipment: const ['None'],
      illustration: (json['name'] as String)
          .split(' ')
          .map((part) => part[0])
          .take(2)
          .join(),
      trackingMode: TrackingMode.poseDemo,
      beginnerFriendly: true,
    );
  }

  ExerciseCategory _category(String? value) => switch (value) {
    'cardio' => ExerciseCategory.cardio,
    'stability' || 'core' => ExerciseCategory.core,
    'mobility' => ExerciseCategory.mobility,
    _ => ExerciseCategory.strength,
  };
}

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseApiRepository(ref.watch(apiClientProvider)),
);

class ExerciseOfflineStatus extends Notifier<bool> {
  @override
  bool build() => false;

  void setOffline(bool value) => state = value;
}

final exerciseOfflineStatusProvider =
    NotifierProvider<ExerciseOfflineStatus, bool>(ExerciseOfflineStatus.new);

final exerciseCatalogueProvider = FutureProvider<List<Exercise>>((ref) async {
  try {
    final items = await ref.watch(exerciseRepositoryProvider).fetchExercises();
    ref.read(exerciseOfflineStatusProvider.notifier).setOffline(false);
    return items;
  } on AppException catch (error) {
    if (error.failure is! NetworkFailure &&
        error.failure is! TimeoutFailure &&
        error.failure is! ServerFailure) {
      rethrow;
    }
    ref.read(exerciseOfflineStatusProvider.notifier).setOffline(true);
    return ExerciseMockRepository.exercises;
  }
});

final exerciseByIdProvider = FutureProvider.family<Exercise?, String>((
  ref,
  exerciseId,
) async {
  if (exerciseId.trim().isEmpty) return null;
  final catalogue = await ref.watch(exerciseCatalogueProvider.future);
  for (final exercise in catalogue) {
    if (exercise.id == exerciseId) return exercise;
  }
  return null;
});
