import '../models/location_point.dart';
import 'distance_calculator.dart';

class RunningTrackingConfig {
  const RunningTrackingConfig({
    this.sampleInterval = const Duration(seconds: 2),
    this.minimumDisplacementMeters = 3,
    this.maximumAcceptedAccuracyMeters = 30,
    this.maximumPlausibleSpeedMps = 12,
    this.maximumTimestampGap = const Duration(seconds: 15),
    this.minimumPaceDistanceMeters = 20,
    this.speedSmoothingAlpha = .35,
    this.accuracyNoiseMultiplier = .5,
    this.checkpointInterval = const Duration(seconds: 10),
    this.maximumPointsPerSyncBatch = 250,
  });
  final Duration sampleInterval, maximumTimestampGap, checkpointInterval;
  final double minimumDisplacementMeters,
      maximumAcceptedAccuracyMeters,
      maximumPlausibleSpeedMps,
      minimumPaceDistanceMeters,
      speedSmoothingAlpha,
      accuracyNoiseMultiplier;
  final int maximumPointsPerSyncBatch;
}

class GpsFilterResult {
  const GpsFilterResult(this.accepted, this.reason, this.distanceMeters);
  final bool accepted;
  final GpsRejectionReason? reason;
  final double distanceMeters;
}

class GpsFilter {
  GpsFilter([this.config = const RunningTrackingConfig()]);
  final RunningTrackingConfig config;
  LocationPoint? _anchor;
  GpsFilterResult evaluate(
    LocationPoint point, {
    bool paused = false,
    DateTime? now,
  }) {
    if (paused) {
      return const GpsFilterResult(false, GpsRejectionReason.paused, 0);
    }
    if (!point.latitude.isFinite ||
        !point.longitude.isFinite ||
        point.latitude.abs() > 90 ||
        point.longitude.abs() > 180) {
      return const GpsFilterResult(
        false,
        GpsRejectionReason.invalidCoordinates,
        0,
      );
    }
    if (!point.horizontalAccuracy.isFinite ||
        point.horizontalAccuracy < 0 ||
        point.horizontalAccuracy > config.maximumAcceptedAccuracyMeters) {
      return const GpsFilterResult(false, GpsRejectionReason.poorAccuracy, 0);
    }
    if (now != null &&
        now.toUtc().difference(point.recordedAt.toUtc()) >
            config.maximumTimestampGap) {
      return const GpsFilterResult(false, GpsRejectionReason.stalePoint, 0);
    }
    final anchor = _anchor;
    if (anchor == null) {
      _anchor = point;
      return const GpsFilterResult(true, null, 0);
    }
    if (point.recordedAt.isBefore(anchor.recordedAt)) {
      return const GpsFilterResult(false, GpsRejectionReason.outOfOrder, 0);
    }
    if (point.recordedAt == anchor.recordedAt) {
      return const GpsFilterResult(false, GpsRejectionReason.duplicatePoint, 0);
    }
    final distance = DistanceCalculator.between(
      anchor.latitude,
      anchor.longitude,
      point.latitude,
      point.longitude,
    );
    final noiseFloor =
        ((anchor.horizontalAccuracy + point.horizontalAccuracy) / 2) *
        config.accuracyNoiseMultiplier;
    if (distance <
        (noiseFloor > config.minimumDisplacementMeters
            ? noiseFloor
            : config.minimumDisplacementMeters)) {
      return const GpsFilterResult(false, GpsRejectionReason.duplicatePoint, 0);
    }
    final seconds =
        point.recordedAt.difference(anchor.recordedAt).inMilliseconds / 1000;
    final speed = distance / seconds;
    if (speed > config.maximumPlausibleSpeedMps) {
      return GpsFilterResult(
        false,
        distance > config.maximumAcceptedAccuracyMeters * 4
            ? GpsRejectionReason.impossibleJump
            : GpsRejectionReason.implausibleSpeed,
        0,
      );
    }
    _anchor = point;
    return GpsFilterResult(true, null, distance);
  }

  void resetSegment() => _anchor = null;
}
