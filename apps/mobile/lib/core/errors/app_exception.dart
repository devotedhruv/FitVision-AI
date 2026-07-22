import 'package:fitvision_ai/core/errors/failure.dart';

class AppException implements Exception {
  const AppException(this.failure, {this.cause});
  final Failure failure;
  final Object? cause;

  @override
  String toString() => 'AppException(${failure.runtimeType})';
}
