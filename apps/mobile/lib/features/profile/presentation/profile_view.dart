import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/profile/data/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(currentProfileProvider),
            child: const Text('Retry profile'),
          ),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            CircleAvatar(
              radius: 42,
              child: Text(value.displayName.substring(0, 1).toUpperCase()),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(child: Text(value.displayName)),
            ListTile(
              leading: const Icon(Icons.straighten),
              title: const Text('Preferred units'),
              subtitle: Text(value.preferredUnits),
              onTap: () async {
                final next = value.preferredUnits == 'metric'
                    ? 'imperial'
                    : 'metric';
                await ref
                    .read(profileRepositoryProvider)
                    .update(preferredUnits: next);
                ref.invalidate(currentProfileProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('View analytics'),
              onTap: () => context.push('/analytics'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => ref.read(authViewModelProvider).logout(),
            ),
            const AboutListTile(
              icon: Icon(Icons.info_outline),
              applicationName: 'FitVision AI',
              applicationVersion: '1.0.0 (Phase 3)',
              applicationLegalese:
                  'Fitness guidance prototype; not medical advice.',
            ),
          ],
        ),
      ),
    );
  }
}
