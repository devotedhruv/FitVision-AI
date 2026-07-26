import '../models/progress_insight.dart';
import '../models/progress_summary.dart';
import 'insight_rule.dart';

class InsightEngine {
  const InsightEngine(this.rules, {this.maximumInsights = 4});
  final List<InsightRule> rules;
  final int maximumInsights;
  List<ProgressInsight> generate(ProgressSummary summary) {
    final seen = <String>{};
    final values =
        rules
            .map((r) => r.evaluate(summary))
            .whereType<ProgressInsight>()
            .where((i) => seen.add(i.code))
            .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority));
    return List.unmodifiable(values.take(maximumInsights));
  }
}
