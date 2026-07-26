import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';

abstract interface class AdvancedAuthRepository {
  Future<AuthUser> registerWithName({
    required String fullName,
    required String email,
    required String password,
  });
  Future<AuthUser> verifyEmail(String code);
  Future<void> requestPasswordReset(String email);
  Future<AuthUser> completePasswordReset({
    required String code,
    required String newPassword,
  });
}

abstract interface class RefreshingTokenRepository {
  Future<String?> getAccessToken();
}

class ClerkAuthRepository
    implements
        AuthRepository,
        AdvancedAuthRepository,
        RefreshingTokenRepository {
  ClerkAuthRepository(this._auth) {
    _auth.addListener(_handleAuthChange);
    _tokenSubscription = _auth.sessionTokenStream.listen((token) {
      _accessToken = token.jwt;
    });
    unawaited(_refreshToken());
  }

  final ClerkAuthState _auth;
  final _changes = StreamController<AuthUser?>.broadcast();
  late final StreamSubscription<clerk.SessionToken> _tokenSubscription;
  String? _accessToken;

  @override
  AuthUser? get currentUser => _mapUser(_auth.user);

  @override
  String? get currentAccessToken => _accessToken;

  @override
  Future<String?> getAccessToken() async {
    await _refreshToken();
    return _accessToken;
  }

  @override
  Stream<AuthUser?> get authStateChanges => _changes.stream;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await _auth.attemptSignIn(
      strategy: clerk.Strategy.password,
      identifier: email.trim(),
      password: password,
    );
    await _refreshToken();
    return _requireUser();
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) => registerWithName(fullName: '', email: email, password: password);

  @override
  Future<AuthUser> registerWithName({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final names = fullName.trim().split(RegExp(r'\s+'));
    await _auth.attemptSignUp(
      strategy: clerk.Strategy.password,
      firstName: names.firstOrNull,
      lastName: names.length > 1 ? names.sublist(1).join(' ') : null,
      emailAddress: email.trim(),
      password: password,
      passwordConfirmation: password,
    );
    // Clerk requires a second progressive call to send the email code after
    // the password sign-up object has been created.
    final signUp = _auth.signUp;
    if (signUp != null && signUp.unverified(clerk.Field.emailAddress)) {
      await _auth.attemptSignUp(strategy: clerk.Strategy.emailCode);
    }
    return currentUser ??
        AuthUser(
          id: _auth.signUp?.id ?? 'verification-pending',
          email: email.trim(),
          emailVerified: false,
          fullName: fullName.trim(),
          firstName: names.firstOrNull,
        );
  }

  @override
  Future<AuthUser> verifyEmail(String code) async {
    await _auth.attemptSignUp(
      strategy: clerk.Strategy.emailCode,
      code: code.trim(),
    );
    await _refreshToken();
    return _requireUser();
  }

  @override
  Future<void> requestPasswordReset(String email) =>
      _auth.initiatePasswordReset(
        identifier: email.trim(),
        strategy: clerk.Strategy.resetPasswordEmailCode,
      );

  @override
  Future<AuthUser> completePasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _auth.attemptSignIn(
      strategy: clerk.Strategy.resetPasswordEmailCode,
      code: code.trim(),
      password: newPassword,
    );
    await _refreshToken();
    return _requireUser();
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    await _auth.signOut();
  }

  void _handleAuthChange() {
    unawaited(_refreshToken());
    _changes.add(currentUser);
  }

  Future<void> _refreshToken() async {
    if (_auth.user == null) {
      _accessToken = null;
      return;
    }
    try {
      _accessToken = (await _auth.sessionToken()).jwt;
    } catch (_) {
      _accessToken = null;
    }
  }

  AuthUser _requireUser() {
    final user = currentUser;
    if (user == null) {
      throw const FormatException('Authentication is incomplete.');
    }
    return user;
  }

  AuthUser? _mapUser(clerk.User? user) {
    if (user == null) return null;
    final primaryEmail = user.email;
    final verified =
        user.emailAddresses
            ?.where((item) => item.emailAddress == primaryEmail)
            .firstOrNull
            ?.isVerified ??
        false;
    return AuthUser(
      id: user.id,
      email: primaryEmail,
      emailVerified: verified,
      fullName: user.name,
      firstName: user.firstName,
      username: user.username,
      avatarUrl: user.imageUrl ?? user.profileImageUrl,
    );
  }

  void dispose() {
    _auth.removeListener(_handleAuthChange);
    unawaited(_tokenSubscription.cancel());
    unawaited(_changes.close());
  }
}
