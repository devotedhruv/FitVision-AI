import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/models/location_point.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({required this.points, super.key});

  final List<LocationPoint> points;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  GoogleMapController? _controller;
  bool _followLocation = true;
  bool _programmaticMove = false;

  List<LocationPoint> get _accepted =>
      widget.points.where((point) => point.accepted).toList(growable: false);

  @override
  void didUpdateWidget(covariant RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_followLocation &&
        _accepted.length > _acceptedCount(oldWidget.points)) {
      unawaited(_moveToLatest());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accepted = _accepted;
    final latest = accepted.isEmpty
        ? const LatLng(27.7172, 85.3240)
        : _latLng(accepted.last);
    final routePolylines = _routePolylines(accepted, context);

    return RepaintBoundary(
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: latest, zoom: 17),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: accepted.isEmpty
                  ? const {}
                  : {
                      Marker(
                        markerId: const MarkerId('current-location'),
                        position: latest,
                        infoWindow: const InfoWindow(title: 'Current location'),
                      ),
                    },
              polylines: routePolylines,
              onMapCreated: (controller) {
                _controller = controller;
                if (accepted.isNotEmpty) unawaited(_moveToLatest());
              },
              onCameraMoveStarted: () {
                if (!_programmaticMove && _followLocation) {
                  setState(() => _followLocation = false);
                }
              },
            ),
            if (accepted.isEmpty)
              const Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text('Waiting for an accurate GPS fix…'),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 12,
              bottom: 12,
              child: FloatingActionButton.small(
                heroTag: null,
                tooltip: 'Recenter route map',
                onPressed: accepted.isEmpty
                    ? null
                    : () {
                        setState(() => _followLocation = true);
                        unawaited(_moveToLatest());
                      },
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _acceptedCount(List<LocationPoint> points) =>
      points.where((point) => point.accepted).length;

  LatLng _latLng(LocationPoint point) =>
      LatLng(point.latitude, point.longitude);

  Set<Polyline> _routePolylines(
    List<LocationPoint> accepted,
    BuildContext context,
  ) {
    if (accepted.length < 2) return const {};
    final segments = <List<LatLng>>[[]];
    for (var index = 0; index < accepted.length; index++) {
      final point = accepted[index];
      if (index > 0 && point.distanceFromPreviousMeters <= 0) {
        segments.add([]);
      }
      segments.last.add(_latLng(point));
    }
    final color = Theme.of(context).colorScheme.primary;
    return {
      for (var index = 0; index < segments.length; index++)
        if (segments[index].length >= 2)
          Polyline(
            polylineId: PolylineId('accepted-running-route-$index'),
            points: segments[index],
            color: color,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),
    };
  }

  Future<void> _moveToLatest() async {
    final controller = _controller;
    final accepted = _accepted;
    if (!mounted || controller == null || accepted.isEmpty) return;
    _programmaticMove = true;
    try {
      if (accepted.length == 1) {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _latLng(accepted.last), zoom: 17),
          ),
        );
      } else {
        final bounds = _bounds(accepted);
        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 48),
        );
      }
    } finally {
      _programmaticMove = false;
    }
  }

  LatLngBounds _bounds(List<LocationPoint> points) {
    var minLat = points.first.latitude;
    var maxLat = minLat;
    var minLng = points.first.longitude;
    var maxLng = minLng;
    for (final point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    if (minLat == maxLat) {
      minLat -= 0.00005;
      maxLat += 0.00005;
    }
    if (minLng == maxLng) {
      minLng -= 0.00005;
      maxLng += 0.00005;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
