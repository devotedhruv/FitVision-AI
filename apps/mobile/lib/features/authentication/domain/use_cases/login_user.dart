import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';

class LoginUser {
  const LoginUser(this.repository);
  final AuthRepository repository;

  Future<AuthUser> call(String email, String password) {
    if (!email.contains('@')) {
      throw const FormatException('Enter a valid email address.');
    }
    if (password.isEmpty) {
      throw const FormatException('Password is required.');
    }
    return repository.login(email: email.trim(), password: password);
  }
}
