import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../../domain/models/location_point.dart' as domain;

abstract final class LocationPointMapper {
  static domain.LocationPoint fromRow(RunningPoint r) => domain.LocationPoint(
    localId: r.localId,
    runningSessionLocalId: r.runningSessionLocalId,
    sequenceNumber: r.sequenceNumber,
    latitude: r.latitude,
    longitude: r.longitude,
    altitude: r.altitude,
    horizontalAccuracy: r.horizontalAccuracy,
    verticalAccuracy: r.verticalAccuracy,
    providerSpeed: r.providerSpeed,
    speedAccuracy: r.speedAccuracy,
    bearing: r.bearing,
    recordedAt: r.recordedAt,
    elapsedRealtimeMs: r.elapsedRealtimeMs,
    status: r.accepted
        ? domain.LocationPointStatus.accepted
        : domain.LocationPointStatus.rejected,
    rejectionReason: r.rejectionCode == null
        ? null
        : domain.GpsRejectionReason.values.byName(r.rejectionCode!),
    distanceFromPreviousMeters: r.distanceFromPreviousMeters,
    syncState: domain.RunningSyncState.values.byName(r.syncStatus),
  );
  static RunningPointsCompanion toCompanion(domain.LocationPoint p) =>
      RunningPointsCompanion.insert(
        localId: p.localId,
        runningSessionLocalId: p.runningSessionLocalId,
        sequenceNumber: p.sequenceNumber,
        latitude: p.latitude,
        longitude: p.longitude,
        altitude: Value(p.altitude),
        horizontalAccuracy: p.horizontalAccuracy,
        verticalAccuracy: Value(p.verticalAccuracy),
        providerSpeed: Value(p.providerSpeed),
        speedAccuracy: Value(p.speedAccuracy),
        bearing: Value(p.bearing),
        recordedAt: p.recordedAt.toUtc(),
        elapsedRealtimeMs: Value(p.elapsedRealtimeMs),
        distanceFromPreviousMeters: Value(p.distanceFromPreviousMeters),
        accepted: p.accepted,
        rejectionCode: Value(p.rejectionReason?.name),
        createdAt: DateTime.now().toUtc(),
        syncStatus: Value(p.syncState.name),
      );
}
