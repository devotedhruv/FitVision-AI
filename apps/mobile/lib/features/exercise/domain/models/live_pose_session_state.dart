import 'package:fitvision_ai/features/exercise/domain/models/exercise_analysis_state.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

enum CameraPermissionState { unknown, granted, denied, permanentlyDenied }

enum LivePoseStage {
  guide,
  initializing,
  positioning,
  countdown,
  active,
  paused,
  completed,
  error,
}

class LivePoseSessionState {
  const LivePoseSessionState({
    this.stage = LivePoseStage.guide,
    this.permission = CameraPermissionState.unknown,
    this.countdown,
    this.elapsed = Duration.zero,
    this.latestPose,
    this.feedback = 'Review camera placement before starting.',
    this.audioEnabled = true,
    this.hapticsEnabled = true,
    this.frontCamera = true,
    this.debugOverlay = false,
    this.resumingSession = false,
    this.detectedFrames = 0,
    this.totalFrames = 0,
    this.totalLatencyMs = 0,
    this.analysis = const ExerciseAnalysisState(),
    this.analysisReady = false,
  });

  final LivePoseStage stage;
  final CameraPermissionState permission;
  final int? countdown;
  final Duration elapsed;
  final PoseResult? latestPose;
  final String feedback;
  final bool audioEnabled;
  final bool hapticsEnabled;
  final bool frontCamera;
  final bool debugOverlay;
  final bool resumingSession;
  final int detectedFrames;
  final int totalFrames;
  final double totalLatencyMs;
  final ExerciseAnalysisState analysis;
  final bool analysisReady;

  double get detectedFramePercentage =>
      totalFrames == 0 ? 0 : detectedFrames * 100 / totalFrames;
  double get averageLatencyMs =>
      totalFrames == 0 ? 0 : totalLatencyMs / totalFrames;
  bool get fullBodyReady =>
      latestPose?.status == PoseStatus.poseDetected &&
      latestPose?.landmarks.length == 33;

  LivePoseSessionState copyWith({
    LivePoseStage? stage,
    CameraPermissionState? permission,
    int? countdown,
    bool clearCountdown = false,
    Duration? elapsed,
    PoseResult? latestPose,
    bool clearPose = false,
    String? feedback,
    bool? audioEnabled,
    bool? hapticsEnabled,
    bool? frontCamera,
    bool? debugOverlay,
    bool? resumingSession,
    int? detectedFrames,
    int? totalFrames,
    double? totalLatencyMs,
    ExerciseAnalysisState? analysis,
    bool? analysisReady,
  }) => LivePoseSessionState(
    stage: stage ?? this.stage,
    permission: permission ?? this.permission,
    countdown: clearCountdown ? null : countdown ?? this.countdown,
    elapsed: elapsed ?? this.elapsed,
    latestPose: clearPose ? null : latestPose ?? this.latestPose,
    feedback: feedback ?? this.feedback,
    audioEnabled: audioEnabled ?? this.audioEnabled,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    frontCamera: frontCamera ?? this.frontCamera,
    debugOverlay: debugOverlay ?? this.debugOverlay,
    resumingSession: resumingSession ?? this.resumingSession,
    detectedFrames: detectedFrames ?? this.detectedFrames,
    totalFrames: totalFrames ?? this.totalFrames,
    totalLatencyMs: totalLatencyMs ?? this.totalLatencyMs,
    analysis: analysis ?? this.analysis,
    analysisReady: analysisReady ?? this.analysisReady,
  );
}

class WorkoutResultData {
  const WorkoutResultData({
    required this.exerciseName,
    required this.duration,
    required this.frontCamera,
    required this.detectedFramePercentage,
    required this.averageLatencyMs,
    required this.completed,
    this.completedReps = 0,
    this.incompleteReps = 0,
    this.validFormReps = 0,
    this.feedbackSummary = const [],
  });

  final String exerciseName;
  final Duration duration;
  final bool frontCamera;
  final double detectedFramePercentage;
  final double averageLatencyMs;
  final bool completed;
  final int completedReps;
  final int incompleteReps;
  final int validFormReps;
  final List<String> feedbackSummary;
}
