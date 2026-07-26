import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PoseCameraView extends StatelessWidget {
  const PoseCameraView({
    this.frontCamera = true,
    this.detectionConfidence = 0.5,
    this.presenceConfidence = 0.5,
    this.trackingConfidence = 0.5,
    super.key,
  });

  final bool frontCamera;
  final double detectionConfidence;
  final double presenceConfidence;
  final double trackingConfidence;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Text(
            'Pose camera is currently available on Android only.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return AndroidView(
      viewType: 'fitvision/pose_camera_view',
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: <String, Object>{
        'frontCamera': frontCamera,
        'detectionConfidence': detectionConfidence,
        'presenceConfidence': presenceConfidence,
        'trackingConfidence': trackingConfidence,
      },
    );
  }
}
