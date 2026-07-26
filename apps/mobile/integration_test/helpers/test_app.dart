import 'package:fitvision_ai/app/app.dart';
import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:fitvision_ai/features/dashboard/data/dashboard_mock_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/running/data/running_providers.dart';
import 'package:fitvision_ai/features/running/data/services/location_service.dart';
import 'package:fitvision_ai/features/running/domain/models/running_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpTestApp(
  WidgetTester tester,
  String route, {
  bool authenticated = true,
}) async {
  appRouter.go(route);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            environment: AppEnvironment.testing,
            apiBaseUrl: Uri.parse('https://api.test.example'),
          ),
        ),
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(authenticated: authenticated),
        ),
        dashboardRepositoryProvider.overrideWithValue(
          const DashboardMockRepository(),
        ),
        exerciseRepositoryProvider.overrideWithValue(
          const ExerciseMockRepository(),
        ),
        locationServiceProvider.overrideWithValue(const _FakeLocationService()),
      ],
      child: const FitVisionApp(),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository({required this.authenticated});
  final bool authenticated;
  static const user = AuthUser(
    id: 'integration-user',
    email: 'integration@example.test',
    emailVerified: true,
  );
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();
  @override
  String? get currentAccessToken => null;
  @override
  AuthUser? get currentUser => authenticated ? user : null;
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async => user;
  @override
  Future<void> logout() async {}
  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async => user;
}

class _FakeLocationService implements LocationService {
  const _FakeLocationService();
  @override
  Future<bool> get enabled async => true;
  @override
  Stream<RawLocation> get locations => const Stream.empty();
  @override
  Future<void> openSettings() async {}
  @override
  Future<LocationPermissionState> permission() async =>
      LocationPermissionState.denied;
  @override
  Future<LocationPermissionState> requestPermission() async =>
      LocationPermissionState.denied;
}
