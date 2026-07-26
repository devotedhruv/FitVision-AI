import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('permission onboarding explains collection boundaries', (
    tester,
  ) async {
    await pumpTestApp(tester, '/onboarding/permissions');
    expect(find.text('Move with clarity'), findsOneWidget);
    expect(find.text('Explore demo'), findsOneWidget);
  });
}
