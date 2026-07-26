import 'package:fitvision_ai/features/exercise/presentation/workout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valid workout lifecycle transitions are explicit', () {
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.idle,
        WorkoutLifecycleState.starting,
      ),
      isTrue,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.active,
        WorkoutLifecycleState.paused,
      ),
      isTrue,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.paused,
        WorkoutLifecycleState.active,
      ),
      isTrue,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.active,
        WorkoutLifecycleState.ending,
      ),
      isTrue,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.ending,
        WorkoutLifecycleState.completed,
      ),
      isTrue,
    );
  });
  test('completed, idle and duplicate pause transitions are rejected', () {
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.completed,
        WorkoutLifecycleState.active,
      ),
      isFalse,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.idle,
        WorkoutLifecycleState.ending,
      ),
      isFalse,
    );
    expect(
      WorkoutLifecycle.canTransition(
        WorkoutLifecycleState.paused,
        WorkoutLifecycleState.paused,
      ),
      isFalse,
    );
  });
}
