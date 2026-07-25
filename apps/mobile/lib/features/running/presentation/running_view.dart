import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class RunningView extends StatefulWidget {
  const RunningView({super.key});
  @override
  State<RunningView> createState() => _RunningViewState();
}

class _RunningViewState extends State<RunningView> {
  bool _previewStarted = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Running')),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Card(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.map_outlined, size: 56),
                  Text(
                    _previewStarted
                        ? 'RUN PREVIEW READY'
                        : 'GPS MAP PLACEHOLDER',
                  ),
                  const Text('Location is not being tracked'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Distance',
                value: '0.00 km',
                icon: Icons.route,
              ),
            ),
            Expanded(
              child: StatCard(
                label: 'Duration',
                value: '00:00',
                icon: Icons.timer_outlined,
              ),
            ),
          ],
        ),
        const StatCard(
          label: 'Average pace',
          value: '-- min/km',
          icon: Icons.speed_outlined,
        ),
        FilledButton.icon(
          onPressed: () {
            setState(() => _previewStarted = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Run preview started. GPS remains off.'),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start run preview'),
        ),
        const SizedBox(height: AppSpacing.md),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Phase 2 preview'),
            subtitle: Text(
              'Real GPS, routes, distance, and pace tracking will be implemented in a later phase.',
            ),
          ),
        ),
      ],
    ),
  );
}
