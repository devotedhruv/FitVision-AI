import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import '../data/services/background_tracking_service.dart';
import '../data/services/location_service.dart';
import '../domain/calculations/gps_filter.dart';
import '../domain/calculations/pace_calculator.dart';
import '../domain/models/location_point.dart';
import '../domain/models/running_metrics.dart';
import '../domain/models/running_session.dart';
import '../domain/models/running_status.dart';
import '../domain/repositories/running_repository.dart';

class RunningViewModel extends ChangeNotifier {
  RunningViewModel({
    required this.repository,
    required this.auth,
    required this.location,
    required this.background,
    this.config = const RunningTrackingConfig(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now,
       _filter = GpsFilter(config);
  final RunningRepository repository;
  final AuthRepository auth;
  final LocationService location;
  final BackgroundTrackingService background;
  final RunningTrackingConfig config;
  final DateTime Function() clock;
  final GpsFilter _filter;
  static const _uuid = Uuid();
  StreamSubscription<RawLocation>? _subscription;
  Timer? _timer;
  RunningStatus status = RunningStatus.idle;
  LocationPermissionState permission = LocationPermissionState.notRequested;
  RunningMetrics metrics = const RunningMetrics();
  RunningSession? session;
  String? message;
  bool busy = false;
  int _sequence = 0;
  double _smoothed = 0;
  Future<void> prepare() async {
    status = RunningStatus.preparing;
    notifyListeners();
    permission = await location.permission();
    final user = auth.currentUser;
    if (user != null) {
      session = await repository.recover(user.id);
      if (session != null) {
        status = RunningStatus.paused;
        _sequence = session!.routePoints.length;
        _metricsFromSession();
        message = 'Paused run recovered from this device.';
        notifyListeners();
        return;
      }
    }
    status = permission == LocationPermissionState.foregroundGrantedPrecise
        ? RunningStatus.ready
        : RunningStatus.acquiringGps;
    notifyListeners();
  }

  Future<void> requestLocation() async {
    permission = await location.requestPermission();
    status = permission == LocationPermissionState.foregroundGrantedPrecise
        ? RunningStatus.ready
        : RunningStatus.acquiringGps;
    message = permission == LocationPermissionState.foregroundGrantedApproximate
        ? 'Enable precise location in system settings.'
        : null;
    notifyListeners();
  }

  Future<void> start() async {
    if (busy || status != RunningStatus.ready) return;
    final user = auth.currentUser;
    if (user == null) {
      message = 'Sign in to start a run.';
      notifyListeners();
      return;
    }
    if (!await location.enabled) {
      permission = LocationPermissionState.serviceDisabled;
      message = 'Turn on location services to begin.';
      notifyListeners();
      return;
    }
    if (await location.permission() !=
        LocationPermissionState.foregroundGrantedPrecise) {
      permission = LocationPermissionState.foregroundGrantedApproximate;
      message = 'Precise location is needed to track your route.';
      notifyListeners();
      return;
    }
    if (await Permission.notification.isDenied) {
      final n = await Permission.notification.request();
      if (!n.isGranted) {
        permission = LocationPermissionState.notificationDenied;
        message = 'Notifications are required for visible background tracking.';
        notifyListeners();
        return;
      }
    }
    busy = true;
    status = RunningStatus.starting;
    notifyListeners();
    try {
      session = await repository.start(user.id);
      await background.start(session!.localId);
      _listen();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
      status = RunningStatus.running;
      message = 'Waiting for a reliable GPS fix.';
    } catch (_) {
      status = RunningStatus.failed;
      message = 'Could not start run tracking.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void _listen() {
    _subscription ??= location.locations.listen(
      _point,
      onError: (_) {
        message = 'GPS signal is unavailable.';
        metrics = _copy(quality: GpsQuality.unavailable);
        notifyListeners();
      },
    );
  }

  Future<void> _point(RawLocation raw) async {
    final current = session;
    if (current == null) return;
    var point = LocationPoint(
      localId: _uuid.v4(),
      runningSessionLocalId: current.localId,
      sequenceNumber: _sequence++,
      latitude: raw.latitude,
      longitude: raw.longitude,
      altitude: raw.altitude,
      horizontalAccuracy: raw.accuracy,
      verticalAccuracy: raw.verticalAccuracy,
      providerSpeed: raw.speed,
      speedAccuracy: raw.speedAccuracy,
      bearing: raw.bearing,
      recordedAt: raw.timestamp,
      elapsedRealtimeMs: raw.elapsedRealtimeMs,
      status: LocationPointStatus.accepted,
    );
    final result = _filter.evaluate(
      point,
      paused: status == RunningStatus.paused,
      now: clock(),
    );
    point = LocationPoint(
      localId: point.localId,
      runningSessionLocalId: point.runningSessionLocalId,
      sequenceNumber: point.sequenceNumber,
      latitude: point.latitude,
      longitude: point.longitude,
      altitude: point.altitude,
      horizontalAccuracy: point.horizontalAccuracy,
      verticalAccuracy: point.verticalAccuracy,
      providerSpeed: point.providerSpeed,
      speedAccuracy: point.speedAccuracy,
      bearing: point.bearing,
      recordedAt: point.recordedAt,
      elapsedRealtimeMs: point.elapsedRealtimeMs,
      status: result.accepted
          ? LocationPointStatus.accepted
          : LocationPointStatus.rejected,
      rejectionReason: result.reason,
      distanceFromPreviousMeters: result.distanceMeters,
    );
    session = await repository.record(point);
    final seconds = session!.activeDurationAt(clock()).inMilliseconds / 1000;
    final double instant = result.accepted && result.distanceMeters > 0
        ? result.distanceMeters /
              (raw.timestamp
                          .difference(
                            session!.routePoints
                                    .where((p) => p.accepted)
                                    .toList()
                                    .reversed
                                    .skip(1)
                                    .firstOrNull
                                    ?.recordedAt ??
                                raw.timestamp,
                          )
                          .inMilliseconds
                          .abs() /
                      1000)
                  .clamp(.001, double.infinity)
                  .toDouble()
        : 0.0;
    _smoothed = _smoothed == 0
        ? instant
        : config.speedSmoothingAlpha * instant +
              (1 - config.speedSmoothingAlpha) * _smoothed;
    final distance = session!.distanceMeters;
    metrics = RunningMetrics(
      elapsedDuration: clock().toUtc().difference(session!.startedAt),
      activeDuration: session!.activeDurationAt(clock()),
      pausedDuration: session!.pausedDurationAt(clock()),
      totalAcceptedDistanceMeters: distance,
      currentSpeedMps: instant,
      smoothedSpeedMps: _smoothed,
      averageSpeedMps: seconds > 0 ? distance / seconds : 0,
      currentPaceSecondsPerKm: PaceCalculator.pace(
        result.distanceMeters,
        Duration(
          milliseconds: (result.distanceMeters / _smoothed * 1000).isFinite
              ? (result.distanceMeters / _smoothed * 1000).round()
              : 0,
        ),
        minimumMeters: config.minimumPaceDistanceMeters,
      ),
      averagePaceSecondsPerKm: PaceCalculator.pace(
        distance,
        session!.activeDurationAt(clock()),
        minimumMeters: config.minimumPaceDistanceMeters,
      ),
      acceptedPointCount: session!.routePoints.where((p) => p.accepted).length,
      rejectedPointCount: session!.routePoints.where((p) => !p.accepted).length,
      gpsQuality: raw.accuracy <= 10
          ? GpsQuality.good
          : raw.accuracy <= 30
          ? GpsQuality.acceptable
          : GpsQuality.weak,
    );
    message = result.accepted
        ? null
        : 'GPS point ignored: ${result.reason?.name}';
    notifyListeners();
  }

  Future<void> pause() async {
    if (busy || status != RunningStatus.running || session == null) return;
    busy = true;
    notifyListeners();
    try {
      session = await repository.pause(session!.localId);
      await background.pause();
      _filter.resetSegment();
      status = RunningStatus.paused;
    } finally {
      busy = false;
      _metricsFromSession();
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (busy || status != RunningStatus.paused || session == null) return;
    busy = true;
    notifyListeners();
    try {
      session = await repository.resume(session!.localId);
      await background.resume();
      _filter.resetSegment();
      status = RunningStatus.running;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<String?> finish() async {
    if (busy ||
        session == null ||
        (status != RunningStatus.running && status != RunningStatus.paused)) {
      return null;
    }
    busy = true;
    status = RunningStatus.finishing;
    notifyListeners();
    try {
      await _subscription?.cancel();
      _subscription = null;
      session = await repository.finish(session!.localId);
      await background.stop();
      status = RunningStatus.completed;
      _metricsFromSession();
      return session!.localId;
    } catch (_) {
      status = RunningStatus.failed;
      message = 'Run saved state could not be finalized.';
      return null;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void _tick() {
    _metricsFromSession();
    if (session != null) {
      background.update(
        _duration(metrics.activeDuration),
        (metrics.totalAcceptedDistanceMeters / 1000).toStringAsFixed(2),
      );
    }
    notifyListeners();
  }

  void _metricsFromSession() {
    final s = session;
    if (s == null) return;
    final active = s.activeDurationAt(clock()),
        paused = s.pausedDurationAt(clock());
    metrics = RunningMetrics(
      elapsedDuration: clock().toUtc().difference(s.startedAt),
      activeDuration: active,
      pausedDuration: paused,
      totalAcceptedDistanceMeters: s.distanceMeters,
      averageSpeedMps: PaceCalculator.speed(s.distanceMeters, active) ?? 0,
      averagePaceSecondsPerKm: PaceCalculator.pace(
        s.distanceMeters,
        active,
        minimumMeters: config.minimumPaceDistanceMeters,
      ),
      acceptedPointCount: s.routePoints.where((p) => p.accepted).length,
      rejectedPointCount: s.routePoints.where((p) => !p.accepted).length,
      gpsQuality: metrics.gpsQuality,
    );
  }

  RunningMetrics _copy({required GpsQuality quality}) => RunningMetrics(
    elapsedDuration: metrics.elapsedDuration,
    activeDuration: metrics.activeDuration,
    pausedDuration: metrics.pausedDuration,
    totalAcceptedDistanceMeters: metrics.totalAcceptedDistanceMeters,
    currentSpeedMps: metrics.currentSpeedMps,
    smoothedSpeedMps: metrics.smoothedSpeedMps,
    averageSpeedMps: metrics.averageSpeedMps,
    currentPaceSecondsPerKm: metrics.currentPaceSecondsPerKm,
    averagePaceSecondsPerKm: metrics.averagePaceSecondsPerKm,
    acceptedPointCount: metrics.acceptedPointCount,
    rejectedPointCount: metrics.rejectedPointCount,
    gpsQuality: quality,
  );
  static String _duration(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  Future<void> openSettings() => location.openSettings();
  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
