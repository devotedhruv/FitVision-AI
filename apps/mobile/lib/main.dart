import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.load();
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const FitVisionApp(),
    ),
  );
}
