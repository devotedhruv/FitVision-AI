import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view_model.dart';
import 'package:fitvision_ai/features/exercise/presentation/workout_result_view.dart';
import 'package:fitvision_ai/features/phase_boundaries/presentation/phase_boundary_views.dart';
import 'package:fitvision_ai/features/settings/presentation/settings_view.dart';
import 'package:fitvision_ai/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _testConfig = AppConfig(
  environment: AppEnvironment.testing,
  apiBaseUrl: Uri.parse('https://api.example.test'),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pose_audio': true,
      'pose_haptics': true,
      'pose_front_camera': true,
      'pose_debug_overlay': false,
    });
  });

  testWidgets('Phase 4 splash and boundary screens render', (tester) async {
    for (final screen in const <Widget>[
      SplashView(),
      RunningSetupView(),
      LiveRunningView(),
      RunningResultView(),
      SessionDetailView(sessionId: 'session-1'),
      SettingsView(),
    ]) {
      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('camera guide fits a small screen with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final exercise = ExerciseMockRepository.exercises.first;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: LiveExerciseView(exercise: exercise),
        ),
      ),
    );
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byKey(const Key('enable-camera')),
      200,
    );

    expect(find.byKey(const Key('enable-camera')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('workout result renders measured Phase 5 statistics', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutResultView(
          result: WorkoutResultData(
            exerciseName: 'Squat',
            duration: Duration(seconds: 12),
            frontCamera: true,
            detectedFramePercentage: 75,
            averageLatencyMs: 80,
            completed: true,
          ),
        ),
      ),
    );

    expect(find.text('Completed reps'), findsOneWidget);
    expect(find.textContaining('75.0%'), findsOneWidget);
  });

  testWidgets('active session requires end confirmation', (tester) async {
    final exercise = ExerciseMockRepository.exercises.first;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          liveExerciseProvider.overrideWith(
            ActiveTestLiveExerciseViewModel.new,
          ),
        ],
        child: MaterialApp(home: LiveExerciseView(exercise: exercise)),
      ),
    );

    await tester.tap(find.byKey(const Key('end-session')));
    await tester.pumpAndSettle();

    expect(find.text('End camera session?'), findsOneWidget);
    expect(find.byKey(const Key('confirm-end-session')), findsOneWidget);
    await tester.tap(find.text('Keep going'));
    await tester.pumpAndSettle();
    expect(find.text('End camera session?'), findsNothing);
  });

  testWidgets('all required Phase 4 routes render safely', (tester) async {
    activeAuthViewModel = null;
    addTearDown(() => activeAuthViewModel = null);
    const routes = <String>[
      '/splash',
      '/auth/login',
      '/auth/register',
      '/onboarding/permissions',
      '/dashboard',
      '/exercises',
      '/exercises/squat',
      '/exercises/squat/live',
      '/exercises/squat/result',
      '/running/setup',
      '/running/live',
      '/running/result',
      '/history',
      '/history/session-1',
      '/analytics',
      '/profile',
      '/settings',
    ];
    for (final route in routes) {
      appRouter.go(route);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(_testConfig)],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        tester.takeException(),
        isNull,
        reason: '$route should render without a framework exception',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    }
  });

  testWidgets('invalid exercise and session parameters render safe states', (
    tester,
  ) async {
    activeAuthViewModel = null;
    addTearDown(() => activeAuthViewModel = null);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(_testConfig),
          exerciseRepositoryProvider.overrideWithValue(
            const ExerciseMockRepository(mode: MockDataMode.empty),
          ),
        ],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );

    appRouter.go('/exercises/not-a-real-exercise');
    await tester.pumpAndSettle();
    expect(find.text('Exercise not found'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(home: SessionDetailView(sessionId: '')),
    );
    expect(find.text('The requested session is invalid.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class ActiveTestLiveExerciseViewModel extends LiveExerciseViewModel {
  @override
  LivePoseSessionState build() => const LivePoseSessionState(
    stage: LivePoseStage.active,
    permission: CameraPermissionState.granted,
    feedback: 'Tracking active.',
  );
}
