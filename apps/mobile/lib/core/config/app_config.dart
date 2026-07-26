import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.supabaseUrl = '',
    this.supabasePublishableKey = '',
    this.clerkPublishableKey = '',
  });

  factory AppConfig.load() {
    const environmentValue = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8000',
    );
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabasePublishableKey = String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    );
    const clerkPublishableKey = String.fromEnvironment('CLERK_PUBLISHABLE_KEY');
    final environment = AppEnvironment.parse(environmentValue);
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw ArgumentError.value(
        apiBaseUrl,
        'API_BASE_URL',
        'A valid absolute URL is required',
      );
    }
    if (environment == AppEnvironment.production && uri.scheme != 'https') {
      throw ArgumentError('Production API_BASE_URL must use HTTPS');
    }
    if ((supabaseUrl.isEmpty) != (supabasePublishableKey.isEmpty)) {
      throw ArgumentError(
        'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY must be provided together.',
      );
    }
    final parsedSupabaseUrl = Uri.tryParse(supabaseUrl);
    if (supabaseUrl.isNotEmpty &&
        (parsedSupabaseUrl == null ||
            !parsedSupabaseUrl.hasScheme ||
            !parsedSupabaseUrl.hasAuthority)) {
      throw ArgumentError('SUPABASE_URL must be a valid absolute URL.');
    }
    return AppConfig(
      environment: environment,
      apiBaseUrl: uri,
      supabaseUrl: supabaseUrl,
      supabasePublishableKey: supabasePublishableKey,
      clerkPublishableKey: clerkPublishableKey,
    );
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final String supabaseUrl;
  final String supabasePublishableKey;
  final String clerkPublishableKey;

  bool get hasSupabaseConfiguration =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  bool get hasClerkConfiguration => clerkPublishableKey.isNotEmpty;
}

final appConfigProvider = Provider<AppConfig>(
  (ref) =>
      throw StateError('AppConfig must be overridden at application startup.'),
);
