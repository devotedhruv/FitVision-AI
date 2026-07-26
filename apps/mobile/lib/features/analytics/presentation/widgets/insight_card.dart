import 'package:flutter/material.dart';
import '../../domain/models/progress_insight.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({required this.insight, super.key});
  final ProgressInsight insight;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.lightbulb_outline),
      title: Text(_text(insight)),
      subtitle: Text('Based on ${insight.metric.replaceAll('_', ' ')}'),
    ),
  );
  String _text(ProgressInsight i) {
    if (i.code.startsWith('form_improved_')) {
      return 'Your ${i.code.split('_').last} form quality improved compared with the previous period.';
    }
    if (i.code.startsWith('form_stable_')) {
      return 'Your ${i.code.split('_').last} form quality remained stable.';
    }
    return switch (i.code) {
      'pace_improved' =>
        'Your average running pace improved compared with the previous period.',
      'pace_stable' => 'Your average running pace remained stable.',
      'activity_days_more' =>
        'You recorded activity on more days than the previous period.',
      'activity_days_summary' =>
        'You recorded activity on ${i.currentValue?.round() ?? 0} days in this period.',
      'running_distance_summary' =>
        'Your running-distance pattern is available for comparison.',
      _ => 'Your full-range repetition pattern is available for review.',
    };
  }
}
