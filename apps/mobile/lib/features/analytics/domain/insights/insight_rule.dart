import '../models/progress_insight.dart';
import '../models/progress_summary.dart';

abstract interface class InsightRule {
  String get id;
  int get priority;
  ProgressInsight? evaluate(ProgressSummary summary);
}
