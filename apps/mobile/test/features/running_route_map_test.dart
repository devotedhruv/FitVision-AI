import 'package:fitvision_ai/features/running/domain/models/location_point.dart';
import 'package:fitvision_ai/features/running/presentation/widgets/route_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LocationPoint routePoint(
  int sequence,
  double latitude,
  double longitude, {
  required double distance,
  bool accepted = true,
}) => LocationPoint(
  localId: 'point-$sequence',
  runningSessionLocalId: 'run-1',
  sequenceNumber: sequence,
  latitude: latitude,
  longitude: longitude,
  horizontalAccuracy: 5,
  recordedAt: DateTime.utc(2026, 1, 1, 10, 0, sequence),
  status: accepted
      ? LocationPointStatus.accepted
      : LocationPointStatus.rejected,
  rejectionReason: accepted ? null : GpsRejectionReason.poorAccuracy,
  distanceFromPreviousMeters: distance,
);

void main() {
  testWidgets('route map draws accepted points and excludes rejected points', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RouteMap(
          points: [
            routePoint(0, 27.7172, 85.3240, distance: 0),
            routePoint(1, 27.7173, 85.3241, distance: 15),
            routePoint(2, 27.8, 85.4, distance: 9999, accepted: false),
          ],
        ),
      ),
    );

    final map = tester.widget<GoogleMap>(find.byType(GoogleMap));
    expect(map.markers.single.position, const LatLng(27.7173, 85.3241));
    expect(map.polylines.single.points, const [
      LatLng(27.7172, 85.3240),
      LatLng(27.7173, 85.3241),
    ]);
  });

  testWidgets('route map does not connect movement across a pause boundary', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RouteMap(
          points: [
            routePoint(0, 27.7172, 85.3240, distance: 0),
            routePoint(1, 27.7173, 85.3241, distance: 15),
            routePoint(2, 27.7200, 85.3270, distance: 0),
            routePoint(3, 27.7201, 85.3271, distance: 15),
          ],
        ),
      ),
    );

    final map = tester.widget<GoogleMap>(find.byType(GoogleMap));
    expect(map.polylines, hasLength(2));
    expect(map.polylines.every((line) => line.points.length == 2), isTrue);
  });
}
