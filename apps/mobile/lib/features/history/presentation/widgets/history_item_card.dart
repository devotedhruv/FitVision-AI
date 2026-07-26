import 'package:flutter/material.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/running/domain/calculations/pace_calculator.dart';
import '../../domain/models/history_item.dart';

class HistoryItemCard extends StatelessWidget {
  const HistoryItemCard({required this.item, required this.onTap, super.key});
  final HistoryItem item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final running = item.category == HistoryCategory.running;
    final name = running
        ? 'Outdoor run'
        : switch (item.exerciseType) {
            'squat' => 'Squat',
            'curl' => 'Biceps curl',
            'pushup' => 'Push-up',
            _ => 'Exercise',
          };
    final detail = running
        ? '${DateTimeFormatter.shortDate(item.startedAt.toLocal())} • ${((item.distanceMeters ?? 0) / 1000).toStringAsFixed(2)} km • ${PaceCalculator.format(item.averagePaceSecondsPerKm)} /km'
        : '${DateTimeFormatter.shortDate(item.startedAt.toLocal())} • ${item.completedReps ?? 0} reps • ${item.validFormReps ?? 0} valid';
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(running ? Icons.directions_run : Icons.fitness_center),
        title: Text(name),
        subtitle: Text(detail),
        trailing: Icon(
          item.syncStatus == 'synced'
              ? Icons.cloud_done_outlined
              : item.syncStatus == 'failed' || item.syncStatus == 'conflict'
              ? Icons.cloud_off_outlined
              : Icons.cloud_upload_outlined,
        ),
      ),
    );
  }
}
