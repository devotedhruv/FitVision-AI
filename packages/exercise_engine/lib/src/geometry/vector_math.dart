import 'dart:math' as math;
import '../models/pose_landmark.dart';

class Vector2 {
  const Vector2(this.x, this.y);
  final double x, y;
  bool get isFinite => x.isFinite && y.isFinite;
  double get length => math.sqrt(x * x + y * y);
  double dot(Vector2 other) => x * other.x + y * other.y;
}

abstract final class VectorMath {
  static Vector2 between(PoseLandmark from, PoseLandmark to) =>
      Vector2(to.x - from.x, to.y - from.y);
  static double? distance(PoseLandmark a, PoseLandmark b) {
    final value = between(a, b);
    return value.isFinite ? value.length : null;
  }

  static PoseLandmark? midpoint(PoseLandmark a, PoseLandmark b) {
    if (![a.x, a.y, b.x, b.y].every((value) => value.isFinite)) return null;
    return PoseLandmark(
      index: -1,
      x: (a.x + b.x) / 2,
      y: (a.y + b.y) / 2,
      z: a.z != null && b.z != null ? (a.z! + b.z!) / 2 : null,
      visibility: math.min(a.visibility, b.visibility),
      presence: a.presence != null && b.presence != null
          ? math.min(a.presence!, b.presence!)
          : null,
    );
  }

  static double? normalizedDisplacement(
    PoseLandmark a,
    PoseLandmark b,
    double scale,
  ) {
    if (!scale.isFinite || scale <= 1e-9) return null;
    final value = distance(a, b);
    return value == null ? null : value / scale;
  }
}
