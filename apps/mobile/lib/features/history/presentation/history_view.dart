import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/history/models/workout_history_item.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool _completedOnly = false;
  static final _items = [
    WorkoutHistoryItem(
      date: DateTime.now(),
      exerciseName: 'Squat',
      duration: const Duration(minutes: 8),
      repetitions: 10,
      status: WorkoutStatus.completed,
      demoFormScore: 84,
    ),
    WorkoutHistoryItem(
      date: DateTime.now().subtract(const Duration(days: 2)),
      exerciseName: 'Push-up',
      duration: const Duration(minutes: 5),
      repetitions: 6,
      status: WorkoutStatus.stopped,
      demoFormScore: 72,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = _items
        .where(
          (item) => !_completedOnly || item.status == WorkoutStatus.completed,
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          FilterChip(
            label: const Text('Completed only'),
            selected: _completedOnly,
            onSelected: (value) => setState(() => _completedOnly = value),
          ),
          const SizedBox(height: AppSpacing.md),
          if (shown.isEmpty)
            const Center(child: Text('No workouts match this filter.'))
          else
            for (final item in shown) ...[
              Text(
                DateTimeFormatter.shortDate(item.date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    item.status == WorkoutStatus.completed
                        ? Icons.check_circle_outline
                        : Icons.stop_circle_outlined,
                  ),
                  title: Text(item.exerciseName),
                  subtitle: Text(
                    '${item.duration.inMinutes} min • ${item.repetitions} reps\n'
                    '${item.status.name} • Demo form score ${item.demoFormScore}%',
                  ),
                  isThreeLine: true,
                ),
              ),
            ],
        ],
      ),
    );
  }
}
