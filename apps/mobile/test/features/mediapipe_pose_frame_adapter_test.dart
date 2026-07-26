import 'package:exercise_engine/exercise_engine.dart' as engine;
import 'package:fitvision_ai/features/exercise/data/mediapipe_pose_frame_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

void main() {
  test(
    'front-camera adaptation mirrors coordinates and preserves anatomical IDs',
    () {
      final result = PoseResult(
        timestampMs: 42,
        imageWidth: 480,
        imageHeight: 640,
        rotation: 0,
        lensDirection: CameraLensDirection.front,
        inferenceLatencyMs: 10,
        poseDetected: true,
        status: PoseStatus.poseDetected,
        landmarks: const [
          PoseLandmark(
            index: 11,
            x: .2,
            y: .3,
            z: -.1,
            visibility: .9,
            presence: .8,
          ),
        ],
        worldLandmarks: const [],
        processedFps: 15,
        droppedFrames: 0,
      );
      final frame = MediaPipePoseFrameAdapter.convert(result);
      expect(
        frame.landmark(engine.LandmarkType.leftShoulder)!.x,
        closeTo(.8, .0001),
      );
      expect(frame.mirrored, isTrue);
      expect(frame.timestamp, const Duration(milliseconds: 42));
    },
  );
}
