import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  const AppConfig({required this.environment, required this.apiBaseUrl});

  factory AppConfig.load() {
    const environmentValue = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8000',
    );
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
    return AppConfig(environment: environment, apiBaseUrl: uri);
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
}

final appConfigProvider = Provider<AppConfig>(
  (ref) =>
      throw StateError('AppConfig must be overridden at application startup.'),
);
