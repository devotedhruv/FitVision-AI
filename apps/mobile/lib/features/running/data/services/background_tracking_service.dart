import 'package:flutter/services.dart';

class BackgroundTrackingService {
  static const _channel = MethodChannel('com.fitvisionai/running/methods');
  Future<void> start(String runId) =>
      _channel.invokeMethod('start', {'runId': runId});
  Future<void> pause() => _channel.invokeMethod('pause');
  Future<void> resume() => _channel.invokeMethod('resume');
  Future<void> stop() => _channel.invokeMethod('stop');
  Future<bool> isRunning() async =>
      (await _channel.invokeMethod<bool>('isTracking')) ?? false;
  Future<void> update(String duration, String distance) => _channel
      .invokeMethod('update', {'duration': duration, 'distance': distance});
}
