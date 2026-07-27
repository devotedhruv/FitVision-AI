import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/location_point.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({
    required this.points,
    this.expand = false,
    this.statusMessage,
    super.key,
  });

  final List<LocationPoint> points;
  final bool expand;
  final String? statusMessage;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final MapController _controller = MapController();
  bool _followLocation = true;
  bool _mapReady = false;
  bool _programmaticMove = false;

  List<LocationPoint> get _accepted =>
      widget.points.where((point) => point.accepted).toList(growable: false);

  LocationPoint? get _latest =>
      widget.points.isEmpty ? null : widget.points.last;

  @override
  void didUpdateWidget(covariant RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_followLocation && widget.points.length > oldWidget.points.length) {
      unawaited(_moveToLatest());
    }
  }

  @override
  Widget build(BuildContext context) {
    final accepted = _accepted;
    final latestPoint = _latest;
    final markerPoint = accepted.isEmpty ? latestPoint : accepted.last;
    final center = latestPoint == null
        ? const LatLng(27.7172, 85.3240)
        : _latLng(latestPoint);
    final polylines = _routePolylines(accepted, context);

    return RepaintBoundary(
      child: SizedBox(
        height: widget.expand ? double.infinity : 260,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 17,
                onMapReady: () {
                  _mapReady = true;
                  if (latestPoint != null) unawaited(_moveToLatest());
                },
                onPositionChanged: (_, hasGesture) {
                  if (hasGesture && !_programmaticMove && _followLocation) {
                    setState(() => _followLocation = false);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.fitvisionai.fitvision_ai',
                ),
                if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
                if (markerPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _latLng(markerPoint),
                        width: 44,
                        height: 44,
                        child: Tooltip(
                          message: markerPoint.accepted
                              ? 'Current location'
                              : 'Accuracy: ${markerPoint.horizontalAccuracy.toStringAsFixed(0)}m',
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976F3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
            if (accepted.isEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Card(
                      color: latestPoint == null
                          ? null
                          : const Color(0xFF132522),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          latestPoint == null
                              ? (widget.statusMessage ??
                                    'Waiting for a GPS location…')
                              : 'GPS accuracy: ${latestPoint.horizontalAccuracy.toStringAsFixed(0)}m — move outdoors',
                          style: latestPoint == null
                              ? null
                              : const TextStyle(color: Colors.white),
                        ),
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
                onPressed: latestPoint == null
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

  LatLng _latLng(LocationPoint point) =>
      LatLng(point.latitude, point.longitude);

  List<Polyline> _routePolylines(
    List<LocationPoint> accepted,
    BuildContext context,
  ) {
    if (accepted.length < 2) return const [];
    final segments = <List<LatLng>>[[]];
    for (var index = 0; index < accepted.length; index++) {
      final point = accepted[index];
      if (index > 0 && point.distanceFromPreviousMeters <= 0) {
        segments.add([]);
      }
      segments.last.add(_latLng(point));
    }
    final color = Theme.of(context).colorScheme.primary;
    return [
      for (var index = 0; index < segments.length; index++)
        if (segments[index].length >= 2)
          Polyline(points: segments[index], color: color, strokeWidth: 6),
    ];
  }

  Future<void> _moveToLatest() async {
    final latest = _latest;
    if (!mounted || !_mapReady || latest == null) return;
    _programmaticMove = true;
    try {
      final accepted = _accepted;
      if (accepted.length <= 1) {
        _controller.move(_latLng(latest), 17);
      } else {
        final bounds = LatLngBounds.fromPoints(
          accepted.map(_latLng).toList(growable: false),
        );
        _controller.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(48)),
        );
      }
    } finally {
      _programmaticMove = false;
    }
  }
}
