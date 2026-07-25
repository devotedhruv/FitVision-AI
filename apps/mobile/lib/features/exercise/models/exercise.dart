enum ExerciseCategory { strength, mobility, cardio, core }

enum ExerciseDifficulty { beginner, intermediate, advanced }

enum TrackingMode { poseDemo, manualDemo }

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.instructions,
    required this.targetMuscles,
    required this.estimatedDuration,
    required this.equipment,
    required this.illustration,
    required this.trackingMode,
    required this.beginnerFriendly,
  });

  final String id;
  final String name;
  final ExerciseCategory category;
  final ExerciseDifficulty difficulty;
  final String description;
  final List<String> instructions;
  final List<String> targetMuscles;
  final Duration estimatedDuration;
  final List<String> equipment;
  final String illustration;
  final TrackingMode trackingMode;
  final bool beginnerFriendly;

  String get categoryLabel => _label(category.name);
  String get difficultyLabel => _label(difficulty.name);
  bool get supportsPoseDemo => trackingMode == TrackingMode.poseDemo;

  static String _label(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
}
