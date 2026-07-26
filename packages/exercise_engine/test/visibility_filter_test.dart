import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a low-confidence required landmark, the frame is rejected with its index',
    () {
      final frame = PoseFrame(
        timestamp: Duration.zero,
        landmarks: [
          const PoseLandmark(index: 25, x: .5, y: .5, visibility: .4),
        ],
      );
      final result = VisibilityFilter().evaluate(frame, [
        LandmarkType.leftKnee,
      ]);
      expect(result.accepted, isFalse);
      expect(result.missing, [25]);
    },
  );
}
