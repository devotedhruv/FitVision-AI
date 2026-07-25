import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';

class LogoutUser {
  const LogoutUser(this.repository);
  final AuthRepository repository;

  Future<void> call() => repository.logout();
}
