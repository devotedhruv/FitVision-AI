import '../config/exercise_engine_config.dart';
import '../feedback/feedback_code.dart';
import '../feedback/feedback_generator.dart';
import '../filtering/landmark_smoother.dart';
import '../filtering/visibility_filter.dart';
import '../models/analyzer_output.dart';
import '../models/exercise_result.dart';
import '../models/pose_frame.dart';
import '../models/rep_result.dart';
import '../state_machine/exercise_state.dart';
import '../state_machine/rep_state_machine.dart';
import 'exercise_analyzer.dart';

abstract class BaseAnalyzer implements ExerciseAnalyzer {
  BaseAnalyzer(
    this.type,
    this.config,
    ExerciseState initial,
    List<ExerciseState> sequence,
  ) : smoother = LandmarkSmoother(config.smoothing),
      visibility = VisibilityFilter(config.visibility),
      feedback = FeedbackGenerator(config.feedback),
      machine = RepStateMachine(
        initialState: initial,
        sequence: sequence,
        config: config.repTiming,
      );
  final ExerciseType type;
  final ExerciseEngineConfig config;
  final LandmarkSmoother smoother;
  final VisibilityFilter visibility;
  final FeedbackGenerator feedback;
  final RepStateMachine machine;
  final List<RepResult> results = [];
  final Set<FeedbackCode> sessionFeedback = {};
  Duration? sessionStart, lastTimestamp;
  int incompleteCount = 0;
  bool paused = false;

  AnalyzerOutput rejected(
    PoseFrame frame,
    TrackingStatus tracking,
    FeedbackCode code,
  ) {
    smoother.trackingLost(frame.timestamp);
    var incomplete = false;
    final activeStart = machine.repStartTimestamp;
    if (machine.isActiveRep &&
        lastTimestamp != null &&
        frame.timestamp - lastTimestamp! >= config.smoothing.resetGap) {
      incomplete = machine.abandonActiveRep();
      if (incomplete) {
        markIncomplete(frame.timestamp, incompleteFeedback, start: activeStart);
      }
    }
    final codes = feedback.generate(frame.timestamp, [
      if (incomplete) FeedbackCode.trackingLost,
      code,
    ]);
    sessionFeedback.addAll(codes);
    return output(
      frame.timestamp,
      tracking: tracking,
      feedbackCodes: codes,
      formValid: false,
      incomplete: incomplete,
    );
  }

  AnalyzerOutput output(
    Duration timestamp, {
    required TrackingStatus tracking,
    Map<String, double> angles = const {},
    List<FeedbackCode> feedbackCodes = const [],
    bool formValid = true,
    bool completed = false,
    bool incomplete = false,
    RepResult? rep,
  }) => AnalyzerOutput(
    exerciseType: type,
    currentState: machine.currentState,
    stageLabel: stageLabel(machine.currentState),
    totalCompletedReps: results.where((r) => r.completed).length,
    repCompleted: completed,
    incompleteRepDetected: incomplete,
    jointAngles: Map.unmodifiable(angles),
    trackingStatus: tracking,
    formValid: formValid,
    feedbackCodes: List.unmodifiable(feedbackCodes),
    completedRep: rep,
    timestamp: timestamp,
  );
  String stageLabel(ExerciseState state);
  void begin(Duration timestamp) {
    sessionStart ??= timestamp;
  }

  RepResult complete(
    Duration timestamp,
    double min,
    double max,
    bool formValid,
    Set<FeedbackCode> issues, {
    Duration? start,
  }) {
    final rep = RepResult(
      repNumber: results.where((r) => r.completed).length + 1,
      startTime: start ?? timestamp,
      endTime: timestamp,
      completed: true,
      formValid: formValid,
      feedbackCodes: List.unmodifiable(issues),
      minimumAngle: min,
      maximumAngle: max,
    );
    results.add(rep);
    return rep;
  }

  void markIncomplete(
    Duration timestamp,
    FeedbackCode code, {
    Duration? start,
  }) {
    incompleteCount++;
    results.add(
      RepResult(
        repNumber: results.length + 1,
        startTime: start ?? machine.repStartTimestamp ?? timestamp,
        endTime: timestamp,
        completed: false,
        formValid: false,
        feedbackCodes: [code],
      ),
    );
    sessionFeedback.add(code);
  }

  @override
  void pause() {
    paused = true;
    machine.pause();
  }

  @override
  void resume() {
    paused = false;
    machine.resume();
    smoother.reset();
  }

  @override
  void reset() {
    paused = false;
    machine.reset();
    smoother.reset();
    visibility.reset();
    feedback.reset();
    results.clear();
    sessionFeedback.clear();
    incompleteCount = 0;
    sessionStart = null;
    lastTimestamp = null;
    resetExercise();
  }

  void resetExercise() {}
  @override
  ExerciseResult finishSession([Duration? timestamp]) {
    final end = timestamp ?? lastTimestamp ?? Duration.zero;
    final activeStart = machine.repStartTimestamp;
    if (machine.abandonActiveRep()) {
      markIncomplete(end, incompleteFeedback, start: activeStart);
    }
    return ExerciseResult(
      exerciseType: type,
      completedRepCount: results.where((r) => r.completed).length,
      incompleteRepCount: results.where((r) => !r.completed).length,
      validFormRepCount: results
          .where((r) => r.completed && r.formValid)
          .length,
      sessionStart: sessionStart ?? end,
      sessionEnd: end,
      repResults: List.unmodifiable(results),
      feedbackSummary: List.unmodifiable(sessionFeedback),
    );
  }

  FeedbackCode get incompleteFeedback;
}
