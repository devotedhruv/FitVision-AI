import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';

class RegisterUser {
  const RegisterUser(this.repository);
  final AuthRepository repository;

  Future<AuthUser> call(String email, String password) {
    if (!email.contains('@')) {
      throw const FormatException('Enter a valid email address.');
    }
    if (password.length < 8) {
      throw const FormatException('Password must contain at least 8 characters.');
    }
    return repository.register(email: email.trim(), password: password);
  }
}
