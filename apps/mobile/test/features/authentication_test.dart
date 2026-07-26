import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/login_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/logout_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/register_user.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/profile/models/profile.dart';
import 'package:fitvision_ai/features/profile/data/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepository implements AuthRepository {
  final controller = StreamController<AuthUser?>.broadcast();
  AuthUser? user;
  String? token;
  bool loggedOut = false;

  @override
  Stream<AuthUser?> get authStateChanges => controller.stream;
  @override
  String? get currentAccessToken => token;
  @override
  AuthUser? get currentUser => user;
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return user = AuthUser(id: '1', email: email, emailVerified: true);
  }

  @override
  Future<void> logout() async {
    loggedOut = true;
    user = null;
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async => user = AuthUser(id: '1', email: email, emailVerified: false);
}

class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter({required this.status, required this.body});
  final int status;
  final Object body;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

AppConfig get config => AppConfig(
  environment: AppEnvironment.testing,
  apiBaseUrl: Uri.parse('https://api.example.test'),
);

void main() {
  test(
    'login and registration validate input before repository calls',
    () async {
      final repository = FakeAuthRepository();
      expect(
        () => LoginUser(repository)('invalid', 'password'),
        throwsFormatException,
      );
      expect(
        () => RegisterUser(repository)('user@example.test', 'short'),
        throwsFormatException,
      );
      final user = await LoginUser(repository)('user@example.test', 'password');
      expect(user.email, 'user@example.test');
    },
  );

  test('logout delegates to auth repository', () async {
    final repository = FakeAuthRepository();
    await LogoutUser(repository)();
    expect(repository.loggedOut, isTrue);
  });

  test('missing Supabase public configuration is detectable', () {
    expect(config.hasSupabaseConfiguration, isFalse);
  });

  test(
    'API attaches bearer token when present and omits it when absent',
    () async {
      final withToken = RecordingAdapter(status: 200, body: {'ok': true});
      await ApiClient(
        config,
        accessTokenProvider: () => 'test-access-token',
        dio: Dio()..httpClientAdapter = withToken,
      ).getJson('/resource');
      expect(
        withToken.request?.headers['Authorization'],
        'Bearer test-access-token',
      );

      final withoutToken = RecordingAdapter(status: 200, body: {'ok': true});
      await ApiClient(
        config,
        dio: Dio()..httpClientAdapter = withoutToken,
      ).getJson('/resource');
      expect(withoutToken.request?.headers['Authorization'], isNull);
    },
  );

  test('API maps HTTP 401 to unauthorized failure', () async {
    final adapter = RecordingAdapter(status: 401, body: {'error': 'invalid'});
    final client = ApiClient(config, dio: Dio()..httpClientAdapter = adapter);
    try {
      await client.getJson('/protected');
      fail('Expected an AppException');
    } on AppException catch (error) {
      expect(error.failure, isA<UnauthorizedFailure>());
    }
  });

  test('profile response maps allowed public fields', () {
    final profile = UserProfile.fromJson({
      'id': 'profile-id',
      'display_name': 'Alex',
      'avatar_url': null,
      'preferred_units': 'metric',
    });
    expect(profile.displayName, 'Alex');
    expect(profile.preferredUnits, 'metric');
  });

  test(
    'profile falls back to the last API-backed cache when offline',
    () async {
      SharedPreferences.setMockInitialValues({});
      final online = RecordingAdapter(
        status: 200,
        body: {
          'id': 'profile-id',
          'display_name': 'Alex',
          'avatar_url': null,
          'preferred_units': 'metric',
        },
      );
      final onlineRepository = ProfileRepository(
        ApiClient(config, dio: Dio()..httpClientAdapter = online),
      );
      final loaded = await onlineRepository.getMe();
      expect(loaded.isCached, isFalse);

      final unavailable = RecordingAdapter(
        status: 500,
        body: {'error': 'down'},
      );
      final offlineRepository = ProfileRepository(
        ApiClient(config, dio: Dio()..httpClientAdapter = unavailable),
      );
      final cached = await offlineRepository.getMe();

      expect(cached.displayName, 'Alex');
      expect(cached.isCached, isTrue);
    },
  );

  test('exercise API response maps into Phase 2 exercise model', () async {
    final adapter = RecordingAdapter(
      status: 200,
      body: [
        {
          'slug': 'squat',
          'name': 'Squat',
          'description': 'Controlled squat',
          'category': 'strength',
          'instructions': [
            {'step': 'Stand tall'},
          ],
        },
      ],
    );
    final repository = ExerciseApiRepository(
      ApiClient(config, dio: Dio()..httpClientAdapter = adapter),
    );
    final exercises = await repository.fetchExercises();
    expect(exercises.single.id, 'squat');
    expect(exercises.single.instructions, ['Stand tall']);
  });

  testWidgets('unauthenticated auth state redirects to login', (tester) async {
    final repository = FakeAuthRepository();
    appRouter.go('/dashboard');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const FitVisionApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Welcome back to FitVision AI'), findsOneWidget);
  });

  testWidgets(
    'authenticated users are redirected from login and registration',
    (tester) async {
      final repository = FakeAuthRepository()
        ..user = const AuthUser(
          id: 'authenticated-user',
          email: 'user@example.test',
          emailVerified: true,
        );
      addTearDown(repository.controller.close);
      appRouter.go('/auth/login');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            authRepositoryProvider.overrideWithValue(repository),
          ],
          child: const FitVisionApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);

      appRouter.go('/auth/register');
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Create your account'), findsNothing);
    },
  );
}
