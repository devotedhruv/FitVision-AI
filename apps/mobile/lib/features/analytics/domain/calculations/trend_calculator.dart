import '../models/trend.dart';

class TrendConfig {
  const TrendConfig({
    this.absoluteTolerance = 0.03,
    this.relativeTolerance = 0.03,
    this.minimumSamples = 2,
  });
  final double absoluteTolerance, relativeTolerance;
  final int minimumSamples;
}

abstract final class TrendCalculator {
  static TrendState calculate({
    required double? current,
    required double? previous,
    required int currentSamples,
    required int previousSamples,
    required MetricDirection direction,
    TrendConfig config = const TrendConfig(),
  }) {
    if (current == null) return TrendState.insufficientData;
    if (previous == null) return TrendState.noPreviousData;
    if (currentSamples < config.minimumSamples ||
        previousSamples < config.minimumSamples) {
      return TrendState.insufficientData;
    }
    final delta = current - previous;
    final tolerance =
        config.absoluteTolerance > previous.abs() * config.relativeTolerance
        ? config.absoluteTolerance
        : previous.abs() * config.relativeTolerance;
    if (delta.abs() <= tolerance) return TrendState.stable;
    if (direction == MetricDirection.neutralComparison) {
      return TrendState.stable;
    }
    final positive = delta > 0;
    return (direction == MetricDirection.higherIsBetter ? positive : !positive)
        ? TrendState.improving
        : TrendState.declining;
  }
}
