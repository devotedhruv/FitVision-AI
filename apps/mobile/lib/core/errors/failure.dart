sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure()
    : super(
        'Unable to reach the backend. Check your connection and try again.',
      );
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure()
    : super('The backend took too long to respond. Please try again.');
}

final class ServerFailure extends Failure {
  const ServerFailure()
    : super(
        'The backend could not complete the request. Please try again later.',
      );
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
    : super('Your session has expired. Please sign in again.');
}

final class ConfigurationFailure extends Failure {
  const ConfigurationFailure()
    : super('The application configuration is invalid.');
}

final class UnknownFailure extends Failure {
  const UnknownFailure()
    : super('An unexpected error occurred. Please try again.');
}
