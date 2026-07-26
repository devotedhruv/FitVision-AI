import 'package:flutter/material.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/running/domain/calculations/pace_calculator.dart';
import '../../domain/models/history_item.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';

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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(
            running ? Icons.directions_run : Icons.fitness_center,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(name),
        subtitle: Text(
          '${_duration(item.activeDuration)}  •  $detail',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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

  String _duration(Duration value) => value.inHours > 0
      ? '${value.inHours}h ${value.inMinutes.remainder(60)}m'
      : '${value.inMinutes} min';
}
