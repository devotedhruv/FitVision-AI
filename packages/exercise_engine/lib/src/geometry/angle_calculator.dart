import 'dart:math' as math;
import '../models/pose_landmark.dart';
import 'vector_math.dart';

abstract final class AngleCalculator {
  static double? angle2D(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final ba = VectorMath.between(b, a);
    final bc = VectorMath.between(b, c);
    if (!ba.isFinite ||
        !bc.isFinite ||
        ba.length <= 1e-9 ||
        bc.length <= 1e-9) {
      return null;
    }
    final cosine = (ba.dot(bc) / (ba.length * bc.length)).clamp(-1.0, 1.0);
    final result = math.acos(cosine) * 180 / math.pi;
    return result.isFinite ? result : null;
  }

  static double? angle3D(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    if (a.z == null || b.z == null || c.z == null) return null;
    final bax = a.x - b.x, bay = a.y - b.y, baz = a.z! - b.z!;
    final bcx = c.x - b.x, bcy = c.y - b.y, bcz = c.z! - b.z!;
    if (![bax, bay, baz, bcx, bcy, bcz].every((v) => v.isFinite)) return null;
    final l1 = math.sqrt(bax * bax + bay * bay + baz * baz);
    final l2 = math.sqrt(bcx * bcx + bcy * bcy + bcz * bcz);
    if (l1 <= 1e-9 || l2 <= 1e-9) return null;
    final cosine = ((bax * bcx + bay * bcy + baz * bcz) / (l1 * l2)).clamp(
      -1.0,
      1.0,
    );
    final result = math.acos(cosine) * 180 / math.pi;
    return result.isFinite ? result : null;
  }

  static double? bodyAlignment(
    PoseLandmark shoulder,
    PoseLandmark hip,
    PoseLandmark ankle,
  ) => angle2D(shoulder, hip, ankle);
}
