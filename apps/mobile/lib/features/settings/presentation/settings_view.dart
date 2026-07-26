import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/profile/data/profile_repository.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_tutorial_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool audio = true;
  bool haptics = true;
  bool frontCamera = true;
  bool debugOverlay = false;
  bool deleting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      audio = preferences.getBool('pose_audio') ?? true;
      haptics = preferences.getBool('pose_haptics') ?? true;
      frontCamera = preferences.getBool('pose_front_camera') ?? true;
      debugOverlay = preferences.getBool('pose_debug_overlay') ?? false;
    });
  }

  Future<void> _set(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      children: [
        SwitchListTile(
          title: const Text('Audio feedback'),
          value: audio,
          onChanged: (value) {
            setState(() => audio = value);
            _set('pose_audio', value);
          },
        ),
        SwitchListTile(
          title: const Text('Haptic feedback'),
          value: haptics,
          onChanged: (value) {
            setState(() => haptics = value);
            _set('pose_haptics', value);
          },
        ),
        SwitchListTile(
          title: const Text('Prefer front camera'),
          subtitle: const Text('Can also be changed before a session starts.'),
          value: frontCamera,
          onChanged: (value) {
            setState(() => frontCamera = value);
            _set('pose_front_camera', value);
          },
        ),
        if (kDebugMode)
          SwitchListTile(
            title: const Text('Pose debug overlay'),
            value: debugOverlay,
            onChanged: (value) {
              setState(() => debugOverlay = value);
              _set('pose_debug_overlay', value);
            },
          ),
        const ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('Camera privacy'),
          subtitle: Text(
            'Pose inference runs on-device. Raw camera video is not uploaded '
            'or saved by default.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.school_outlined),
          title: const Text('Reset exercise tutorials'),
          subtitle: const Text(
            'Show the animated preparation guide again before every exercise.',
          ),
          onTap: () async {
            await ExerciseTutorialPreferences.resetAll();
            _message('Exercise tutorials reset.');
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever_outlined),
          title: const Text('Delete workout and running history'),
          subtitle: const Text(
            'Permanently removes synced history, routes, rep events and the '
            'local copies on this device. Your sign-in account remains.',
          ),
          enabled: !deleting,
          onTap: _confirmDeleteHistory,
        ),
        const AboutListTile(
          applicationName: 'FitVision AI',
          applicationVersion: '1.0.0 (Phase 4)',
          applicationLegalese:
              'Fitness guidance prototype. Not medical or injury advice.',
        ),
      ],
    ),
  );

  Future<void> _confirmDeleteHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all history?'),
        content: const Text(
          'This permanently deletes every workout, rep event, run and route. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete history'),
          ),
        ],
      ),
    );
    if (confirmed != true || deleting) return;
    final userId = ref.read(authRepositoryProvider).currentUser?.id;
    if (userId == null) {
      _message('Sign in again before deleting history.');
      return;
    }
    setState(() => deleting = true);
    try {
      await ref.read(profileRepositoryProvider).deleteRemoteData();
      await ref.read(localDatabaseProvider).deleteUserData(userId);
      await ref.read(profileRepositoryProvider).clearCache();
      ref.invalidate(currentProfileProvider);
      _message('Workout and running history deleted.');
    } catch (_) {
      _message('History was not deleted. Please try again.');
    } finally {
      if (mounted) setState(() => deleting = false);
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
