import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/models/running_status.dart';

class RawLocation {
  const RawLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    required this.accuracy,
    this.verticalAccuracy,
    this.speed,
    this.speedAccuracy,
    this.bearing,
    required this.timestamp,
    this.elapsedRealtimeMs,
  });
  final double latitude, longitude, accuracy;
  final double? altitude, verticalAccuracy, speed, speedAccuracy, bearing;
  final DateTime timestamp;
  final int? elapsedRealtimeMs;
}

abstract interface class LocationService {
  Stream<RawLocation> get locations;
  Future<LocationPermissionState> permission();
  Future<LocationPermissionState> requestPermission();
  Future<bool> get enabled;
  Future<void> openSettings();
}

class PlatformLocationService implements LocationService {
  static const _methods = MethodChannel('com.fitvisionai/running/methods'),
      _events = EventChannel('com.fitvisionai/running/locations');
  @override
  Stream<RawLocation> get locations =>
      _events.receiveBroadcastStream().map((value) {
        final m = Map<Object?, Object?>.from(value as Map);
        double? d(String k) => m[k] == null ? null : (m[k] as num).toDouble();
        return RawLocation(
          latitude: d('latitude')!,
          longitude: d('longitude')!,
          altitude: d('altitude'),
          accuracy: d('accuracy')!,
          verticalAccuracy: d('verticalAccuracy'),
          speed: d('speed'),
          speedAccuracy: d('speedAccuracy'),
          bearing: d('bearing'),
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            (m['timestamp'] as num).toInt(),
            isUtc: true,
          ),
          elapsedRealtimeMs: (m['elapsedRealtimeMs'] as num?)?.toInt(),
        );
      });
  @override
  Future<bool> get enabled async =>
      (await _methods.invokeMethod<bool>('isLocationEnabled')) ?? false;
  @override
  Future<LocationPermissionState> permission() async {
    if (!await enabled) return LocationPermissionState.serviceDisabled;
    final p = await Permission.locationWhenInUse.status;
    if (p.isPermanentlyDenied) return LocationPermissionState.permanentlyDenied;
    if (!p.isGranted) {
      return p.isDenied
          ? LocationPermissionState.denied
          : LocationPermissionState.notRequested;
    }
    return (await _methods.invokeMethod<bool>('isPrecise') ?? false)
        ? LocationPermissionState.foregroundGrantedPrecise
        : LocationPermissionState.foregroundGrantedApproximate;
  }

  @override
  Future<LocationPermissionState> requestPermission() async {
    await Permission.locationWhenInUse.request();
    return permission();
  }

  @override
  Future<void> openSettings() => openAppSettings();
}
