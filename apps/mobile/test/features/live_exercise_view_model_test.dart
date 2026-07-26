import 'dart:async';

import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view_model.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_landmarker/pose_landmarker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late ProviderSubscription<LivePoseSessionState> subscription;
  const commands = MethodChannel('fitvision/pose_landmarker/commands');
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pose_audio': true,
      'pose_haptics': true,
      'pose_front_camera': true,
      'pose_debug_overlay': false,
    });
    container = ProviderContainer.test();
    subscription = container.listen(liveExerciseProvider, (_, _) {});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(commands, (_) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissions, (call) async {
          if (call.method == 'requestPermissions') {
            return <int, int>{
              Permission.camera.value: PermissionStatus.granted.index,
            };
          }
          if (call.method == 'openAppSettings') return true;
          return null;
        });
  });
  tearDown(() {
    subscription.close();
    container.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(commands, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissions, null);
  });

  test('permission denied keeps the camera feature unavailable', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissions, (call) async {
          if (call.method == 'requestPermissions') {
            return <int, int>{
              Permission.camera.value: PermissionStatus.denied.index,
            };
          }
          return null;
        });

    await container.read(liveExerciseProvider.notifier).initializeCamera();

    final state = container.read(liveExerciseProvider);
    expect(state.permission, CameraPermissionState.denied);
    expect(state.stage, LivePoseStage.error);
    expect(state.feedback, contains('Camera permission is required'));
  });

  test('permanently denied permission can open application settings', () async {
    var openedSettings = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissions, (call) async {
          if (call.method == 'requestPermissions') {
            return <int, int>{
              Permission.camera.value: PermissionStatus.permanentlyDenied.index,
            };
          }
          if (call.method == 'openAppSettings') {
            openedSettings = true;
            return true;
          }
          return null;
        });
    final controller = container.read(liveExerciseProvider.notifier);

    await controller.initializeCamera();
    expect(
      container.read(liveExerciseProvider).permission,
      CameraPermissionState.permanentlyDenied,
    );
    await controller.openSettings();
    expect(openedSettings, isTrue);
  });

  test('pose frame moves initialization to positioning', () {
    final controller = container.read(liveExerciseProvider.notifier)
      ..prepareCameraForTest()
      ..onPoseResult(_result(PoseStatus.poseDetected));
    expect(
      container.read(liveExerciseProvider).stage,
      LivePoseStage.positioning,
    );
    expect(container.read(liveExerciseProvider).fullBodyReady, isTrue);
    expect(controller, isNotNull);
  });

  test('countdown completes with fake time and reps remain zero', () {
    fakeAsync((async) {
      container.read(liveExerciseProvider.notifier)
        ..prepareCameraForTest()
        ..onPoseResult(_result(PoseStatus.poseDetected))
        ..startCountdown(tickDuration: const Duration(milliseconds: 1));
      async.elapse(const Duration(milliseconds: 3));
      expect(container.read(liveExerciseProvider).stage, LivePoseStage.active);
      expect(container.read(liveExerciseProvider).analysis.repCount, 0);
    });
  });

  test('push-up can start when one arm is visible without full lower body', () {
    container.read(liveExerciseProvider.notifier)
      ..configureExercise('push-up')
      ..prepareCameraForTest()
      ..onPoseResult(_result(PoseStatus.partialPose, lowLowerBody: true));

    expect(container.read(liveExerciseProvider).analysisReady, isTrue);
    expect(
      container.read(liveExerciseProvider).stage,
      LivePoseStage.positioning,
    );
  });

  test('tracking loss cancels an active countdown', () {
    container.read(liveExerciseProvider.notifier)
      ..prepareCameraForTest()
      ..onPoseResult(_result(PoseStatus.poseDetected))
      ..startCountdown(tickDuration: const Duration(seconds: 10))
      ..onPoseResult(_result(PoseStatus.partialPose));
    expect(
      container.read(liveExerciseProvider).stage,
      LivePoseStage.positioning,
    );
    expect(container.read(liveExerciseProvider).countdown, isNull);
  });

  test('camera and model errors become safe error states', () {
    final controller = container.read(liveExerciseProvider.notifier)
      ..prepareCameraForTest();

    controller.onPoseResult(
      _result(PoseStatus.modelError, message: 'Model asset is unavailable.'),
    );
    expect(container.read(liveExerciseProvider).stage, LivePoseStage.error);
    expect(
      container.read(liveExerciseProvider).feedback,
      'Model asset is unavailable.',
    );

    controller
      ..prepareCameraForTest()
      ..onPoseResult(
        _result(PoseStatus.cameraError, message: 'Camera is already in use.'),
      );
    expect(container.read(liveExerciseProvider).stage, LivePoseStage.error);
    expect(
      container.read(liveExerciseProvider).feedback,
      'Camera is already in use.',
    );
  });

  test('countdown can be cancelled explicitly', () {
    final controller = container.read(liveExerciseProvider.notifier)
      ..prepareCameraForTest()
      ..onPoseResult(_result(PoseStatus.poseDetected))
      ..startCountdown(tickDuration: const Duration(seconds: 10));

    controller.cancelCountdown();

    expect(
      container.read(liveExerciseProvider).stage,
      LivePoseStage.positioning,
    );
    expect(container.read(liveExerciseProvider).countdown, isNull);
    expect(
      container.read(liveExerciseProvider).feedback,
      'Countdown cancelled.',
    );
  });

  test('resume waits for a valid pose before continuing the timer', () {
    fakeAsync((async) {
      final controller = container.read(liveExerciseProvider.notifier)
        ..prepareCameraForTest()
        ..onPoseResult(_result(PoseStatus.poseDetected))
        ..startCountdown(tickDuration: const Duration(milliseconds: 1));
      async.elapse(const Duration(milliseconds: 3));
      async.elapse(const Duration(seconds: 2));
      expect(container.read(liveExerciseProvider).elapsed.inSeconds, 2);

      controller.pause();
      async.flushMicrotasks();
      expect(container.read(liveExerciseProvider).stage, LivePoseStage.paused);
      async.elapse(const Duration(seconds: 2));
      expect(container.read(liveExerciseProvider).elapsed.inSeconds, 2);

      controller.resume();
      async.flushMicrotasks();
      expect(
        container.read(liveExerciseProvider).stage,
        LivePoseStage.initializing,
      );
      expect(container.read(liveExerciseProvider).resumingSession, isTrue);

      controller.onPoseResult(_result(PoseStatus.partialPose));
      expect(
        container.read(liveExerciseProvider).stage,
        LivePoseStage.initializing,
      );
      async.elapse(const Duration(seconds: 1));
      expect(container.read(liveExerciseProvider).elapsed.inSeconds, 2);

      controller.onPoseResult(_result(PoseStatus.poseDetected));
      expect(container.read(liveExerciseProvider).stage, LivePoseStage.active);
      expect(container.read(liveExerciseProvider).resumingSession, isFalse);
      async.elapse(const Duration(seconds: 1));
      expect(container.read(liveExerciseProvider).elapsed.inSeconds, 3);
    });
  });

  test('invalid pause transition does not corrupt guide state', () async {
    final controller = container.read(liveExerciseProvider.notifier);
    await controller.pause();
    expect(container.read(liveExerciseProvider).stage, LivePoseStage.guide);
  });

  test('duplicate end requests dispose native resources only once', () async {
    var disposeCalls = 0;
    final disposeCompleter = Completer<void>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(commands, (call) async {
          if (call.method == 'dispose') {
            disposeCalls += 1;
            await disposeCompleter.future;
          }
          return null;
        });
    final controller = container.read(liveExerciseProvider.notifier)
      ..prepareCameraForTest();

    final firstEnd = controller.end();
    final duplicateEnd = controller.end();
    expect(disposeCalls, 1);
    disposeCompleter.complete();
    await Future.wait([firstEnd, duplicateEnd]);

    expect(disposeCalls, 1);
    expect(container.read(liveExerciseProvider).stage, LivePoseStage.completed);
  });

  test('disposing the provider cancels the active session timer', () {
    fakeAsync((async) {
      final disposableContainer = ProviderContainer.test();
      final disposableSubscription = disposableContainer.listen(
        liveExerciseProvider,
        (_, _) {},
      );
      disposableContainer.read(liveExerciseProvider.notifier)
        ..prepareCameraForTest()
        ..onPoseResult(_result(PoseStatus.poseDetected))
        ..startCountdown(tickDuration: const Duration(milliseconds: 1));
      async.elapse(const Duration(milliseconds: 3));
      expect(async.periodicTimerCount, 1);

      disposableSubscription.close();
      disposableContainer.dispose();
      async.flushMicrotasks();

      expect(async.periodicTimerCount, 0);
    });
  });
}

PoseResult _result(
  PoseStatus status, {
  String? message,
  bool lowLowerBody = false,
}) => PoseResult(
  timestampMs: 1,
  imageWidth: 480,
  imageHeight: 640,
  rotation: 0,
  lensDirection: CameraLensDirection.front,
  inferenceLatencyMs: 40,
  poseDetected: status == PoseStatus.poseDetected || lowLowerBody,
  status: status,
  landmarks: List.generate(
    33,
    (index) => PoseLandmark(
      index: index,
      x: 0.5,
      y: 0.5,
      z: 0,
      visibility: lowLowerBody && {23, 24, 25, 26, 27, 28}.contains(index)
          ? 0.2
          : 0.9,
      presence: lowLowerBody && {23, 24, 25, 26, 27, 28}.contains(index)
          ? 0.2
          : 0.9,
    ),
  ),
  worldLandmarks: const [],
  processedFps: 20,
  droppedFrames: 0,
  message: message,
);
