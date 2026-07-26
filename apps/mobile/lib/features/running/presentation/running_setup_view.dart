import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/running_status.dart';
import 'running_providers.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/core/design_system/app_colors.dart';

class RunningSetupView extends ConsumerStatefulWidget {
  const RunningSetupView({super.key});
  @override
  ConsumerState<RunningSetupView> createState() => _State();
}

class _State extends ConsumerState<RunningSetupView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(runningViewModelProvider).prepare());
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(runningViewModelProvider);
    final precise =
        vm.permission == LocationPermissionState.foregroundGrantedPrecise;
    return Scaffold(
      appBar: AppBar(title: const Text('Running setup')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            ),
            child: Column(
              children: [
                const Icon(Icons.directions_run, size: 72),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Ready for your next run?',
                  style: AppTypography.pageTitle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'FitVision uses precise location only during a run to measure distance and keep tracking with the screen off.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: Icon(
                precise ? Icons.check_circle : Icons.location_searching,
                color: precise
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.warning,
              ),
              title: Text(_permission(vm.permission)),
              subtitle: Text(
                vm.message ??
                    'Your route is stored on this device before synchronization.',
              ),
            ),
          ),
          if (!precise)
            FilledButton.icon(
              onPressed: vm.busy ? null : vm.requestLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Enable precise location'),
            ),
          if (vm.permission == LocationPermissionState.permanentlyDenied ||
              vm.permission ==
                  LocationPermissionState.foregroundGrantedApproximate)
            TextButton(
              onPressed: vm.openSettings,
              child: const Text('Open settings'),
            ),
          if (precise)
            FilledButton.icon(
              onPressed: vm.busy
                  ? null
                  : () async {
                      await vm.start();
                      if (context.mounted &&
                          vm.status == RunningStatus.running) {
                        context.push('/running/live');
                      }
                    },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start run'),
            ),
        ],
      ),
    );
  }

  String _permission(LocationPermissionState p) => switch (p) {
    LocationPermissionState.foregroundGrantedPrecise =>
      'Precise location ready',
    LocationPermissionState.foregroundGrantedApproximate =>
      'Approximate location only',
    LocationPermissionState.permanentlyDenied => 'Location permission blocked',
    LocationPermissionState.serviceDisabled => 'Location services are off',
    LocationPermissionState.notificationDenied =>
      'Notification permission is required',
    _ => 'Location permission needed',
  };
}
