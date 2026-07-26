import 'package:exercise_engine/exercise_engine.dart' as engine;
import 'package:pose_landmarker/pose_landmarker.dart' as mediapipe;

/// Keeps the MediaPipe/platform contract outside the pure Dart engine.
abstract final class MediaPipePoseFrameAdapter {
  static engine.PoseFrame convert(mediapipe.PoseResult result) {
    final rotation = result.rotation % 360;
    engine.PoseLandmark map(mediapipe.PoseLandmark item) {
      var x = item.x;
      var y = item.y;
      switch (rotation) {
        case 90:
          (x, y) = (1 - y, x);
        case 180:
          x = 1 - x;
          y = 1 - y;
        case 270:
          (x, y) = (y, 1 - x);
      }
      // MediaPipe indices describe anatomical left/right. Mirroring X makes
      // the coordinate space match the preview without swapping those IDs.
      if (result.mirrored) x = 1 - x;
      return engine.PoseLandmark(
        index: item.index,
        x: x,
        y: y,
        z: item.z,
        visibility: item.visibility,
        presence: item.presence,
      );
    }

    final landmarks = result.landmarks.map(map).toList(growable: false);
    return engine.PoseFrame(
      timestamp: Duration(milliseconds: result.timestampMs),
      landmarks: landmarks,
      // Required-landmark confidence is exercise-specific. This value only
      // records whether the native detector produced a pose for the frame.
      frameConfidence: result.poseDetected ? 1 : 0,
      imageWidth: result.imageWidth,
      imageHeight: result.imageHeight,
      rotationDegrees: 0,
      cameraLens: switch (result.lensDirection) {
        mediapipe.CameraLensDirection.front => engine.CameraLens.front,
        mediapipe.CameraLensDirection.back => engine.CameraLens.back,
      },
      mirrored: result.mirrored,
    );
  }
}
