import 'package:flutter_riverpod/legacy.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import '../data/running_providers.dart';
import 'running_view_model.dart';

final runningViewModelProvider = ChangeNotifierProvider<RunningViewModel>((
  ref,
) {
  final vm = RunningViewModel(
    repository: ref.watch(runningRepositoryProvider),
    auth: ref.watch(authRepositoryProvider),
    location: ref.watch(locationServiceProvider),
    background: ref.watch(backgroundTrackingServiceProvider),
  );
  return vm;
});
