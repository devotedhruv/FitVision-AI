import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/features/dashboard/data/dashboard_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class OfflineExerciseRepository implements ExerciseRepository {
  const OfflineExerciseRepository();

  @override
  Future<List<Exercise>> fetchExercises() =>
      Future.error(const AppException(NetworkFailure()));
}

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    DashboardMockRepository dashboard = const DashboardMockRepository(),
    ExerciseRepository exercises = const ExerciseMockRepository(),
    bool settle = true,
  }) async {
    appRouter.go('/dashboard');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.testing,
              apiBaseUrl: Uri.parse('https://api.test.example'),
            ),
          ),
          dashboardRepositoryProvider.overrideWithValue(dashboard),
          exerciseRepositoryProvider.overrideWithValue(exercises),
        ],
        child: const FitVisionApp(),
      ),
    );
    if (settle) await tester.pumpAndSettle();
  }

  testWidgets('application starts on dashboard', (tester) async {
    await pumpApp(tester);
    expect(find.textContaining('local'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);
  });

  testWidgets('dashboard shows loading state', (tester) async {
    await pumpApp(tester, settle: false);
    expect(find.bySemanticsLabel('Loading dashboard'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  });

  testWidgets('dashboard supports empty state', (tester) async {
    await pumpApp(
      tester,
      dashboard: const DashboardMockRepository(mode: MockDataMode.empty),
    );
    await tester.scrollUntilVisible(
      find.textContaining('No workouts yet'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('No workouts yet'), findsOneWidget);
  });

  testWidgets('dashboard supports recoverable error state', (tester) async {
    await pumpApp(
      tester,
      dashboard: const DashboardMockRepository(mode: MockDataMode.error),
    );
    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('could not load'), findsOneWidget);
  });

  testWidgets('bottom navigation opens and highlights running', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Running').last);
    await tester.pumpAndSettle();
    expect(find.text('Running setup'), findsOneWidget);
    expect(appRouter.routeInformationProvider.value.uri.path, '/running/setup');
  });

  testWidgets('dashboard start action opens exercise list', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Start Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Find your next movement'), findsOneWidget);
  });

  testWidgets('exercise search filters local data', (tester) async {
    await pumpApp(tester);
    appRouter.go('/exercises');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('exercise-search')), 'plank');
    await tester.pump();
    expect(find.text('Plank'), findsOneWidget);
    expect(find.text('Squat'), findsNothing);
  });

  testWidgets('exercise category filter works', (tester) async {
    await pumpApp(tester);
    appRouter.go('/exercises');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Core').last);
    await tester.pumpAndSettle();
    expect(find.text('Plank'), findsOneWidget);
    expect(find.text('Squat'), findsNothing);
  });

  testWidgets('exercise card opens details by id', (tester) async {
    await pumpApp(tester);
    appRouter.go('/exercises');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Squat').first);
    await tester.pumpAndSettle();
    expect(find.text('How to perform'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Open Camera Guide'), 300);
    expect(find.text('Open Camera Guide'), findsOneWidget);
  });

  testWidgets('invalid exercise id has safe recovery UI', (tester) async {
    await pumpApp(tester);
    appRouter.go('/exercises/not-real');
    await tester.pumpAndSettle();
    expect(find.text('Exercise not found'), findsOneWidget);
    expect(find.text('Browse exercises'), findsOneWidget);
  });

  testWidgets('detail route resolves the configured repository catalogue', (
    tester,
  ) async {
    await pumpApp(
      tester,
      exercises: const ExerciseMockRepository(mode: MockDataMode.empty),
    );

    appRouter.go('/exercises/squat');
    await tester.pumpAndSettle();

    expect(find.text('Exercise not found'), findsOneWidget);
    expect(find.text('How to perform'), findsNothing);
  });

  testWidgets('detail route exposes repository loading and error states', (
    tester,
  ) async {
    await pumpApp(
      tester,
      exercises: const ExerciseMockRepository(mode: MockDataMode.error),
      settle: false,
    );
    appRouter.go('/exercises/squat');
    await tester.pump();
    expect(find.bySemanticsLabel('Loading exercise details'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Exercise unavailable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('empty catalogue renders explicit state', (tester) async {
    await pumpApp(
      tester,
      exercises: const ExerciseMockRepository(mode: MockDataMode.empty),
    );
    appRouter.go('/exercises');
    await tester.pumpAndSettle();
    expect(find.textContaining('No demo exercises'), findsOneWidget);
  });

  testWidgets('catalogue error offers retry', (tester) async {
    await pumpApp(
      tester,
      exercises: const ExerciseMockRepository(mode: MockDataMode.error),
    );
    appRouter.go('/exercises');
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('network failure uses a clearly labelled offline catalogue', (
    tester,
  ) async {
    await pumpApp(tester, exercises: const OfflineExerciseRepository());
    appRouter.go('/exercises');
    await tester.pumpAndSettle();

    expect(find.text('Bundled offline catalogue'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}
