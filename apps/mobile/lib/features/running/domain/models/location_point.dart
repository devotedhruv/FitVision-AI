enum LocationPointStatus { accepted, rejected }

enum GpsRejectionReason {
  invalidCoordinates,
  poorAccuracy,
  stalePoint,
  outOfOrder,
  duplicatePoint,
  impossibleJump,
  implausibleSpeed,
  paused,
  permissionLost,
  gpsUnavailable,
}

enum RunningSyncState { pending, syncing, synced, failed, conflict }

class LocationPoint {
  const LocationPoint({
    required this.localId,
    required this.runningSessionLocalId,
    required this.sequenceNumber,
    required this.latitude,
    required this.longitude,
    this.altitude,
    required this.horizontalAccuracy,
    this.verticalAccuracy,
    this.providerSpeed,
    this.speedAccuracy,
    this.bearing,
    required this.recordedAt,
    this.elapsedRealtimeMs,
    required this.status,
    this.rejectionReason,
    this.distanceFromPreviousMeters = 0,
    this.syncState = RunningSyncState.pending,
  });
  final String localId, runningSessionLocalId;
  final int sequenceNumber;
  final double latitude,
      longitude,
      horizontalAccuracy,
      distanceFromPreviousMeters;
  final double? altitude,
      verticalAccuracy,
      providerSpeed,
      speedAccuracy,
      bearing;
  final DateTime recordedAt;
  final int? elapsedRealtimeMs;
  final LocationPointStatus status;
  final GpsRejectionReason? rejectionReason;
  final RunningSyncState syncState;
  bool get accepted => status == LocationPointStatus.accepted;
}
