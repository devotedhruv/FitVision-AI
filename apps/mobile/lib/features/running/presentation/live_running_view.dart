import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/running_status.dart';
import 'running_providers.dart';
import 'widgets/route_map.dart';
import 'widgets/pace_display.dart';
import 'widgets/running_controls.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';

class LiveRunningView extends ConsumerWidget {
  const LiveRunningView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(runningViewModelProvider),
        m = vm.metrics,
        s = vm.session;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            vm.status == RunningStatus.paused ? 'Run paused' : 'Live run',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            RouteMap(points: s?.routePoints ?? const []),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: _metric(
                        context,
                        'Distance',
                        '${(m.totalAcceptedDistanceMeters / 1000).toStringAsFixed(2)} km',
                      ),
                    ),
                    Expanded(
                      child: _metric(
                        context,
                        'Active time',
                        _duration(m.activeDuration),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: PaceDisplay(pace: m.averagePaceSecondsPerKm)),
            Center(
              child: Text(
                'GPS: ${m.gpsQuality.name} • ${m.acceptedPointCount} accepted',
              ),
            ),
            if (vm.message != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(vm.message!, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 16),
            RunningControls(
              paused: vm.status == RunningStatus.paused,
              busy: vm.busy,
              onPauseResume: vm.status == RunningStatus.paused
                  ? vm.resume
                  : vm.pause,
              onFinish: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Finish run?'),
                    content: const Text(
                      'Your run will be saved on this device.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Finish'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  final id = await vm.finish();
                  if (context.mounted && id != null) {
                    context.go('/running/result', extra: id);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(BuildContext c, String label, String value) => Column(
    children: [
      Text(value, style: AppTypography.metric(c)),
      Text(label, style: Theme.of(c).textTheme.labelMedium),
    ],
  );
  static String _duration(Duration d) =>
      '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}
