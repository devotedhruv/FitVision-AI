abstract final class PaceCalculator {
  static double? speed(double meters, Duration active) =>
      meters > 0 && active.inMilliseconds > 0
      ? meters / (active.inMilliseconds / 1000)
      : null;
  static double? pace(
    double meters,
    Duration active, {
    double minimumMeters = 20,
  }) => meters >= minimumMeters && active.inMilliseconds > 0
      ? active.inMilliseconds / 1000 / (meters / 1000)
      : null;
  static String format(double? value) {
    if (value == null || !value.isFinite || value < 0) return '--:--';
    final seconds = value.round();
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
