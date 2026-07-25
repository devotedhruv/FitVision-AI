enum WorkoutStatus { completed, stopped }

class WorkoutHistoryItem {
  const WorkoutHistoryItem({
    required this.date,
    required this.exerciseName,
    required this.duration,
    required this.repetitions,
    required this.status,
    required this.demoFormScore,
  });
  final DateTime date;
  final String exerciseName;
  final Duration duration;
  final int repetitions;
  final WorkoutStatus status;
  final int demoFormScore;
}
