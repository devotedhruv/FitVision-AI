import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('analytics route exposes period controls', (tester) async {
    await pumpTestApp(tester, '/analytics');
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('weekly'), findsOneWidget);
  });
}
