import 'dart:async';

import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/config/app_environment.dart';
import 'package:fitvision_ai/features/authentication/data/auth_repository_impl.dart';
import 'package:fitvision_ai/features/authentication/data/auth_service.dart';
import 'package:fitvision_ai/features/authentication/data/clerk_auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/login_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/logout_user.dart';
import 'package:fitvision_ai/features/authentication/domain/use_cases/register_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:clerk_auth/clerk_auth.dart' as clerk;

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

  /// Re-reads the provider session after returning from an external OAuth app.
  /// Some Android browsers resume the activity without emitting a provider
  /// listener event, so the router must be given an explicit refresh point.
  void refreshFromProvider() {
    _applyUser(repository.currentUser);
  }

  Future<void> login(String email, String password) async =>
      _perform(() => LoginUser(repository)(email, password));

  Future<void> register(String email, String password) async =>
      _perform(() => RegisterUser(repository)(email, password));

  Future<void> registerWithName(
    String fullName,
    String email,
    String password,
  ) async => _perform(() {
    final advanced = repository;
    if (advanced is AdvancedAuthRepository) {
      return (advanced as AdvancedAuthRepository).registerWithName(
        fullName: fullName,
        email: email,
        password: password,
      );
    }
    return RegisterUser(repository)(email, password);
  });

  Future<void> verifyEmail(String code) async => _perform(() {
    final advanced = repository;
    if (advanced is! AdvancedAuthRepository) {
      throw const FormatException(
        'Return after opening the verification link in your email.',
      );
    }
    return (advanced as AdvancedAuthRepository).verifyEmail(code);
  });

  Future<void> requestPasswordReset(String email) async {
    final advanced = repository;
    if (advanced is! AdvancedAuthRepository) {
      errorMessage = 'Password recovery is unavailable for this auth provider.';
      notifyListeners();
      return;
    }
    await _perform(() async {
      await (advanced as AdvancedAuthRepository).requestPasswordReset(email);
      return null;
    }, preserveSignedOut: true);
  }

  Future<void> completePasswordReset(String code, String password) async =>
      _perform(() {
        final advanced = repository;
        if (advanced is! AdvancedAuthRepository) {
          throw const FormatException('Password recovery is unavailable.');
        }
        return (advanced as AdvancedAuthRepository).completePasswordReset(
          code: code,
          newPassword: password,
        );
      });

  Future<void> logout() async {
    await _perform(() async {
      await LogoutUser(repository)();
      return null;
    });
  }

  Future<void> _perform(
    Future<AuthUser?> Function() operation, {
    bool preserveSignedOut = false,
  }) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await operation();
      if (preserveSignedOut && user == null) {
        status = AuthStatus.unauthenticated;
        notifyListeners();
      } else {
        _applyUser(user);
      }
    } on AuthException catch (error) {
      status = AuthStatus.unauthenticated;
      errorMessage = error.message;
      notifyListeners();
    } on clerk.ClerkError catch (error) {
      status = AuthStatus.unauthenticated;
      final message = error.toString();
      final lower = message.toLowerCase();
      errorMessage = lower.contains('too many') || lower.contains('rate limit')
          ? 'Clerk temporarily limited registration attempts. Wait a few minutes, then try once.'
          : message;
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.hasSupabaseConfiguration) {
    if (config.environment == AppEnvironment.testing) {
      return const _TestFallbackAuthRepository();
    }
    throw StateError(
      'No authentication repository was configured for this build.',
    );
  }
  return AuthRepositoryImpl(AuthService(Supabase.instance.client));
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider));
});
