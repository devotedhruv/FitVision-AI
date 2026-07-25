class DashboardSummary {
  const DashboardSummary({
    required this.streakDays,
    required this.totalWorkouts,
    required this.estimatedCalories,
    required this.activeMinutes,
    required this.weeklyCompleted,
    required this.weeklyGoal,
    required this.recentWorkout,
  });

  final int streakDays;
  final int totalWorkouts;
  final int estimatedCalories;
  final int activeMinutes;
  final int weeklyCompleted;
  final int weeklyGoal;
  final String? recentWorkout;
}
