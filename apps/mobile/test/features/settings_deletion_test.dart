import 'package:fitvision_ai/features/settings/presentation/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('history deletion requires explicit confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsView())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete workout and running history'));
    await tester.pumpAndSettle();

    expect(find.text('Delete all history?'), findsOneWidget);
    expect(find.textContaining('cannot be undone'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete history'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Delete all history?'), findsNothing);
  });
}
