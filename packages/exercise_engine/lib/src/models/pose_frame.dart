import 'pose_landmark.dart';

enum CameraLens { front, back, unknown }

class PoseFrame {
  PoseFrame({
    required this.timestamp,
    required Iterable<PoseLandmark> landmarks,
    this.frameConfidence = 1,
    this.imageWidth,
    this.imageHeight,
    this.rotationDegrees = 0,
    this.cameraLens = CameraLens.unknown,
    this.mirrored = false,
  }) : landmarks = Map.unmodifiable({
         for (final item in landmarks) item.index: item,
       });

  final Duration timestamp;
  final Map<int, PoseLandmark> landmarks;
  final double frameConfidence;
  final int? imageWidth;
  final int? imageHeight;
  final int rotationDegrees;
  final CameraLens cameraLens;
  final bool mirrored;

  PoseLandmark? landmark(LandmarkType type) => landmarks[type.landmarkIndex];
}
