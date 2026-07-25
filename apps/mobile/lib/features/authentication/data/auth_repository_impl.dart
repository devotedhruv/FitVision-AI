import 'package:fitvision_ai/features/authentication/data/auth_service.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.service);

  final AuthService service;

  @override
  AuthUser? get currentUser => _map(service.currentUser);

  @override
  String? get currentAccessToken => service.currentAccessToken;

  @override
  Stream<AuthUser?> get authStateChanges =>
      service.authStateChanges.map((state) => _map(state.session?.user));

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await service.login(email: email, password: password);
    final user = _map(response.user);
    if (user == null) {
      throw const AuthException('Login did not return an authenticated user.');
    }
    return user;
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    final response = await service.register(email: email, password: password);
    final user = _map(response.user);
    if (user == null) {
      throw const AuthException('Registration did not create a user.');
    }
    return user;
  }

  @override
  Future<void> logout() => service.logout();

  AuthUser? _map(User? user) => user == null
      ? null
      : AuthUser(
          id: user.id,
          email: user.email,
          emailVerified: user.emailConfirmedAt != null,
        );
}
