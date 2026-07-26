import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('running setup starts in a non-collecting state', (tester) async {
    await pumpTestApp(tester, '/running/setup');
    expect(find.text('Running setup'), findsOneWidget);
    expect(find.text('Enable precise location'), findsOneWidget);
  });
}
