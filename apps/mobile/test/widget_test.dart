import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('foundation status page shows configuration and health action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.testing,
              apiBaseUrl: Uri.parse('https://api.test.example'),
            ),
          ),
        ],
        child: const FitVisionApp(),
      ),
    );

    expect(find.text('FitVision AI'), findsOneWidget);
    expect(find.text('Phase 1 Foundation'), findsOneWidget);
    expect(find.text('testing'), findsOneWidget);
    expect(find.text('https://api.test.example'), findsOneWidget);
    expect(find.text('Check Backend Connection'), findsOneWidget);
  });
}
