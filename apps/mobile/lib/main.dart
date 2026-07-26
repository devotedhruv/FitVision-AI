import 'package:app_links/app_links.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/features/authentication/presentation/clerk_auth_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.load();
  if (!config.hasClerkConfiguration && !config.hasSupabaseConfiguration) {
    runApp(const _ConfigurationErrorApp());
    return;
  }
  if (config.hasSupabaseConfiguration) {
    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabasePublishableKey,
    );
  }
  runApp(
    config.hasClerkConfiguration
        ? ClerkAuth(
            config: ClerkAuthConfig(
              publishableKey: config.clerkPublishableKey,
              redirectionGenerator:
                  (BuildContext context, clerk.Strategy strategy) {
                    if (!strategy.isOauth) return null;
                    return Uri(
                      scheme: 'fitvision',
                      host: 'auth',
                      path: '/oauth',
                    );
                  },
              deepLinkStream: AppLinks().uriLinkStream.asyncMap((uri) async {
                if (uri.scheme == 'fitvision' &&
                    uri.host == 'auth' &&
                    uri.path == '/oauth') {
                  return uri;
                }
                return null;
              }),
            ),
            child: ClerkAuthScope(config: config, child: const FitVisionApp()),
          )
        : ProviderScope(
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
            '--dart-define=CLERK_PUBLISHABLE_KEY=pk_.... Supabase variables '
            'remain optional when Clerk is configured.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
