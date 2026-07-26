import 'dart:async';

import 'package:fitvision_ai/features/exercise/data/services/camera_permission_service.dart';
import 'package:fitvision_ai/features/exercise/data/mediapipe_pose_frame_adapter.dart';
import 'package:fitvision_ai/features/exercise/application/exercise_feedback_controller.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/features/exercise/domain/models/exercise_analysis_state.dart';
import 'package:exercise_engine/exercise_engine.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/exercise/data/workout_providers.dart';
import 'package:fitvision_ai/features/exercise/domain/models/rep_event.dart'
    as domain;
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart'
    as domain;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pose_landmarker/pose_landmarker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LiveExerciseViewModel extends Notifier<LivePoseSessionState> {
  final CameraPermissionService _permissions = const CameraPermissionService();
  StreamSubscription<PoseResult>? _poseSubscription;
  Timer? _countdownTimer;
  Timer? _sessionTimer;
  bool _ending = false;
  ExerciseAnalyzer? _analyzer;
  ExerciseResult? _result;
  final ExerciseFeedbackController _effects = ExerciseFeedbackController();
  int _lastAnalyzedTimestamp = -1;
  String _exerciseId = '';
  domain.WorkoutSession? _workout;
  Future<void> _persistenceChain = Future.value();
  final Set<String> _recordedRepKeys = {};
  int _nextSequence = 1;
  final Uuid _uuid = const Uuid();

  @override
  LivePoseSessionState build() {
    ref.onDispose(_dispose);
    unawaited(_loadPreferences());
    return const LivePoseSessionState();
  }

  void configureExercise(String exerciseId) {
    if (_exerciseId == exerciseId) return;
    _exerciseId = exerciseId;
    _analyzer = switch (exerciseId) {
      'squat' => SquatAnalyzer(),
      'bicep-curl' => CurlAnalyzer(),
      'push-up' => PushupAnalyzer(),
      _ => null,
    };
    _analyzer?.reset();
  }

  ExerciseResult? get result => _result;
  domain.WorkoutSession? get persistedWorkout => _workout;

  Future<void> initializeCamera() async {
    if (state.stage != LivePoseStage.guide &&
        state.stage != LivePoseStage.error) {
      return;
    }
    final permission = await _permissions.request();
    if (!ref.mounted) return;
    if (permission != CameraPermissionState.granted) {
      state = state.copyWith(
        permission: permission,
        stage: LivePoseStage.error,
        feedback: permission == CameraPermissionState.permanentlyDenied
            ? 'Camera access is blocked. Open Settings to allow it.'
            : 'Camera permission is required for pose tracking.',
      );
      return;
    }
    state = state.copyWith(
      permission: permission,
      stage: LivePoseStage.initializing,
      feedback: 'Loading the on-device pose model and camera.',
    );
    await _loadRecoveredWorkout();
    await _poseSubscription?.cancel();
    _poseSubscription = PoseLandmarkerController.instance.results.listen(
      onPoseResult,
      onError: (Object error) {
        if (!ref.mounted) return;
        state = state.copyWith(
          stage: LivePoseStage.error,
          feedback: 'The camera pipeline stopped. Please retry.',
        );
      },
    );
  }

  @visibleForTesting
  void prepareCameraForTest() {
    if (_exerciseId.isEmpty) {
      _exerciseId = 'squat';
      _analyzer = SquatAnalyzer();
    }
    state = state.copyWith(
      permission: CameraPermissionState.granted,
      stage: LivePoseStage.initializing,
    );
  }

  void onPoseResult(PoseResult result) {
    if (!ref.mounted || state.stage == LivePoseStage.completed) return;
    if (result.status == PoseStatus.modelError ||
        result.status == PoseStatus.cameraError) {
      state = state.copyWith(
        stage: LivePoseStage.error,
        resumingSession: false,
        latestPose: result,
        feedback: result.message ?? 'Pose camera initialization failed.',
      );
      return;
    }
    if (result.status == PoseStatus.permissionDenied) {
      state = state.copyWith(
        stage: LivePoseStage.error,
        resumingSession: false,
        latestPose: result,
        feedback: 'Camera permission is required.',
      );
      return;
    }
    final isFrame = result.imageWidth > 0;
    final nextTotal = state.totalFrames + (isFrame ? 1 : 0);
    final nextDetected =
        state.detectedFrames + (isFrame && result.poseDetected ? 1 : 0);
    var nextStage = state.stage;
    final exerciseReady = _isExerciseReady(result);
    final resumeReady = state.resumingSession && exerciseReady;
    if (resumeReady) {
      nextStage = LivePoseStage.active;
    } else if (!state.resumingSession &&
        nextStage == LivePoseStage.initializing &&
        (result.status == PoseStatus.ready || result.imageWidth > 0)) {
      nextStage = LivePoseStage.positioning;
    }
    final countdownLostTracking =
        nextStage == LivePoseStage.countdown && !exerciseReady;
    if (countdownLostTracking) {
      _cancelCountdown();
      nextStage = LivePoseStage.positioning;
    }
    state = state.copyWith(
      stage: nextStage,
      resumingSession: resumeReady ? false : state.resumingSession,
      clearCountdown: countdownLostTracking,
      latestPose: result,
      detectedFrames: nextDetected,
      totalFrames: nextTotal,
      totalLatencyMs:
          state.totalLatencyMs + (isFrame ? result.inferenceLatencyMs : 0),
      analysisReady: exerciseReady,
      feedback: resumeReady
          ? 'Tracking restored. Session resumed.'
          : exerciseReady
          ? 'Required landmarks detected. Ready to start.'
          : _feedbackFor(result),
    );
    if (nextStage == LivePoseStage.active && !resumeReady) {
      _processAnalysis(result);
    }
    if (resumeReady) _startSessionTimer();
  }

  void _processAnalysis(PoseResult result) {
    final analyzer = _analyzer;
    if (analyzer == null || result.timestampMs - _lastAnalyzedTimestamp < 66) {
      return;
    }
    _lastAnalyzedTimestamp = result.timestampMs;
    final output = analyzer.processFrame(
      MediaPipePoseFrameAdapter.convert(result),
    );
    if (output.completedRep != null) _queueRep(output.completedRep!);
    final shortFeedback = output.feedbackCodes.isEmpty
        ? state.analysis.shortFeedback
        : ExerciseFeedbackText.forCode(output.feedbackCodes.first);
    state = state.copyWith(
      analysis: ExerciseAnalysisState(
        stage: switch (output.stageLabel) {
          'UP' => ExerciseStage.up,
          'DOWN' => ExerciseStage.down,
          'HOLD' => ExerciseStage.hold,
          _ => ExerciseStage.ready,
        },
        repCount: output.totalCompletedReps,
        validRepCount:
            output.totalCompletedReps -
            (output.completedRep?.formValid == false ? 1 : 0),
        invalidRepCount: output.completedRep?.formValid == false ? 1 : 0,
        formStatus: output.trackingStatus.accepted
            ? (output.formValid ? 'FORM OK' : 'ADJUST FORM')
            : 'TRACKING',
        shortFeedback: shortFeedback,
      ),
      feedback: shortFeedback,
    );
    unawaited(
      _effects.handle(
        output.feedbackCodes,
        audio: state.audioEnabled,
        haptics: state.hapticsEnabled,
        active: state.stage == LivePoseStage.active,
      ),
    );
  }

  void startCountdown({Duration tickDuration = const Duration(seconds: 1)}) {
    if (state.stage != LivePoseStage.positioning || !state.analysisReady) {
      state = state.copyWith(feedback: _positioningGuidance);
      return;
    }
    _countdownTimer?.cancel();
    state = state.copyWith(stage: LivePoseStage.countdown, countdown: 3);
    _countFeedback();
    _countdownTimer = Timer.periodic(tickDuration, (timer) {
      if (!ref.mounted || state.stage != LivePoseStage.countdown) {
        timer.cancel();
        return;
      }
      final current = state.countdown ?? 3;
      if (current > 1) {
        state = state.copyWith(countdown: current - 1);
        _countFeedback();
      } else {
        timer.cancel();
        state = state.copyWith(
          localSaving: true,
          clearCountdown: true,
          feedback: 'Saving workout on this device.',
        );
        unawaited(_startPersistedWorkout());
      }
    });
  }

  void cancelCountdown() {
    if (state.stage != LivePoseStage.countdown) return;
    _cancelCountdown();
    state = state.copyWith(
      stage: LivePoseStage.positioning,
      clearCountdown: true,
      feedback: 'Countdown cancelled.',
    );
  }

  Future<void> pause() async {
    if (state.stage != LivePoseStage.active) return;
    state = state.copyWith(localSaving: true);
    final workout = _workout;
    if (workout == null) return;
    try {
      _workout = await ref
          .read(workoutRepositoryProvider)
          .pause(workout.localId);
    } on Object {
      state = state.copyWith(
        localSaving: false,
        feedback: 'Could not pause and save the workout.',
      );
      return;
    }
    _sessionTimer?.cancel();
    _analyzer?.pause();
    await PoseLandmarkerController.instance.pause();
    if (!ref.mounted) return;
    state = state.copyWith(
      stage: LivePoseStage.paused,
      resumingSession: false,
      feedback: 'Session paused. Camera resources are suspended.',
      localSaving: false,
      elapsed: _workout!.accumulatedActiveDuration,
    );
  }

  Future<void> resume() async {
    if (state.stage != LivePoseStage.paused) return;
    final workout = _workout;
    if (workout == null) return;
    state = state.copyWith(localSaving: true);
    try {
      _workout = await ref
          .read(workoutRepositoryProvider)
          .resume(workout.localId);
    } on Object {
      state = state.copyWith(
        localSaving: false,
        feedback: 'Could not resume the saved workout.',
      );
      return;
    }
    state = state.copyWith(
      stage: LivePoseStage.initializing,
      resumingSession: true,
      clearPose: true,
      feedback: 'Revalidating camera and pose model.',
      localSaving: false,
    );
    _analyzer?.resume();
    await PoseLandmarkerController.instance.resume();
  }

  Future<void> switchCamera() async {
    if (state.stage == LivePoseStage.active ||
        state.stage == LivePoseStage.countdown) {
      return;
    }
    await PoseLandmarkerController.instance.switchCamera();
    if (!ref.mounted) return;
    state = state.copyWith(
      frontCamera: !state.frontCamera,
      stage: LivePoseStage.initializing,
      clearPose: true,
      feedback: 'Switching camera.',
    );
  }

  Future<ExerciseResult?> end() async {
    if (_ending) return _result;
    _ending = true;
    _cancelCountdown();
    _sessionTimer?.cancel();
    _result = _analyzer?.finishSession(
      Duration(milliseconds: state.latestPose?.timestampMs ?? 0),
    );
    for (final rep in _result?.repResults ?? const <RepResult>[]) {
      _queueRep(rep);
    }
    try {
      await _persistenceChain;
    } on Object {
      _ending = false;
      state = state.copyWith(
        localSaving: false,
        feedback: 'Could not save the workout. Please try again.',
      );
      return null;
    }
    final workout = _workout;
    if (workout != null) {
      try {
        _workout = await ref
            .read(workoutRepositoryProvider)
            .end(workout.localId);
      } on Object {
        _ending = false;
        state = state.copyWith(
          localSaving: false,
          feedback: 'Could not save the workout. Please try again.',
        );
        return null;
      }
    }
    await PoseLandmarkerController.instance.dispose();
    if (ref.mounted) {
      state = state.copyWith(
        stage: LivePoseStage.completed,
        resumingSession: false,
        clearCountdown: true,
        clearPose: true,
        feedback: 'Camera session ended.',
        localSaving: false,
      );
    }
    _ending = false;
    if (_workout != null) {
      unawaited(ref.read(syncManagerProvider).synchronize());
    }
    return _result;
  }

  Future<void> openSettings() => _permissions.openApplicationSettings();

  void toggleAudio() {
    final value = !state.audioEnabled;
    state = state.copyWith(audioEnabled: value);
    unawaited(_savePreference('pose_audio', value));
  }

  void toggleHaptics() {
    final value = !state.hapticsEnabled;
    state = state.copyWith(hapticsEnabled: value);
    unawaited(_savePreference('pose_haptics', value));
  }

  String _feedbackFor(PoseResult result) => switch (result.status) {
    PoseStatus.poseDetected => 'Full-body landmarks detected. Ready to start.',
    PoseStatus.partialPose => 'Move back so your full body is visible.',
    PoseStatus.poorVisibility => 'Improve lighting and keep your body visible.',
    PoseStatus.noPose => 'Move into the center of the frame.',
    PoseStatus.ready => result.message ?? 'Camera ready.',
    PoseStatus.paused => 'Pose detection paused.',
    _ => result.message ?? 'Hold still while tracking initializes.',
  };

  String get _positioningGuidance => switch (_exerciseId) {
    'push-up' => 'Keep one shoulder, elbow and wrist clearly visible.',
    'bicep-curl' => 'Keep one complete arm clearly visible.',
    'squat' => 'Keep one hip, knee and ankle clearly visible.',
    _ => 'Move fully into the camera frame.',
  };

  bool _isExerciseReady(PoseResult result) {
    if (!result.poseDetected || result.landmarks.length != 33) return false;
    const threshold = .60;
    bool visible(int index) =>
        result.landmarks[index].visibility >= threshold &&
        result.landmarks[index].presence >= threshold;
    bool eitherSide(List<int> left, List<int> right) =>
        left.every(visible) || right.every(visible);
    return switch (_exerciseId) {
      'push-up' ||
      'bicep-curl' => eitherSide(const [11, 13, 15], const [12, 14, 16]),
      'squat' => eitherSide(const [23, 25, 27], const [24, 26, 28]),
      _ => result.status == PoseStatus.poseDetected,
    };
  }

  void _countFeedback() {
    if (state.hapticsEnabled) unawaited(HapticFeedback.mediumImpact());
    if (state.audioEnabled) {
      unawaited(SystemSound.play(SystemSoundType.click));
    }
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (ref.mounted && state.stage == LivePoseStage.active) {
        final workout = _workout;
        state = state.copyWith(
          elapsed:
              workout?.activeDurationAt(DateTime.now().toUtc()) ??
              state.elapsed,
        );
      }
    });
  }

  Future<void> _startPersistedWorkout() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    final type = switch (_exerciseId) {
      'squat' => domain.WorkoutExerciseType.squat,
      'bicep-curl' => domain.WorkoutExerciseType.curl,
      'push-up' => domain.WorkoutExerciseType.pushup,
      _ => null,
    };
    if (user == null || type == null) {
      state = state.copyWith(
        stage: LivePoseStage.error,
        localSaving: false,
        feedback: user == null
            ? 'Sign in before starting a workout.'
            : 'This exercise is not available for rep tracking.',
      );
      return;
    }
    try {
      if (_workout?.status == domain.WorkoutSessionStatus.paused &&
          _workout?.exerciseType == type) {
        _workout = await ref
            .read(workoutRepositoryProvider)
            .resume(_workout!.localId);
        _nextSequence = _workout!.repEvents.length + 1;
      } else {
        _workout = await ref
            .read(workoutRepositoryProvider)
            .start(userId: user.id, exerciseType: type);
        _nextSequence = 1;
      }
      _analyzer?.reset();
      _result = null;
      _lastAnalyzedTimestamp = -1;
      _recordedRepKeys.clear();
      state = state.copyWith(
        stage: LivePoseStage.active,
        localSaving: false,
        workoutLocalId: _workout!.localId,
        elapsed: Duration.zero,
        feedback: 'Workout saved on this device. Begin when ready.',
      );
      _startSessionTimer();
    } on Object {
      state = state.copyWith(
        stage: LivePoseStage.positioning,
        localSaving: false,
        feedback: 'Could not save the workout. Please try again.',
      );
    }
  }

  Future<void> _loadRecoveredWorkout() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null || _workout != null) return;
    final recovered = await ref
        .read(workoutRepositoryProvider)
        .recover(user.id);
    final expected = switch (_exerciseId) {
      'squat' => domain.WorkoutExerciseType.squat,
      'bicep-curl' => domain.WorkoutExerciseType.curl,
      'push-up' => domain.WorkoutExerciseType.pushup,
      _ => null,
    };
    if (recovered != null &&
        recovered.exerciseType == expected &&
        ref.mounted) {
      _workout = recovered;
      _nextSequence = recovered.repEvents.length + 1;
      state = state.copyWith(
        elapsed: recovered.accumulatedActiveDuration,
        workoutLocalId: recovered.localId,
        feedback: 'A paused workout is saved. Set up the camera to resume it.',
      );
    }
  }

  void _queueRep(RepResult rep) {
    final workout = _workout;
    if (workout == null) return;
    final key =
        '${rep.startTime.inMilliseconds}:${rep.endTime.inMilliseconds}:${rep.completed}';
    if (!_recordedRepKeys.add(key)) return;
    final endedAt = DateTime.now().toUtc();
    final event = domain.RepEvent(
      localId: _uuid.v4(),
      workoutLocalId: workout.localId,
      sequenceNumber: _nextSequence++,
      eventType: rep.completed
          ? domain.RepEventType.completed
          : domain.RepEventType.incomplete,
      exerciseType: workout.exerciseType,
      startedAt: endedAt.subtract(rep.duration),
      endedAt: endedAt,
      duration: rep.duration,
      formValid: rep.formValid,
      minimumPrimaryAngle: rep.minimumAngle,
      maximumPrimaryAngle: rep.maximumAngle,
      feedbackCodes: rep.feedbackCodes
          .map((code) => code.name)
          .toList(growable: false),
      createdAt: endedAt,
    );
    _persistenceChain = _persistenceChain.then((_) async {
      _workout = await ref.read(workoutRepositoryProvider).recordRep(event);
    });
  }

  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    state = state.copyWith(
      audioEnabled: preferences.getBool('pose_audio') ?? true,
      hapticsEnabled: preferences.getBool('pose_haptics') ?? true,
      frontCamera: preferences.getBool('pose_front_camera') ?? true,
      debugOverlay: preferences.getBool('pose_debug_overlay') ?? false,
    );
  }

  Future<void> _savePreference(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  void _dispose() {
    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    unawaited(_poseSubscription?.cancel());
    unawaited(PoseLandmarkerController.instance.dispose());
  }
}

final liveExerciseProvider =
    NotifierProvider.autoDispose<LiveExerciseViewModel, LivePoseSessionState>(
      LiveExerciseViewModel.new,
    );
