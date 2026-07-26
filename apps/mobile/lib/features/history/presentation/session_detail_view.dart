import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/running/domain/calculations/pace_calculator.dart';
import 'package:fitvision_ai/features/running/presentation/widgets/route_map.dart';
import '../data/history_providers.dart';
import '../domain/models/history_item.dart';
import '../domain/models/session_detail.dart';

final sessionDetailProvider = FutureProvider.autoDispose.family(
  (ref, ({String user, String id, HistoryCategory category}) key) => ref
      .watch(historyRepositoryProvider)
      .detail(key.user, key.id, key.category),
);

class SessionDetailView extends ConsumerWidget {
  const SessionDetailView({required this.sessionKey, super.key});
  final String sessionKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final split = sessionKey.split(':');
    if (user == null || split.length < 2) {
      return const Scaffold(
        body: Center(child: Text('Session is unavailable.')),
      );
    }
    final category = split.first == 'running'
        ? HistoryCategory.running
        : HistoryCategory.exercise;
    final detail = ref.watch(
      sessionDetailProvider((
        user: user.id,
        id: split.sublist(1).join(':'),
        category: category,
      )),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Session details')),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Session details could not be loaded.')),
        data: (value) {
          if (value case ExerciseSessionDetail(:final session)) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  session.exerciseType.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ListTile(
                  title: const Text('Active duration'),
                  trailing: Text(
                    '${session.accumulatedActiveDuration.inMinutes} min',
                  ),
                ),
                ListTile(
                  title: const Text('Completed reps'),
                  trailing: Text('${session.completedRepCount}'),
                ),
                ListTile(
                  title: const Text('Incomplete reps'),
                  trailing: Text('${session.incompleteRepCount}'),
                ),
                ListTile(
                  title: const Text('Valid-form reps'),
                  trailing: Text('${session.validFormRepCount}'),
                ),
                ...session.repEvents.map(
                  (rep) => ListTile(
                    title: Text('Rep ${rep.sequenceNumber + 1}'),
                    subtitle: Text(
                      '${rep.duration.inMilliseconds} ms • ${rep.feedbackCodes.join(', ')}',
                    ),
                    trailing: Icon(
                      rep.formValid ? Icons.check : Icons.info_outline,
                    ),
                  ),
                ),
              ],
            );
          }
          if (value case RunningSessionDetail(:final session)) {
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
                    '${session.accumulatedActiveDuration.inMinutes} min',
                  ),
                ),
                ListTile(
                  title: const Text('Paused duration'),
                  trailing: Text(
                    '${session.accumulatedPausedDuration.inMinutes} min',
                  ),
                ),
                ListTile(
                  title: const Text('Average pace'),
                  trailing: Text(
                    '${PaceCalculator.format(session.averagePaceSecondsPerKm)} /km',
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Session was not found.'));
        },
      ),
    );
  }
}
