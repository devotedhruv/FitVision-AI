import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';

PoseFrame frame(int ms, List<PoseLandmark> landmarks) => PoseFrame(
  timestamp: Duration(milliseconds: ms),
  landmarks: landmarks,
);
void main() {
  test('Given noisy coordinates, smoothing reduces the jump', () {
    final smoother = LandmarkSmoother();
    smoother.smooth(
      frame(0, [const PoseLandmark(index: 1, x: 0, y: 0, visibility: 1)]),
    );
    final value = smoother
        .smooth(
          frame(20, [const PoseLandmark(index: 1, x: 1, y: 1, visibility: 1)]),
        )
        .landmarks[1]!;
    expect(value.x, closeTo(.35, .001));
  });
  test(
    'Given reset or a missing landmark, state resets and nothing is fabricated',
    () {
      final smoother = LandmarkSmoother()
        ..smooth(
          frame(0, [const PoseLandmark(index: 1, x: 0, y: 0, visibility: 1)]),
        );
      expect(smoother.smooth(frame(20, const [])).landmarks, isEmpty);
      smoother.reset();
      expect(
        smoother
            .smooth(
              frame(40, [
                const PoseLandmark(index: 1, x: 1, y: 1, visibility: 1),
              ]),
            )
            .landmarks[1]!
            .x,
        1,
      );
    },
  );
}
