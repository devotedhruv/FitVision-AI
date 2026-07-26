import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('authentication route renders without a live backend', (
    tester,
  ) async {
    await pumpTestApp(tester, '/auth/login', authenticated: false);
    expect(find.textContaining('Welcome back'), findsOneWidget);
  });
}
