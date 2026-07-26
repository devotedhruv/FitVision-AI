import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('exercise catalogue opens a deterministic workout entry', (
    tester,
  ) async {
    await pumpTestApp(tester, '/exercises');
    expect(find.text('Find your next movement'), findsOneWidget);
    expect(find.text('Squat'), findsWidgets);
  });
}
