import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('offline-capable history route has an explicit state', (
    tester,
  ) async {
    await pumpTestApp(tester, '/history');
    expect(find.text('History'), findsWidgets);
  });
}
