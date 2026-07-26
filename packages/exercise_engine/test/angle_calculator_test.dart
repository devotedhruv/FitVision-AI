import 'dart:math' as math;
import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';

PoseLandmark p(double x, double y) =>
    PoseLandmark(index: 0, x: x, y: y, visibility: 1);
void main() {
  group('Given valid points, AngleCalculator', () {
    for (final angle in [0.001, 45.0, 90.0, 180.0]) {
      test('returns $angle degrees', () {
        final radians = angle * math.pi / 180;
        expect(
          AngleCalculator.angle2D(
            p(1, 0),
            p(0, 0),
            p(math.cos(radians), math.sin(radians)),
          ),
          closeTo(angle, .001),
        );
      });
    }
  });
  test('Given duplicate or invalid points, returns null rather than NaN', () {
    expect(AngleCalculator.angle2D(p(0, 0), p(0, 0), p(1, 0)), isNull);
    expect(AngleCalculator.angle2D(p(double.nan, 0), p(0, 0), p(1, 0)), isNull);
  });
}
