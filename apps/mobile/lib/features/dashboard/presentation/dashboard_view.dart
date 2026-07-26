import 'package:fitvision_ai/core/design_system/app_icons.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/dashboard/data/dashboard_mock_repository.dart';
import 'package:fitvision_ai/features/dashboard/models/dashboard_summary.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/profile/data/profile_repository.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/exercise_card.dart';
import 'package:fitvision_ai/shared/widgets/loading_indicator.dart';
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
    final profile = ref.watch(currentProfileProvider);
    final authUser = ref.watch(authViewModelProvider).repository.currentUser;
    final displayName = profile.asData?.value.displayName.trim();
    final greetingName = displayName != null && displayName.isNotEmpty
        ? displayName
        : authUser?.resolvedDisplayName ?? 'Athlete';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Open profile',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: summary.when(
        loading: () => const LoadingIndicator(label: 'Loading dashboard'),
        error: (error, stack) => ErrorView(
          message: 'We could not load the demo dashboard.',
          actionLabel: 'Retry',
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
        ),
        data: (data) => _DashboardContent(
          summary: data,
          displayName: greetingName,
          onRefresh: () async => ref.refresh(dashboardSummaryProvider.future),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
    required this.displayName,
    required this.onRefresh,
  });
  final DashboardSummary summary;
  final String displayName;
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
              '$greeting, $displayName',
              style: AppTypography.pageTitle(context),
            ),
          ),
          Text(DateTimeFormatter.friendlyDate(DateTime.now())),
          const SizedBox(height: AppSpacing.lg),
          _CoachHero(onStart: () => context.go('/exercises')),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Weekly goal')),
                      Text(
                        '${summary.weeklyCompleted} of ${summary.weeklyGoal} workouts',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label:
                              'Weekly goal ${summary.weeklyCompleted} of ${summary.weeklyGoal}',
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            tween: Tween(
                              end: summary.weeklyGoal == 0
                                  ? 0
                                  : summary.weeklyCompleted /
                                        summary.weeklyGoal,
                            ),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                  value: value.clamp(0, 1),
                                  minHeight: AppSpacing.xs,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${summary.weeklyGoal == 0 ? 0 : (summary.weeklyCompleted / summary.weeklyGoal * 100).round()}%',
                      ),
                    ],
                  ),
                ],
              ),
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

class _CoachHero extends StatelessWidget {
  const _CoachHero({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surfaceContainerLow,
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .5),
        ],
      ),
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .7),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chip(
          avatar: const Icon(Icons.auto_awesome, size: 16),
          label: const Text('AI Coach'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Track. Improve. Achieve.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Smart exercise detection with real-time posture analysis and feedback.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: onStart,
          icon: const Icon(AppIcons.exercises),
          label: const Text('Start Workout'),
        ),
      ],
    ),
  );
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
