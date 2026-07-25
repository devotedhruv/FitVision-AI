import 'package:fitvision_ai/core/constants/app_constants.dart';
import 'package:fitvision_ai/core/design_system/app_icons.dart';
import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notifications = false;

  void _comingSoon(String label) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$label is coming soon.')));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const CircleAvatar(radius: 42, child: Text('A')),
        const SizedBox(height: AppSpacing.sm),
        const Center(child: Text(AppConstants.demoUserName)),
        const Center(child: Text('Goal: build consistent movement habits')),
        const SizedBox(height: AppSpacing.lg),
        const ListTile(
          leading: Icon(Icons.flag_outlined),
          title: Text('Weekly target'),
          trailing: Text('4 workouts'),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('Demo notifications'),
          subtitle: const Text('Preference only; no notifications are sent'),
          value: _notifications,
          onChanged: (value) => setState(() => _notifications = value),
        ),
        const ListTile(
          leading: Icon(Icons.brightness_6_outlined),
          title: Text('Theme'),
          subtitle: Text('Uses your system light or dark setting'),
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Permissions'),
          subtitle: const Text('Camera and location have not been requested'),
          onTap: () => _comingSoon('Permission management'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy information'),
          onTap: () => _comingSoon('Privacy information'),
        ),
        ListTile(
          leading: const Icon(AppIcons.analytics),
          title: const Text('View analytics'),
          onTap: () => context.push('/analytics'),
        ),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'FitVision AI',
          applicationVersion: '1.0.0 (Phase 2 demo)',
          applicationLegalese:
              'Fitness guidance prototype; not medical advice.',
        ),
      ],
    ),
  );
}
