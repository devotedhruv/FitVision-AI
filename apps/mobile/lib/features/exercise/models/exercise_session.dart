enum LiveSessionStage { initial, ready, active, paused, completed, error }

enum FormStatus { waiting, good, needsAttention }

class ExerciseSession {
  const ExerciseSession({
    required this.stage,
    required this.repetitions,
    required this.targetRepetitions,
    required this.elapsed,
    required this.formStatus,
    required this.feedback,
  });

  factory ExerciseSession.initial({int targetRepetitions = 10}) =>
      ExerciseSession(
        stage: LiveSessionStage.initial,
        repetitions: 0,
        targetRepetitions: targetRepetitions,
        elapsed: Duration.zero,
        formStatus: FormStatus.waiting,
        feedback: 'Review the camera guidance before starting.',
      );

  final LiveSessionStage stage;
  final int repetitions;
  final int targetRepetitions;
  final Duration elapsed;
  final FormStatus formStatus;
  final String feedback;

  ExerciseSession copyWith({
    LiveSessionStage? stage,
    int? repetitions,
    Duration? elapsed,
    FormStatus? formStatus,
    String? feedback,
  }) => ExerciseSession(
    stage: stage ?? this.stage,
    repetitions: repetitions ?? this.repetitions,
    targetRepetitions: targetRepetitions,
    elapsed: elapsed ?? this.elapsed,
    formStatus: formStatus ?? this.formStatus,
    feedback: feedback ?? this.feedback,
  );
}
