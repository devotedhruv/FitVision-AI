enum WorkoutLifecycleState {
  idle,
  starting,
  active,
  paused,
  ending,
  completed,
  failed,
}

abstract final class WorkoutLifecycle {
  static bool canTransition(
    WorkoutLifecycleState from,
    WorkoutLifecycleState to,
  ) => switch ((from, to)) {
    (WorkoutLifecycleState.idle, WorkoutLifecycleState.starting) ||
    (WorkoutLifecycleState.starting, WorkoutLifecycleState.active) ||
    (WorkoutLifecycleState.starting, WorkoutLifecycleState.failed) ||
    (WorkoutLifecycleState.active, WorkoutLifecycleState.paused) ||
    (WorkoutLifecycleState.paused, WorkoutLifecycleState.active) ||
    (WorkoutLifecycleState.active, WorkoutLifecycleState.ending) ||
    (WorkoutLifecycleState.paused, WorkoutLifecycleState.ending) ||
    (WorkoutLifecycleState.ending, WorkoutLifecycleState.completed) ||
    (WorkoutLifecycleState.ending, WorkoutLifecycleState.failed) => true,
    _ => false,
  };
}
