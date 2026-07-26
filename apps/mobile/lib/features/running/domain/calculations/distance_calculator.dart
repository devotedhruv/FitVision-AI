import 'dart:math' as math;

abstract final class DistanceCalculator {
  static const earthRadiusMeters = 6371000.0;
  static double between(double lat1, double lon1, double lat2, double lon2) {
    _validate(lat1, lon1);
    _validate(lat2, lon2);
    if (lat1 == lat2 && lon1 == lon2) return 0;
    final p1 = _rad(lat1),
        p2 = _rad(lat2),
        dp = _rad(lat2 - lat1),
        dl = _rad(lon2 - lon1);
    final a =
        math.sin(dp / 2) * math.sin(dp / 2) +
        math.cos(p1) * math.cos(p2) * math.sin(dl / 2) * math.sin(dl / 2);
    final value =
        2 *
        earthRadiusMeters *
        math.atan2(math.sqrt(a.clamp(0, 1)), math.sqrt((1 - a).clamp(0, 1)));
    return value.isFinite ? value : 0;
  }

  static double route(Iterable<(double, double)> points) {
    final list = points.toList();
    var total = 0.0;
    for (var i = 1; i < list.length; i++) {
      total += between(list[i - 1].$1, list[i - 1].$2, list[i].$1, list[i].$2);
    }
    return total;
  }

  static void _validate(double lat, double lon) {
    if (!lat.isFinite ||
        !lon.isFinite ||
        lat < -90 ||
        lat > 90 ||
        lon < -180 ||
        lon > 180) {
      throw ArgumentError('Invalid coordinate');
    }
  }

  static double _rad(double value) => value * math.pi / 180;
}
