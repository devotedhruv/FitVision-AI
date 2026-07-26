import 'dart:async';

import 'package:fitvision_ai/features/exercise/data/services/camera_permission_service.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pose_landmarker/pose_landmarker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveExerciseViewModel extends Notifier<LivePoseSessionState> {
  final CameraPermissionService _permissions = const CameraPermissionService();
  StreamSubscription<PoseResult>? _poseSubscription;
  Timer? _countdownTimer;
  Timer? _sessionTimer;
  bool _ending = false;

  @override
  LivePoseSessionState build() {
    ref.onDispose(_dispose);
    unawaited(_loadPreferences());
    return const LivePoseSessionState();
  }

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
    final resumeReady =
        state.resumingSession &&
        result.status == PoseStatus.poseDetected &&
        result.poseDetected &&
        result.landmarks.length == 33;
    if (resumeReady) {
      nextStage = LivePoseStage.active;
    } else if (!state.resumingSession &&
        nextStage == LivePoseStage.initializing &&
        (result.status == PoseStatus.ready || result.imageWidth > 0)) {
      nextStage = LivePoseStage.positioning;
    }
    final countdownLostTracking =
        nextStage == LivePoseStage.countdown &&
        result.status != PoseStatus.poseDetected;
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
      feedback: resumeReady
          ? 'Tracking restored. Session resumed.'
          : _feedbackFor(result),
    );
    if (resumeReady) _startSessionTimer();
  }

  void startCountdown({Duration tickDuration = const Duration(seconds: 1)}) {
    if (state.stage != LivePoseStage.positioning || !state.fullBodyReady) {
      state = state.copyWith(
        feedback:
            'Move back until shoulders, hips, knees and ankles are visible.',
      );
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
          stage: LivePoseStage.active,
          clearCountdown: true,
          feedback: 'Tracking active. Rep analysis begins in Phase 5.',
        );
        _startSessionTimer();
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
    _sessionTimer?.cancel();
    await PoseLandmarkerController.instance.pause();
    if (!ref.mounted) return;
    state = state.copyWith(
      stage: LivePoseStage.paused,
      resumingSession: false,
      feedback: 'Session paused. Camera resources are suspended.',
    );
  }

  Future<void> resume() async {
    if (state.stage != LivePoseStage.paused) return;
    state = state.copyWith(
      stage: LivePoseStage.initializing,
      resumingSession: true,
      clearPose: true,
      feedback: 'Revalidating camera and pose model.',
    );
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

  Future<void> end() async {
    if (_ending) return;
    _ending = true;
    _cancelCountdown();
    _sessionTimer?.cancel();
    await PoseLandmarkerController.instance.dispose();
    if (ref.mounted) {
      state = state.copyWith(
        stage: LivePoseStage.completed,
        resumingSession: false,
        clearCountdown: true,
        clearPose: true,
        feedback: 'Camera session ended.',
      );
    }
    _ending = false;
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
        state = state.copyWith(
          elapsed: state.elapsed + const Duration(seconds: 1),
        );
      }
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
