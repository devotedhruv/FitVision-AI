import '../config/exercise_engine_config.dart';
import '../feedback/feedback_code.dart';
import '../geometry/angle_calculator.dart';
import '../models/analyzer_output.dart';
import '../models/pose_frame.dart';
import '../models/pose_landmark.dart';
import '../models/rep_result.dart';
import '../state_machine/exercise_state.dart';
import 'base_analyzer.dart';

class SquatAnalyzer extends BaseAnalyzer {
  SquatAnalyzer([ExerciseEngineConfig config = const ExerciseEngineConfig()])
    : super(ExerciseType.squat, config, ExerciseState.standing, const [
        ExerciseState.standing,
        ExerciseState.descending,
        ExerciseState.bottom,
        ExerciseState.ascending,
      ]);
  double? _min, _max;
  Duration? _start;
  final Set<FeedbackCode> _issues = {};
  @override
  FeedbackCode get incompleteFeedback => FeedbackCode.squatIncompleteRep;
  @override
  String stageLabel(ExerciseState state) => switch (state) {
    ExerciseState.standing => 'UP',
    ExerciseState.descending => 'DOWN',
    ExerciseState.bottom => 'HOLD',
    ExerciseState.ascending => 'UP',
    ExerciseState.paused => 'PAUSED',
    _ => 'READY',
  };

  @override
  AnalyzerOutput processFrame(PoseFrame frame) {
    begin(frame.timestamp);
    if (paused) {
      return output(
        frame.timestamp,
        tracking: const TrackingStatus(accepted: true),
      );
    }
    final side = visibility.selectSide(
      frame,
      const [
        LandmarkType.leftHip,
        LandmarkType.leftKnee,
        LandmarkType.leftAnkle,
      ],
      const [
        LandmarkType.rightHip,
        LandmarkType.rightKnee,
        LandmarkType.rightAnkle,
      ],
    );
    final required = side == BodySide.left
        ? const [
            LandmarkType.leftHip,
            LandmarkType.leftKnee,
            LandmarkType.leftAnkle,
          ]
        : const [
            LandmarkType.rightHip,
            LandmarkType.rightKnee,
            LandmarkType.rightAnkle,
          ];
    final tracking = visibility.evaluate(
      frame,
      required,
      warning: FeedbackCode.lowerBodyNotVisible,
    );
    if (!tracking.accepted) {
      return rejected(frame, tracking, FeedbackCode.squatKeepBodyVisible);
    }
    lastTimestamp = frame.timestamp;
    final smooth = smoother.smooth(frame);
    final a = AngleCalculator.angle2D(
      smooth.landmark(required[0])!,
      smooth.landmark(required[1])!,
      smooth.landmark(required[2])!,
    );
    if (a == null) {
      return rejected(
        frame,
        const TrackingStatus(
          accepted: false,
          warning: FeedbackCode.lowLandmarkConfidence,
        ),
        FeedbackCode.lowLandmarkConfidence,
      );
    }
    _min = _min == null || a < _min! ? a : _min;
    _max = _max == null || a > _max! ? a : _max;
    final candidate = switch (machine.currentState) {
      ExerciseState.standing when a < config.squat.descendingAngle =>
        ExerciseState.descending,
      ExerciseState.descending when a <= config.squat.bottomAngle =>
        ExerciseState.bottom,
      ExerciseState.bottom when a > config.squat.ascendingAngle =>
        ExerciseState.ascending,
      ExerciseState.ascending when a >= config.squat.standingAngle =>
        ExerciseState.standing,
      _ => machine.currentState,
    };
    if (machine.currentState == ExerciseState.standing &&
        candidate == ExerciseState.descending) {
      _start = frame.timestamp;
      _min = a;
      _max = a;
      _issues.clear();
    }
    final transition = machine.propose(candidate, frame.timestamp);
    final incomplete = transition.incomplete;
    RepResult? rep;
    if (incomplete) markIncomplete(frame.timestamp, incompleteFeedback);
    if (transition.repCompleted) {
      rep = complete(
        frame.timestamp,
        _min!,
        _max!,
        true,
        _issues,
        start: _start,
      );
    }
    final conditions = <FeedbackCode>[];
    if (machine.currentState == ExerciseState.descending &&
        a > config.squat.bottomAngle) {
      conditions.add(FeedbackCode.squatGoLower);
    }
    if (machine.currentState == ExerciseState.ascending &&
        a < config.squat.standingAngle) {
      conditions.add(FeedbackCode.squatReturnToStanding);
    }
    if (rep != null) conditions.add(FeedbackCode.repCompleted);
    final codes = feedback.generate(frame.timestamp, conditions);
    sessionFeedback.addAll(codes);
    return output(
      frame.timestamp,
      tracking: tracking,
      angles: {'knee': a},
      feedbackCodes: codes,
      completed: rep != null,
      incomplete: incomplete,
      rep: rep,
    );
  }

  @override
  void resetExercise() {
    _min = null;
    _max = null;
    _start = null;
    _issues.clear();
  }
}
