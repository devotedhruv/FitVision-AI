import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool audio = true;
  bool haptics = true;
  bool frontCamera = true;
  bool debugOverlay = false;

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
        const AboutListTile(
          applicationName: 'FitVision AI',
          applicationVersion: '1.0.0 (Phase 4)',
          applicationLegalese:
              'Fitness guidance prototype. Not medical or injury advice.',
        ),
      ],
    ),
  );
}
