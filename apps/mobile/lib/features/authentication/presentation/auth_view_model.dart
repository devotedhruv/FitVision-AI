import 'dart:async';

import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/features/authentication/data/auth_repository_impl.dart';
import 'package:fitvision_ai/features/authentication/data/auth_service.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/login_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/logout_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/register_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

enum AuthStatus {
  loading,
  unauthenticated,
  verificationRequired,
  authenticated,
}

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this.repository) {
    _applyUser(repository.currentUser);
    _subscription = repository.authStateChanges.listen(
      _applyUser,
      onError: (_) {
        status = AuthStatus.unauthenticated;
        errorMessage = 'Authentication state could not be refreshed.';
        notifyListeners();
      },
    );
  }

  final AuthRepository repository;
  late final StreamSubscription<AuthUser?> _subscription;
  AuthStatus status = AuthStatus.loading;
  String? errorMessage;

  Future<void> login(String email, String password) async =>
      _perform(() => LoginUser(repository)(email, password));

  Future<void> register(String email, String password) async =>
      _perform(() => RegisterUser(repository)(email, password));

  Future<void> logout() async {
    await _perform(() async {
      await LogoutUser(repository)();
      return null;
    });
  }

  Future<void> _perform(Future<AuthUser?> Function() operation) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      _applyUser(await operation());
    } on AuthException catch (error) {
      status = AuthStatus.unauthenticated;
      errorMessage = error.message;
      notifyListeners();
    } on FormatException catch (error) {
      status = AuthStatus.unauthenticated;
      errorMessage = error.message;
      notifyListeners();
    } catch (_) {
      status = AuthStatus.unauthenticated;
      errorMessage = 'Authentication failed. Please try again.';
      notifyListeners();
    }
  }

  void _applyUser(AuthUser? user) {
    status = user == null
        ? AuthStatus.unauthenticated
        : user.emailVerified
        ? AuthStatus.authenticated
        : AuthStatus.verificationRequired;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

class _TestFallbackAuthRepository implements AuthRepository {
  const _TestFallbackAuthRepository();
  static const user = AuthUser(
    id: 'local-test-user',
    email: 'local@example.test',
    emailVerified: true,
  );

  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();
  @override
  String? get currentAccessToken => null;
  @override
  AuthUser? get currentUser => user;
  @override
  Future<AuthUser> login({required String email, required String password}) async =>
      user;
  @override
  Future<void> logout() async {}
  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async => user;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.hasSupabaseConfiguration) {
    return const _TestFallbackAuthRepository();
  }
  return AuthRepositoryImpl(AuthService(Supabase.instance.client));
});

final authViewModelProvider = Provider<AuthViewModel>((ref) {
  final model = AuthViewModel(ref.watch(authRepositoryProvider));
  ref.onDispose(model.dispose);
  return model;
});
