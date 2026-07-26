import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/running_providers.dart';
import '../domain/calculations/pace_calculator.dart';
import 'widgets/route_map.dart';

final runningDetailsProvider = FutureProvider.autoDispose.family(
  (ref, String id) => ref.watch(runningRepositoryProvider).get(id),
);

class RunningResultView extends ConsumerWidget {
  const RunningResultView({required this.localId, super.key});
  final String localId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(runningDetailsProvider(localId));
    return Scaffold(
      appBar: AppBar(title: const Text('Running result')),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Run saved, but details could not be loaded.'),
        ),
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Run not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RouteMap(points: session.routePoints),
              ListTile(
                title: const Text('Distance'),
                trailing: Text(
                  '${(session.distanceMeters / 1000).toStringAsFixed(2)} km',
                ),
              ),
              ListTile(
                title: const Text('Active duration'),
                trailing: Text(
                  '${session.accumulatedActiveDuration.inMinutes} min ${session.accumulatedActiveDuration.inSeconds % 60} sec',
                ),
              ),
              ListTile(
                title: const Text('Average pace'),
                trailing: Text(
                  '${PaceCalculator.format(session.averagePaceSecondsPerKm)} /km',
                ),
              ),
              ListTile(
                title: const Text('Average speed'),
                trailing: Text(
                  '${((session.averageSpeedMps ?? 0) * 3.6).toStringAsFixed(1)} km/h',
                ),
              ),
              ListTile(
                title: const Text('GPS points'),
                trailing: Text(
                  '${session.routePoints.where((point) => point.accepted).length} accepted',
                ),
              ),
              ListTile(
                leading: Icon(
                  session.syncState.name == 'synced'
                      ? Icons.cloud_done
                      : Icons.cloud_upload_outlined,
                ),
                title: Text(
                  session.syncState.name == 'synced'
                      ? 'Synced'
                      : 'Saved on device',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
