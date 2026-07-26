import 'package:fitvision_ai/features/running/domain/calculations/distance_calculator.dart';
import 'package:fitvision_ai/features/running/domain/calculations/gps_filter.dart';
import 'package:fitvision_ai/features/running/domain/calculations/pace_calculator.dart';
import 'package:fitvision_ai/features/running/domain/models/location_point.dart';
import 'package:flutter_test/flutter_test.dart';

LocationPoint point(
  int n,
  double lat,
  double lon,
  DateTime time, {
  double accuracy = 5,
}) => LocationPoint(
  localId: 'p$n',
  runningSessionLocalId: 'run',
  sequenceNumber: n,
  latitude: lat,
  longitude: lon,
  horizontalAccuracy: accuracy,
  recordedAt: time,
  status: LocationPointStatus.accepted,
);

void main() {
  group('DistanceCalculator', () {
    test(
      'identical coordinates return zero',
      () => expect(
        DistanceCalculator.between(27.7172, 85.324, 27.7172, 85.324),
        0,
      ),
    );
    test(
      'known coordinate pair is accurate',
      () =>
          expect(DistanceCalculator.between(0, 0, 0, 1), closeTo(111194.9, 1)),
    );
    test('short local distance remains finite', () {
      final d = DistanceCalculator.between(27.7172, 85.324, 27.71721, 85.32401);
      expect(d, inInclusiveRange(1, 2));
      expect(d.isFinite, isTrue);
    });
    test('invalid coordinates throw', () {
      expect(
        () => DistanceCalculator.between(91, 0, 0, 0),
        throwsArgumentError,
      );
      expect(
        () => DistanceCalculator.between(0, 181, 0, 0),
        throwsArgumentError,
      );
    });
    test(
      'multi point route totals segments',
      () => expect(
        DistanceCalculator.route([(0.0, 0.0), (0.0, .001), (0.0, .002)]),
        closeTo(222.39, .2),
      ),
    );
  });
  group('PaceCalculator', () {
    test('speed and pace use active time only', () {
      expect(
        PaceCalculator.speed(1000, const Duration(minutes: 5)),
        closeTo(3.333, .01),
      );
      expect(PaceCalculator.pace(1000, const Duration(minutes: 5)), 300);
    });
    test('zero and unreliable inputs return null', () {
      expect(PaceCalculator.speed(0, Duration.zero), isNull);
      expect(PaceCalculator.pace(10, const Duration(minutes: 1)), isNull);
    });
    test('formatting never renders infinity', () {
      expect(PaceCalculator.format(305), '05:05');
      expect(PaceCalculator.format(double.infinity), '--:--');
    });
  });
  group('GpsFilter', () {
    final t = DateTime.utc(2026, 1, 1, 10);
    test('good route points are accepted', () {
      final f = GpsFilter();
      expect(f.evaluate(point(0, 27, 85, t)).accepted, isTrue);
      expect(
        f
            .evaluate(point(1, 27.00005, 85, t.add(const Duration(seconds: 5))))
            .accepted,
        isTrue,
      );
    });
    test('poor accuracy duplicate and paused points are rejected', () {
      final f = GpsFilter();
      expect(
        f.evaluate(point(0, 27, 85, t, accuracy: 50)).reason,
        GpsRejectionReason.poorAccuracy,
      );
      expect(f.evaluate(point(1, 27, 85, t)).accepted, isTrue);
      expect(
        f.evaluate(point(2, 27, 85, t.add(const Duration(seconds: 1)))).reason,
        GpsRejectionReason.duplicatePoint,
      );
      expect(
        f
            .evaluate(
              point(3, 27.1, 85, t.add(const Duration(seconds: 2))),
              paused: true,
            )
            .reason,
        GpsRejectionReason.paused,
      );
    });
    test('out of order and impossible jumps are rejected', () {
      final f = GpsFilter();
      f.evaluate(point(0, 27, 85, t));
      expect(
        f
            .evaluate(point(1, 27.1, 85, t.add(const Duration(seconds: 1))))
            .reason,
        GpsRejectionReason.impossibleJump,
      );
      expect(
        f
            .evaluate(
              point(2, 27.0001, 85, t.subtract(const Duration(seconds: 1))),
            )
            .reason,
        GpsRejectionReason.outOfOrder,
      );
    });
    test('resume creates a new segment anchor', () {
      final f = GpsFilter();
      f.evaluate(point(0, 27, 85, t));
      f.resetSegment();
      final result = f.evaluate(
        point(1, 28, 86, t.add(const Duration(minutes: 1))),
      );
      expect(result.accepted, isTrue);
      expect(result.distanceMeters, 0);
    });
  });
}
