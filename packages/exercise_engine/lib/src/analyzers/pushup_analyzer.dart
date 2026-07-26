import '../config/exercise_engine_config.dart';
import '../feedback/feedback_code.dart';
import '../geometry/angle_calculator.dart';
import '../models/analyzer_output.dart';
import '../models/pose_frame.dart';
import '../models/pose_landmark.dart';
import '../models/rep_result.dart';
import '../state_machine/exercise_state.dart';
import 'base_analyzer.dart';

class PushupAnalyzer extends BaseAnalyzer {
  PushupAnalyzer([ExerciseEngineConfig config = const ExerciseEngineConfig()])
    : super(ExerciseType.pushup, config, ExerciseState.top, const [
        ExerciseState.top,
        ExerciseState.descending,
        ExerciseState.bottom,
        ExerciseState.ascending,
      ]);
  double? _min, _max;
  Duration? _start;
  final Set<FeedbackCode> _issues = {};
  @override
  FeedbackCode get incompleteFeedback => FeedbackCode.pushupIncompleteRep;
  @override
  String stageLabel(ExerciseState state) => switch (state) {
    ExerciseState.top => 'UP',
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
        LandmarkType.leftShoulder,
        LandmarkType.leftElbow,
        LandmarkType.leftWrist,
        LandmarkType.leftHip,
        LandmarkType.leftAnkle,
      ],
      const [
        LandmarkType.rightShoulder,
        LandmarkType.rightElbow,
        LandmarkType.rightWrist,
        LandmarkType.rightHip,
        LandmarkType.rightAnkle,
      ],
    );
    final required = side == BodySide.left
        ? const [
            LandmarkType.leftShoulder,
            LandmarkType.leftElbow,
            LandmarkType.leftWrist,
          ]
        : const [
            LandmarkType.rightShoulder,
            LandmarkType.rightElbow,
            LandmarkType.rightWrist,
          ];
    final tracking = visibility.evaluate(
      frame,
      required,
      warning: FeedbackCode.upperBodyNotVisible,
    );
    if (!tracking.accepted) {
      return rejected(frame, tracking, FeedbackCode.pushupKeepBodyVisible);
    }
    lastTimestamp = frame.timestamp;
    final smooth = smoother.smooth(frame);
    final shoulder = smooth.landmark(required[0])!,
        elbow = smooth.landmark(required[1])!,
        wrist = smooth.landmark(required[2])!;
    final a = AngleCalculator.angle2D(shoulder, elbow, wrist);
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
    final hipType = side == BodySide.left
        ? LandmarkType.leftHip
        : LandmarkType.rightHip;
    final ankleType = side == BodySide.left
        ? LandmarkType.leftAnkle
        : LandmarkType.rightAnkle;
    final alignmentTracking = visibility.evaluate(smooth, [
      required[0],
      hipType,
      ankleType,
    ]);
    double? alignment;
    if (alignmentTracking.accepted) {
      alignment = AngleCalculator.bodyAlignment(
        shoulder,
        smooth.landmark(hipType)!,
        smooth.landmark(ankleType)!,
      );
    }
    final aligned =
        alignment == null || alignment >= config.pushup.alignmentAngle;
    if (!aligned) _issues.add(FeedbackCode.pushupKeepBodyAligned);
    _min = _min == null || a < _min! ? a : _min;
    _max = _max == null || a > _max! ? a : _max;
    final candidate = switch (machine.currentState) {
      ExerciseState.top when a < config.pushup.descendingAngle =>
        ExerciseState.descending,
      ExerciseState.descending when a <= config.pushup.bottomAngle =>
        ExerciseState.bottom,
      ExerciseState.bottom when a > config.pushup.ascendingAngle =>
        ExerciseState.ascending,
      ExerciseState.ascending when a >= config.pushup.topAngle =>
        ExerciseState.top,
      _ => machine.currentState,
    };
    if (machine.currentState == ExerciseState.top &&
        candidate == ExerciseState.descending) {
      _start = frame.timestamp;
      _min = a;
      _max = a;
      _issues.clear();
    }
    final transition = machine.propose(candidate, frame.timestamp);
    RepResult? rep;
    if (transition.incomplete) {
      markIncomplete(frame.timestamp, incompleteFeedback);
    }
    if (transition.repCompleted) {
      rep = complete(
        frame.timestamp,
        _min!,
        _max!,
        _issues.isEmpty,
        _issues,
        start: _start,
      );
    }
    final conditions = <FeedbackCode>[
      if (!aligned) FeedbackCode.pushupKeepBodyAligned,
      if (machine.currentState == ExerciseState.descending &&
          a > config.pushup.bottomAngle)
        FeedbackCode.pushupGoLower,
      if (machine.currentState == ExerciseState.ascending &&
          a < config.pushup.topAngle)
        FeedbackCode.pushupFullyExtendArms,
      if (rep != null) FeedbackCode.repCompleted,
    ];
    final codes = feedback.generate(frame.timestamp, conditions);
    sessionFeedback.addAll(codes);
    final angles = <String, double>{'elbow': a, 'bodyAlignment': ?alignment};
    return output(
      frame.timestamp,
      tracking: tracking,
      angles: angles,
      feedbackCodes: codes,
      formValid: aligned,
      completed: rep != null,
      incomplete: transition.incomplete,
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
