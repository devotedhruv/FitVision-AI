enum ExerciseStage { ready, up, down, hold, unknown }

class ExerciseAnalysisState {
  const ExerciseAnalysisState({
    this.stage = ExerciseStage.ready,
    this.repCount = 0,
    this.validRepCount = 0,
    this.invalidRepCount = 0,
    this.formStatus = 'Camera readiness only',
    this.shortFeedback = 'Rep and form analysis begin in Phase 5.',
  });

  final ExerciseStage stage;
  final int repCount;
  final int validRepCount;
  final int invalidRepCount;
  final String formStatus;
  final String shortFeedback;
}
