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

final class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure()
    : super('Could not save the workout. Please try again.');
}

final class SessionStateFailure extends Failure {
  const SessionStateFailure([
    super.message = 'That workout action is not available.',
  ]);
}

final class AuthenticationFailure extends Failure {
  const AuthenticationFailure() : super('Sign in again to sync your workouts.');
}

final class ValidationFailure extends Failure {
  const ValidationFailure() : super('The workout data could not be validated.');
}

final class SyncConflictFailure extends Failure {
  const SyncConflictFailure()
    : super('This workout needs review before it can sync.');
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure() : super('You do not have access to this workout.');
}

final class BadRequestFailure extends Failure {
  const BadRequestFailure()
    : super('The workout data was rejected by the server.');
}

final class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure([
    super.message = 'Location permission is required.',
  ]);
}

final class LocationServiceDisabledFailure extends Failure {
  const LocationServiceDisabledFailure()
    : super('Turn on location services to begin.');
}

final class PreciseLocationRequiredFailure extends Failure {
  const PreciseLocationRequiredFailure()
    : super('Precise location is needed to track your route.');
}

final class ForegroundServiceFailure extends Failure {
  const ForegroundServiceFailure([
    super.message = 'Could not start background run tracking.',
  ]);
}

final class GpsUnavailableFailure extends Failure {
  const GpsUnavailableFailure() : super('Waiting for a GPS signal.');
}

final class PoorGpsAccuracyFailure extends Failure {
  const PoorGpsAccuracyFailure() : super('Waiting for a better GPS signal.');
}

final class InvalidRunningStateFailure extends Failure {
  const InvalidRunningStateFailure([
    super.message = 'That run action is not available.',
  ]);
}

final class MapFailure extends Failure {
  const MapFailure()
    : super('The route map is unavailable. Tracking continues.');
}

final class SyncFailure extends Failure {
  const SyncFailure([super.message = 'Sync will retry when you are online.']);
}
