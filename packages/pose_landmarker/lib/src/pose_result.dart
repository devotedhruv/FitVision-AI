import 'pose_landmark.dart';
import 'pose_status.dart';

class PoseResult {
  const PoseResult({
    required this.timestampMs,
    required this.imageWidth,
    required this.imageHeight,
    required this.rotation,
    required this.lensDirection,
    required this.inferenceLatencyMs,
    required this.poseDetected,
    required this.status,
    required this.landmarks,
    required this.worldLandmarks,
    required this.processedFps,
    required this.droppedFrames,
    this.message,
  });

  factory PoseResult.fromMap(Map<Object?, Object?> map) {
    List<PoseLandmark> landmarks(String key) =>
        ((map[key] as List<Object?>?) ?? const [])
            .map((item) => PoseLandmark.fromMap(item! as Map<Object?, Object?>))
            .toList(growable: false);
    return PoseResult(
      timestampMs: (map['timestamp'] as num?)?.toInt() ?? 0,
      imageWidth: (map['imageWidth'] as num?)?.toInt() ?? 0,
      imageHeight: (map['imageHeight'] as num?)?.toInt() ?? 0,
      rotation: (map['rotation'] as num?)?.toInt() ?? 0,
      lensDirection: CameraLensDirection.fromWire(
        map['lensDirection'] as String?,
      ),
      inferenceLatencyMs: (map['inferenceLatencyMs'] as num?)?.toDouble() ?? 0,
      poseDetected: map['poseDetected'] as bool? ?? false,
      status: PoseStatus.fromWire(map['status'] as String?),
      landmarks: landmarks('landmarks'),
      worldLandmarks: landmarks('worldLandmarks'),
      processedFps: (map['processedFps'] as num?)?.toDouble() ?? 0,
      droppedFrames: (map['droppedFrames'] as num?)?.toInt() ?? 0,
      message: map['message'] as String?,
    );
  }

  final int timestampMs;
  final int imageWidth;
  final int imageHeight;
  final int rotation;
  final CameraLensDirection lensDirection;
  final double inferenceLatencyMs;
  final bool poseDetected;
  final PoseStatus status;
  final List<PoseLandmark> landmarks;
  final List<PoseLandmark> worldLandmarks;
  final double processedFps;
  final int droppedFrames;
  final String? message;

  bool get mirrored => lensDirection == CameraLensDirection.front;
}
