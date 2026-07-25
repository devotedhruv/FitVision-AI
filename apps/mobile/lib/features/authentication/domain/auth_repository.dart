import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser? get currentUser;
  String? get currentAccessToken;
  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> register({required String email, required String password});
  Future<void> logout();
}
