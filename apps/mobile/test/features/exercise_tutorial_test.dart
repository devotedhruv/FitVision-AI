import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_tutorial_preferences.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_tutorial_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/widgets/exercise_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('all bundled exercise IDs have native animation mappings', () {
    final ids = ExerciseMockRepository.exercises.map((item) => item.id).toSet();
    expect(ExerciseAnimationRegistry.supportedIds, containsAll(ids));
    expect(
      ExerciseAnimationRegistry.resolve('unknown').motion,
      ExerciseMotion.fallback,
    );
  });

  test(
    'tutorial skip preference is stored per exercise and can reset',
    () async {
      expect(await ExerciseTutorialPreferences.shouldShow('squat'), isTrue);
      await ExerciseTutorialPreferences.complete('squat', skipNextTime: true);
      expect(await ExerciseTutorialPreferences.hasSeen('squat'), isTrue);
      expect(await ExerciseTutorialPreferences.shouldShow('squat'), isFalse);
      expect(await ExerciseTutorialPreferences.shouldShow('push-up'), isTrue);
      await ExerciseTutorialPreferences.resetAll();
      expect(await ExerciseTutorialPreferences.shouldShow('squat'), isTrue);
    },
  );

  testWidgets('tutorial completes before invoking the existing start action', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _TutorialHarness()));
    await tester.tap(find.text('Open tutorial'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Demonstration'), findsOneWidget);
    expect(find.text('Started'), findsNothing);

    for (var step = 0; step < 3; step++) {
      await tester.tap(find.byKey(const Key('tutorial-next')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }
    await tester.tap(find.byKey(const Key('tutorial-ready')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Started'), findsOneWidget);
  });

  testWidgets('reduced motion shows a static accessible demonstration', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SizedBox(
              width: 220,
              height: 220,
              child: ExerciseAnimation(exerciseId: 'squat', autoPlay: true),
            ),
          ),
        ),
      ),
    );
    expect(
      find.byTooltip('Animation disabled by reduced motion setting'),
      findsOneWidget,
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });
}

class _TutorialHarness extends StatefulWidget {
  const _TutorialHarness();

  @override
  State<_TutorialHarness> createState() => _TutorialHarnessState();
}

class _TutorialHarnessState extends State<_TutorialHarness> {
  bool started = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: started
          ? const Text('Started')
          : FilledButton(
              onPressed: () async {
                final ready = await showExerciseTutorial(
                  context,
                  ExerciseMockRepository.exercises.first,
                );
                if (ready && mounted) setState(() => started = true);
              },
              child: const Text('Open tutorial'),
            ),
    ),
  );
}
