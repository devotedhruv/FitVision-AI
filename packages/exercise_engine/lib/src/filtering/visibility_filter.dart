import '../config/exercise_engine_config.dart';
import '../feedback/feedback_code.dart';
import '../models/analyzer_output.dart';
import '../models/pose_frame.dart';
import '../models/pose_landmark.dart';
import '../state_machine/exercise_state.dart';

class VisibilityFilter {
  VisibilityFilter([this.config = const VisibilityConfig()]);
  final VisibilityConfig config;
  BodySide? _selectedSide;
  BodySide? get selectedSide => _selectedSide;

  TrackingStatus evaluate(
    PoseFrame frame,
    Iterable<LandmarkType> required, {
    FeedbackCode warning = FeedbackCode.lowLandmarkConfidence,
  }) {
    final missing = <int>[];
    for (final type in required) {
      final landmark = frame.landmark(type);
      if (landmark == null || landmark.confidence < config.threshold) {
        missing.add(type.landmarkIndex);
      }
    }
    return TrackingStatus(
      accepted: missing.isEmpty && frame.frameConfidence >= config.threshold,
      missing: List.unmodifiable(missing),
      warning: missing.isEmpty ? null : warning,
    );
  }

  BodySide selectSide(
    PoseFrame frame,
    List<LandmarkType> left,
    List<LandmarkType> right,
  ) {
    double score(List<LandmarkType> types) => types.fold(
      0,
      (sum, type) => sum + (frame.landmark(type)?.confidence ?? 0),
    );
    final leftScore = score(left), rightScore = score(right);
    _selectedSide ??= leftScore >= rightScore ? BodySide.left : BodySide.right;
    if (_selectedSide == BodySide.left &&
        rightScore > leftScore + config.sideSwitchMargin * right.length) {
      _selectedSide = BodySide.right;
    }
    if (_selectedSide == BodySide.right &&
        leftScore > rightScore + config.sideSwitchMargin * left.length) {
      _selectedSide = BodySide.left;
    }
    return _selectedSide!;
  }

  void reset() => _selectedSide = null;
}
