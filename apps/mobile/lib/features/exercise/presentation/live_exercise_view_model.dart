import 'dart:async';

import 'package:fitvision_ai/core/constants/app_constants.dart';
import 'package:fitvision_ai/features/exercise/models/exercise_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveExerciseViewModel extends Notifier<ExerciseSession> {
  Timer? _timer;

  @override
  ExerciseSession build() {
    ref.onDispose(() => _timer?.cancel());
    return ExerciseSession.initial(
      targetRepetitions: AppConstants.liveTargetRepetitions,
    );
  }

  void acknowledgeDemo() {
    if (state.stage != LiveSessionStage.initial) return;
    state = state.copyWith(
      stage: LiveSessionStage.ready,
      feedback:
          'Camera is simulated. Start when you are comfortably positioned.',
    );
  }

  void start() {
    if (state.stage != LiveSessionStage.ready) return;
    state = state.copyWith(
      stage: LiveSessionStage.active,
      feedback: 'Move at a comfortable, controlled pace.',
    );
    _startTimer();
  }

  void addCorrectRepetition() {
    if (state.stage != LiveSessionStage.active) return;
    final next = state.repetitions + 1;
    state = state.copyWith(
      repetitions: next,
      formStatus: FormStatus.good,
      feedback: 'Demo feedback: controlled repetition recorded.',
    );
    if (next >= state.targetRepetitions) finish();
  }

  void flagForm() {
    if (state.stage != LiveSessionStage.active) return;
    state = state.copyWith(
      formStatus: FormStatus.needsAttention,
      feedback: 'Demo feedback: slow down and keep a comfortable alignment.',
    );
  }

  void pause() {
    if (state.stage != LiveSessionStage.active) return;
    _timer?.cancel();
    state = state.copyWith(
      stage: LiveSessionStage.paused,
      feedback: 'Session paused.',
    );
  }

  void resume() {
    if (state.stage != LiveSessionStage.paused) return;
    state = state.copyWith(
      stage: LiveSessionStage.active,
      feedback: 'Session resumed.',
    );
    _startTimer();
  }

  void finish() {
    if (state.stage != LiveSessionStage.active &&
        state.stage != LiveSessionStage.paused) {
      return;
    }
    _timer?.cancel();
    state = state.copyWith(
      stage: LiveSessionStage.completed,
      feedback: 'Demo session complete.',
    );
  }

  void failForTest() {
    _timer?.cancel();
    state = state.copyWith(
      stage: LiveSessionStage.error,
      feedback: 'The simulated session encountered an error.',
    );
  }

  void reset() {
    _timer?.cancel();
    state = ExerciseSession.initial(
      targetRepetitions: AppConstants.liveTargetRepetitions,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(seconds: 1),
      );
    });
  }
}

final liveExerciseProvider =
    NotifierProvider.autoDispose<LiveExerciseViewModel, ExerciseSession>(
      LiveExerciseViewModel.new,
    );
