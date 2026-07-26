import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/running/domain/calculations/pace_calculator.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import '../data/analytics_providers.dart';
import 'analytics_view_model.dart';
import 'widgets/analytics_period_selector.dart';
import 'widgets/insight_card.dart';
import 'widgets/summary_card.dart';
import 'widgets/workout_chart.dart';

final analyticsViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnalyticsViewModel, String>((ref, user) {
      final vm = AnalyticsViewModel(
        ref.watch(analyticsRepositoryProvider),
        user,
      );
      Future.microtask(vm.load);
      return vm;
    });

class AnalyticsView extends ConsumerWidget {
  const AnalyticsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Sign in to view analytics.')),
      );
    }
    final vm = ref.watch(analyticsViewModelProvider(user.id)), s = vm.summary;
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: RefreshIndicator(
        onRefresh: () => vm.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('Your progress', style: AppTypography.pageTitle(context)),
            const Text('Trends are calculated only from your saved activity.'),
            const SizedBox(height: AppSpacing.md),
            AnalyticsPeriodSelector(
              value: vm.selected,
              onChanged: vm.selectPeriod,
            ),
            DropdownButtonFormField<String?>(
              initialValue: vm.exercise,
              decoration: const InputDecoration(labelText: 'Exercise'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All exercises')),
                DropdownMenuItem(value: 'squat', child: Text('Squat')),
                DropdownMenuItem(value: 'curl', child: Text('Biceps curl')),
                DropdownMenuItem(value: 'pushup', child: Text('Push-up')),
              ],
              onChanged: vm.selectExercise,
            ),
            const SizedBox(height: AppSpacing.md),
            if (vm.state == AnalyticsLoadState.loading)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (vm.state == AnalyticsLoadState.error)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Text('Analytics could not be loaded.'),
              )
            else if (s == null || vm.state == AnalyticsLoadState.empty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Text(
                  'Complete a workout or run to see your progress.',
                  textAlign: TextAlign.center,
                ),
              )
            else ...[
              if (vm.refreshError != null) Text(vm.refreshError!),
              if (vm.state == AnalyticsLoadState.partial)
                const Text(
                  'Some metrics are unavailable because form scores were not recorded.',
                ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  SummaryCard(
                    label: 'Active days',
                    value: '${s.activeDays}',
                    icon: Icons.calendar_today,
                  ),
                  SummaryCard(
                    label: 'Workouts',
                    value: '${s.exerciseSessions}',
                    icon: Icons.fitness_center,
                  ),
                  SummaryCard(
                    label: 'Valid reps',
                    value: '${s.validFormReps}',
                    icon: Icons.repeat,
                  ),
                  SummaryCard(
                    label: 'Running',
                    value:
                        '${(s.runningDistanceMeters / 1000).toStringAsFixed(1)} km',
                    icon: Icons.directions_run,
                  ),
                ],
              ),
              if (s.exercises.any((e) => e.sessionCount > 0)) ...[
                Text(
                  'Exercise progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                WorkoutChart(
                  items: s.exercises.where((e) => e.sessionCount > 0).toList(),
                ),
              ],
              if (s.running.runCount > 0) ...[
                Text(
                  'Running progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListTile(
                  title: const Text('Weighted average pace'),
                  trailing: Text(
                    '${PaceCalculator.format(s.averageRunningPace)} /km',
                  ),
                ),
                ListTile(
                  title: const Text('Runs'),
                  trailing: Text('${s.running.runCount}'),
                ),
              ],
              if (s.insights.isEmpty)
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(
                    'Complete a few more sessions to view a reliable trend.',
                  ),
                )
              else ...[
                Text('Insights', style: Theme.of(context).textTheme.titleLarge),
                ...s.insights.map((i) => InsightCard(insight: i)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
