enum RunningStatus {
  idle,
  preparing,
  acquiringGps,
  ready,
  starting,
  running,
  paused,
  finishing,
  completed,
  failed,
}

enum GpsQuality { searching, weak, acceptable, good, unavailable }

enum LocationPermissionState {
  notRequested,
  foregroundGrantedApproximate,
  foregroundGrantedPrecise,
  denied,
  permanentlyDenied,
  serviceDisabled,
  backgroundRestricted,
  notificationDenied,
}
