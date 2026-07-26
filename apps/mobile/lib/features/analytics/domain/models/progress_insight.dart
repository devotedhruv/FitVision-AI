import 'analytics_period.dart';
import 'trend.dart';

enum InsightCategory {
  form,
  fullRange,
  consistency,
  runningDistance,
  runningPace,
  data,
}

enum InsightQuality { strong, limited, insufficient }

class ProgressInsight {
  const ProgressInsight({
    required this.code,
    required this.category,
    required this.priority,
    required this.metric,
    this.currentValue,
    this.previousValue,
    required this.direction,
    required this.localizationKey,
    required this.period,
    required this.quality,
  });
  final String code, metric, localizationKey;
  final InsightCategory category;
  final int priority;
  final double? currentValue, previousValue;
  final TrendState direction;
  final AnalyticsPeriod period;
  final InsightQuality quality;
}
