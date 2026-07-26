import '../config/exercise_engine_config.dart';
import '../feedback/feedback_code.dart';
import '../geometry/angle_calculator.dart';
import '../geometry/vector_math.dart';
import '../models/analyzer_output.dart';
import '../models/pose_frame.dart';
import '../models/pose_landmark.dart';
import '../models/rep_result.dart';
import '../state_machine/exercise_state.dart';
import 'base_analyzer.dart';

class CurlAnalyzer extends BaseAnalyzer {
  CurlAnalyzer([ExerciseEngineConfig config = const ExerciseEngineConfig()])
    : super(ExerciseType.bicepsCurl, config, ExerciseState.extended, const [
        ExerciseState.extended,
        ExerciseState.flexing,
        ExerciseState.contracted,
        ExerciseState.extending,
      ]);
  double? _min, _max;
  Duration? _start;
  PoseLandmark? _initialElbow;
  final Set<FeedbackCode> _issues = {};
  BodySide? get selectedSide => visibility.selectedSide;
  @override
  FeedbackCode get incompleteFeedback => FeedbackCode.curlIncompleteRep;
  @override
  String stageLabel(ExerciseState state) => switch (state) {
    ExerciseState.extended => 'DOWN',
    ExerciseState.flexing => 'UP',
    ExerciseState.contracted => 'HOLD',
    ExerciseState.extending => 'DOWN',
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
      ],
      const [
        LandmarkType.rightShoulder,
        LandmarkType.rightElbow,
        LandmarkType.rightWrist,
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
      return rejected(frame, tracking, FeedbackCode.curlKeepArmVisible);
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
    _initialElbow ??= elbow;
    final shoulderWidth = VectorMath.distance(
      smooth.landmark(LandmarkType.leftShoulder) ?? shoulder,
      smooth.landmark(LandmarkType.rightShoulder) ?? shoulder,
    );
    final displacement = shoulderWidth == null
        ? null
        : VectorMath.normalizedDisplacement(
            _initialElbow!,
            elbow,
            shoulderWidth,
          );
    final stable =
        displacement == null ||
        displacement <= config.curl.upperArmDisplacementTolerance;
    if (!stable) _issues.add(FeedbackCode.curlKeepUpperArmStable);
    _min = _min == null || a < _min! ? a : _min;
    _max = _max == null || a > _max! ? a : _max;
    final candidate = switch (machine.currentState) {
      ExerciseState.extended when a < config.curl.flexingAngle =>
        ExerciseState.flexing,
      ExerciseState.flexing when a <= config.curl.contractedAngle =>
        ExerciseState.contracted,
      ExerciseState.contracted when a > config.curl.extendingAngle =>
        ExerciseState.extending,
      ExerciseState.extending when a >= config.curl.extendedAngle =>
        ExerciseState.extended,
      _ => machine.currentState,
    };
    if (machine.currentState == ExerciseState.extended &&
        candidate == ExerciseState.flexing) {
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
      if (!stable) FeedbackCode.curlKeepUpperArmStable,
      if (machine.currentState == ExerciseState.flexing &&
          a > config.curl.contractedAngle)
        FeedbackCode.curlCompleteContraction,
      if (machine.currentState == ExerciseState.extending &&
          a < config.curl.extendedAngle)
        FeedbackCode.curlFullyExtendArm,
      if (rep != null) FeedbackCode.repCompleted,
    ];
    final codes = feedback.generate(frame.timestamp, conditions);
    sessionFeedback.addAll(codes);
    return output(
      frame.timestamp,
      tracking: tracking,
      angles: {'elbow': a},
      feedbackCodes: codes,
      formValid: stable,
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
    _initialElbow = null;
    _issues.clear();
  }
}
