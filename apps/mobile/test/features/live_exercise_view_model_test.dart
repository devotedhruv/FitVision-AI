import 'package:fitvision_ai/features/exercise/models/exercise_session.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer.test());
  tearDown(() => container.dispose());

  test('live session transitions from initial to active', () {
    final controller = container.read(liveExerciseProvider.notifier);
    expect(
      container.read(liveExerciseProvider).stage,
      LiveSessionStage.initial,
    );
    controller.acknowledgeDemo();
    expect(container.read(liveExerciseProvider).stage, LiveSessionStage.ready);
    controller.start();
    expect(container.read(liveExerciseProvider).stage, LiveSessionStage.active);
  });

  test('live session pauses and resumes', () {
    final controller = container.read(liveExerciseProvider.notifier);
    controller.acknowledgeDemo();
    controller.start();
    controller.pause();
    expect(container.read(liveExerciseProvider).stage, LiveSessionStage.paused);
    controller.resume();
    expect(container.read(liveExerciseProvider).stage, LiveSessionStage.active);
  });

  test('correct repetitions and finish produce completion summary state', () {
    final controller = container.read(liveExerciseProvider.notifier);
    controller.acknowledgeDemo();
    controller.start();
    controller.addCorrectRepetition();
    expect(container.read(liveExerciseProvider).repetitions, 1);
    controller.finish();
    expect(
      container.read(liveExerciseProvider).stage,
      LiveSessionStage.completed,
    );
  });

  test('invalid transition does not corrupt state', () {
    final controller = container.read(liveExerciseProvider.notifier);
    controller.pause();
    expect(
      container.read(liveExerciseProvider).stage,
      LiveSessionStage.initial,
    );
  });
}
