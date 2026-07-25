import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this.client);

  final SupabaseClient client;

  User? get currentUser => client.auth.currentUser;
  String? get currentAccessToken => client.auth.currentSession?.accessToken;
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) => client.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> register({
    required String email,
    required String password,
  }) => client.auth.signUp(email: email, password: password);

  Future<void> logout() => client.auth.signOut();
}
