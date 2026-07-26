import 'dart:math' as math;
import 'package:exercise_engine/exercise_engine.dart';

PoseFrame jointFrame(
  int milliseconds,
  double angle, {
  ExerciseType type = ExerciseType.squat,
  double confidence = .95,
  double alignment = 180,
  double elbowShift = 0,
}) {
  final radians = angle * math.pi / 180;
  final points = <PoseLandmark>[];
  void addJoint(int a, int b, int c, {double ox = .5, double oy = .5}) {
    points.add(
      PoseLandmark(
        index: a,
        x: ox + .2,
        y: oy,
        visibility: confidence,
        presence: confidence,
      ),
    );
    points.add(
      PoseLandmark(
        index: b,
        x: ox + elbowShift,
        y: oy,
        visibility: confidence,
        presence: confidence,
      ),
    );
    points.add(
      PoseLandmark(
        index: c,
        x: ox + .2 * math.cos(radians),
        y: oy + .2 * math.sin(radians),
        visibility: confidence,
        presence: confidence,
      ),
    );
  }

  if (type == ExerciseType.squat) {
    addJoint(23, 25, 27);
    addJoint(24, 26, 28, ox: .52);
  } else {
    addJoint(11, 13, 15);
    addJoint(12, 14, 16, ox: .52);
    // Shoulder-to-hip points down-left. Rotate that ray by the requested
    // vertex angle to create the hip-to-ankle ray.
    final alignmentRadians = (-45 + alignment) * math.pi / 180;
    points.addAll([
      PoseLandmark(
        index: 23,
        x: .5,
        y: .7,
        visibility: confidence,
        presence: confidence,
      ),
      PoseLandmark(
        index: 27,
        x: .5 + .2 * math.cos(alignmentRadians),
        y: .7 + .2 * math.sin(alignmentRadians),
        visibility: confidence,
        presence: confidence,
      ),
      PoseLandmark(
        index: 24,
        x: .52,
        y: .7,
        visibility: confidence,
        presence: confidence,
      ),
      PoseLandmark(
        index: 28,
        x: .52 + .2 * math.cos(alignmentRadians),
        y: .7 + .2 * math.sin(alignmentRadians),
        visibility: confidence,
        presence: confidence,
      ),
    ]);
  }
  return PoseFrame(
    timestamp: Duration(milliseconds: milliseconds),
    landmarks: points,
  );
}

List<PoseFrame> cycle(
  ExerciseType type,
  List<double> angles, {
  double alignment = 180,
}) {
  var time = 0;
  return [
    for (final angle in angles)
      for (var i = 0; i < 10; i++)
        jointFrame(time += 100, angle, type: type, alignment: alignment),
  ];
}
