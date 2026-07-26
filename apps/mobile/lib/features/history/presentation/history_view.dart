import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/features/history/domain/models/history_filter.dart';
import '../data/history_providers.dart';
import 'history_view_model.dart';
import 'widgets/history_empty_state.dart';
import 'widgets/history_filter_sheet.dart';
import 'widgets/history_item_card.dart';

final historyViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<HistoryViewModel, String>((ref, user) {
      final vm = HistoryViewModel(ref.watch(historyRepositoryProvider), user);
      Future.microtask(vm.load);
      return vm;
    });

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Sign in to view history.')),
      );
    }
    final vm = ref.watch(historyViewModelProvider(user.id));
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            tooltip: 'Filter activity history',
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filter = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => HistoryFilterSheet(initial: vm.filter),
              );
              if (filter != null) await vm.apply(filter);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollDirection: Axis.horizontal,
              children: [
                for (final category in HistoryCategoryFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: FilterChip(
                      selected: vm.filter.category == category,
                      showCheckmark: false,
                      label: Text(switch (category) {
                        HistoryCategoryFilter.all => 'All',
                        HistoryCategoryFilter.exercise => 'Workouts',
                        HistoryCategoryFilter.running => 'Running',
                      }),
                      onSelected: (_) =>
                          vm.apply(vm.filter.copyWith(category: category)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => vm.load(),
              child: vm.error != null && vm.items.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          child: Column(
                            children: [
                              const Icon(Icons.cloud_off_outlined, size: 48),
                              const SizedBox(height: AppSpacing.sm),
                              Text(vm.error!, textAlign: TextAlign.center),
                              const SizedBox(height: AppSpacing.md),
                              FilledButton.icon(
                                onPressed: vm.load,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : vm.items.isEmpty && !vm.loading
                  ? ListView(
                      children: const [
                        SizedBox(height: 200),
                        HistoryEmptyState(),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      itemCount: vm.items.length + (vm.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == vm.items.length) {
                          return TextButton(
                            onPressed: vm.loading
                                ? null
                                : () => vm.load(reset: false),
                            child: Text(vm.loading ? 'Loading…' : 'Load more'),
                          );
                        }
                        final item = vm.items[index];
                        return HistoryItemCard(
                          item: item,
                          onTap: () => context.push(
                            '/history/${item.category.name}:${item.localId}',
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
