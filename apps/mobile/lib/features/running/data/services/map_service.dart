import '../../domain/models/location_point.dart';

class MapService {
  const MapService();
  List<LocationPoint> accepted(Iterable<LocationPoint> points) =>
      List.unmodifiable(points.where((p) => p.accepted));
}
