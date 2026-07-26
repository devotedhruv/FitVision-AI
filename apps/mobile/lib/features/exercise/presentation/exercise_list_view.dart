import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/exercise_card.dart';
import 'package:fitvision_ai/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExerciseListView extends ConsumerStatefulWidget {
  const ExerciseListView({super.key});

  @override
  ConsumerState<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends ConsumerState<ExerciseListView> {
  String _query = '';
  ExerciseCategory? _category;
  ExerciseDifficulty? _difficulty;

  void _clear() => setState(() {
    _query = '';
    _category = null;
    _difficulty = null;
  });

  @override
  Widget build(BuildContext context) {
    final catalogue = ref.watch(exerciseCatalogueProvider);
    final isOffline = ref.watch(exerciseOfflineStatusProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      body: catalogue.when(
        loading: () => const LoadingIndicator(label: 'Loading exercises'),
        error: (error, stack) => ErrorView(
          message: 'We could not load the demo exercise catalogue.',
          actionLabel: 'Retry',
          onRetry: () => ref.invalidate(exerciseCatalogueProvider),
        ),
        data: (items) {
          final filtered = items.where((exercise) {
            final text = '${exercise.name} ${exercise.targetMuscles.join(' ')}'
                .toLowerCase();
            return text.contains(_query.toLowerCase()) &&
                (_category == null || exercise.category == _category) &&
                (_difficulty == null || exercise.difficulty == _difficulty);
          }).toList();
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(exerciseCatalogueProvider.future),
            child: ListView(
              key: const Key('exercise-list'),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (isOffline) ...[
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.cloud_off_outlined),
                      title: Text('Bundled offline catalogue'),
                      subtitle: Text(
                        'The FitVision API is unavailable. Camera exercises '
                        'remain usable with the bundled Phase 4 definitions.',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  'Find your next movement',
                  style: AppTypography.pageTitle(context),
                ),
                const Text(
                  'Explore safe demo sessions by goal and difficulty.',
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  key: const Key('exercise-search'),
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    labelText: 'Search exercises',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (!isOffline)
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryChip(
                          label: 'All',
                          icon: Icons.apps,
                          selected: _category == null,
                          onSelected: () => setState(() => _category = null),
                        ),
                        for (final value in ExerciseCategory.values)
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: _CategoryChip(
                              label: _label(value.name),
                              icon: _categoryIcon(value),
                              selected: _category == value,
                              onSelected: () =>
                                  setState(() => _category = value),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (!isOffline) const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<ExerciseCategory?>(
                  key: const Key('category-filter'),
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All categories'),
                    ),
                    for (final value in ExerciseCategory.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(_label(value.name)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<ExerciseDifficulty?>(
                  key: const Key('difficulty-filter'),
                  initialValue: _difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All difficulties'),
                    ),
                    for (final value in ExerciseDifficulty.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(_label(value.name)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _difficulty = value),
                ),
                const SizedBox(height: AppSpacing.md),
                if (items.isEmpty)
                  const _CatalogueEmpty()
                else if (filtered.isEmpty)
                  _NoResults(onClear: _clear)
                else
                  for (final exercise in filtered)
                    ExerciseCard(
                      exercise: exercise,
                      onTap: () => context.push('/exercises/${exercise.id}'),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _label(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';

  IconData _categoryIcon(ExerciseCategory category) => switch (category) {
    ExerciseCategory.strength => Icons.fitness_center,
    ExerciseCategory.mobility => Icons.accessibility_new,
    ExerciseCategory.cardio => Icons.favorite_border,
    ExerciseCategory.core => Icons.self_improvement,
  };
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => FilterChip(
    selected: selected,
    onSelected: (_) => onSelected(),
    avatar: Icon(icon, size: 16),
    label: Text(label),
    showCheckmark: false,
  );
}

class _CatalogueEmpty extends StatelessWidget {
  const _CatalogueEmpty();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.xl),
    child: Center(child: Text('No demo exercises are available right now.')),
  );
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.onClear});
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: [
        const Icon(Icons.search_off, size: 48),
        const Text('No exercises match those filters.'),
        TextButton(onPressed: onClear, child: const Text('Clear filters')),
      ],
    ),
  );
}
