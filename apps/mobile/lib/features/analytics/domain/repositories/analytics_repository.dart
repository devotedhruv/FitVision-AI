import '../models/analytics_period.dart';
import '../models/progress_summary.dart';

abstract interface class AnalyticsRepository {
  Future<ProgressSummary> summary(String userId, AnalyticsPeriod period);
}
