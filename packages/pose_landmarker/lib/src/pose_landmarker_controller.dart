import 'dart:async';

import 'package:flutter/services.dart';

import 'pose_exception.dart';
import 'pose_result.dart';

class PoseLandmarkerController {
  PoseLandmarkerController._();

  static const _commands = MethodChannel('fitvision/pose_landmarker/commands');
  static const _events = EventChannel('fitvision/pose_landmarker/events');
  static final instance = PoseLandmarkerController._();

  Stream<PoseResult>? _results;

  Stream<PoseResult> get results => _results ??= _events
      .receiveBroadcastStream()
      .map(
        (event) => PoseResult.fromMap(
          Map<Object?, Object?>.from(event! as Map<Object?, Object?>),
        ),
      )
      .handleError((Object error) {
        if (error is PlatformException) {
          throw PoseException(error.code, error.message ?? 'Native pose error');
        }
        throw error;
      });

  Future<void> pause() => _invoke('pause');
  Future<void> resume() => _invoke('resume');
  Future<void> switchCamera() => _invoke('switchCamera');
  Future<void> dispose() => _invoke('dispose');

  Future<void> _invoke(String method) async {
    try {
      await _commands.invokeMethod<void>(method);
    } on PlatformException catch (error) {
      throw PoseException(error.code, error.message ?? 'Native pose error');
    }
  }
}
