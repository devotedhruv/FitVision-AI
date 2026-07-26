import '../config/exercise_engine_config.dart';
import '../models/pose_frame.dart';
import '../models/pose_landmark.dart';

class LandmarkSmoother {
  LandmarkSmoother([this.config = const SmoothingConfig()]) {
    if (config.alpha <= 0 || config.alpha > 1) {
      throw ArgumentError.value(config.alpha, 'alpha');
    }
  }
  final SmoothingConfig config;
  Map<int, PoseLandmark> _previous = const {};
  Duration? _lastTimestamp;

  PoseFrame smooth(PoseFrame frame) {
    if (_lastTimestamp != null &&
        frame.timestamp - _lastTimestamp! > config.resetGap) {
      reset();
    }
    final output = <PoseLandmark>[];
    for (final current in frame.landmarks.values) {
      final previous = _previous[current.index];
      if (previous == null) {
        output.add(current);
        continue;
      }
      double ema(double value, double old) =>
          config.alpha * value + (1 - config.alpha) * old;
      output.add(
        PoseLandmark(
          index: current.index,
          x: ema(current.x, previous.x),
          y: ema(current.y, previous.y),
          z: current.z != null && previous.z != null
              ? ema(current.z!, previous.z!)
              : current.z,
          visibility: current.visibility,
          presence: current.presence,
        ),
      );
    }
    _previous = {for (final item in output) item.index: item};
    _lastTimestamp = frame.timestamp;
    return PoseFrame(
      timestamp: frame.timestamp,
      landmarks: output,
      frameConfidence: frame.frameConfidence,
      imageWidth: frame.imageWidth,
      imageHeight: frame.imageHeight,
      rotationDegrees: frame.rotationDegrees,
      cameraLens: frame.cameraLens,
      mirrored: frame.mirrored,
    );
  }

  void trackingLost(Duration timestamp) {
    if (_lastTimestamp != null &&
        timestamp - _lastTimestamp! >= config.resetGap) {
      reset();
    }
  }

  void reset() {
    _previous = const {};
    _lastTimestamp = null;
  }
}
