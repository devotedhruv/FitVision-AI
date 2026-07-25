import 'package:fitvision_ai/core/constants/app_constants.dart';
import 'package:fitvision_ai/core/design_system/app_icons.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/dashboard/data/dashboard_mock_repository.dart';
import 'package:fitvision_ai/features/dashboard/models/dashboard_summary.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/exercise_card.dart';
import 'package:fitvision_ai/shared/widgets/loading_indicator.dart';
import 'package:fitvision_ai/shared/widgets/primary_button.dart';
import 'package:fitvision_ai/shared/widgets/section_header.dart';
import 'package:fitvision_ai/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: summary.when(
        loading: () => const LoadingIndicator(label: 'Loading dashboard'),
        error: (error, stack) => ErrorView(
          message: 'We could not load the demo dashboard.',
          actionLabel: 'Retry',
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
        ),
        data: (data) => _DashboardContent(
          summary: data,
          onRefresh: () async => ref.refresh(dashboardSummaryProvider.future),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary, required this.onRefresh});
  final DashboardSummary summary;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    final featured = ExerciseMockRepository.exercises.take(2);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        key: const Key('dashboard-scroll'),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Semantics(
            header: true,
            child: Text(
              '$greeting, ${AppConstants.demoUserName}',
              style: AppTypography.pageTitle(context),
            ),
          ),
          Text(DateTimeFormatter.friendlyDate(DateTime.now())),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Start Workout',
            icon: AppIcons.exercises,
            onPressed: () => context.go('/exercises'),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Today’s activity'),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - AppSpacing.sm) / 2;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  SizedBox(
                    width: width,
                    child: StatCard(
                      label: 'Workout streak',
                      value: '${summary.streakDays} days',
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: StatCard(
                      label: 'Total workouts',
                      value: '${summary.totalWorkouts}',
                      icon: Icons.task_alt,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: StatCard(
                      label: 'Calories',
                      value: '${summary.estimatedCalories}',
                      helper: 'Demo estimate',
                      icon: Icons.bolt_outlined,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: StatCard(
                      label: 'Active minutes',
                      value: '${summary.activeMinutes}',
                      icon: Icons.timer_outlined,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Weekly goal: ${summary.weeklyCompleted} of ${summary.weeklyGoal} workouts',
          ),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            label:
                'Weekly goal ${summary.weeklyCompleted} of ${summary.weeklyGoal}',
            child: LinearProgressIndicator(
              value: summary.weeklyGoal == 0
                  ? 0
                  : summary.weeklyCompleted / summary.weeklyGoal,
              minHeight: AppSpacing.xs,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Recommended exercises'),
          for (final exercise in featured)
            ExerciseCard(
              exercise: exercise,
              onTap: () => context.push('/exercises/${exercise.id}'),
            ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Recent workout'),
          if (summary.recentWorkout == null)
            const _EmptyDashboard()
          else
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(summary.recentWorkout!),
                subtitle: const Text('Demo workout history'),
                onTap: () => context.go('/history'),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/running'),
                  icon: const Icon(AppIcons.running),
                  label: const Text('Running'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/analytics'),
                  icon: const Icon(AppIcons.analytics),
                  label: const Text('Analytics'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(Icons.event_available_outlined, size: 40),
          const SizedBox(height: AppSpacing.sm),
          const Text('No workouts yet. Start with a comfortable session.'),
          TextButton(
            onPressed: () => context.go('/exercises'),
            child: const Text('Browse exercises'),
          ),
        ],
      ),
    ),
  );
}
