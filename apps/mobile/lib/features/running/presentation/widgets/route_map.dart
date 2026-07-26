import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/location_point.dart';

class RouteMap extends StatelessWidget {
  const RouteMap({required this.points, super.key});
  final List<LocationPoint> points;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      height: 260,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: CustomPaint(
        painter: _RoutePainter(points.where((p) => p.accepted).toList()),
        child: points.isEmpty
            ? const Center(child: Text('Route appears after a GPS fix'))
            : null,
      ),
    ),
  );
}

class _RoutePainter extends CustomPainter {
  _RoutePainter(this.points);
  final List<LocationPoint> points;
  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minLat = points.map((p) => p.latitude).reduce(math.min),
        maxLat = points.map((p) => p.latitude).reduce(math.max),
        minLon = points.map((p) => p.longitude).reduce(math.min),
        maxLon = points.map((p) => p.longitude).reduce(math.max);
    Offset map(LocationPoint p) => Offset(
      12 +
          (p.longitude - minLon) /
              (maxLon - minLon == 0 ? 1 : maxLon - minLon) *
              (size.width - 24),
      size.height -
          12 -
          (p.latitude - minLat) /
              (maxLat - minLat == 0 ? 1 : maxLat - minLat) *
              (size.height - 24),
    );
    final path = Path()..moveTo(map(points.first).dx, map(points.first).dy);
    for (final p in points.skip(1)) {
      final o = map(p);
      path.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(map(points.last), 7, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.points.length != points.length;
}
