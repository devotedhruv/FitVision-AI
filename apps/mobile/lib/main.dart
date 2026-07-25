import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.load();
  if (!config.hasSupabaseConfiguration) {
    runApp(const _ConfigurationErrorApp());
    return;
  }
  await Supabase.initialize(
    url: config.supabaseUrl,
    publishableKey: config.supabasePublishableKey,
  );
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const FitVisionApp(),
    ),
  );
}

class _ConfigurationErrorApp extends StatelessWidget {
  const _ConfigurationErrorApp();

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'FitVision AI authentication is not configured. Restart with '
            '--dart-define=SUPABASE_URL=... and '
            '--dart-define=SUPABASE_PUBLISHABLE_KEY=....',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
