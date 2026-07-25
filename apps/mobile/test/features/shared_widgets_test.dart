import 'package:fitvision_ai/shared/widgets/error_view.dart';
import 'package:fitvision_ai/shared/widgets/primary_button.dart';
import 'package:fitvision_ai/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('primary button invokes its action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(label: 'Continue', onPressed: () => tapped = true),
      ),
    );
    await tester.tap(find.text('Continue'));
    expect(tapped, isTrue);
  });

  testWidgets('stat card exposes accessible value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StatCard(label: 'Workouts', value: '4', icon: Icons.check),
      ),
    );
    expect(find.bySemanticsLabel('Workouts, 4'), findsOneWidget);
  });

  testWidgets('error view invokes recovery action', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorView(
          message: 'Failed',
          actionLabel: 'Retry',
          onRetry: () => retried = true,
        ),
      ),
    );
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });
}
