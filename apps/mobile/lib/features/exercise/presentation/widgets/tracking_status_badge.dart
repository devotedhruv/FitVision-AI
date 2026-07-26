import 'package:flutter/material.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

class TrackingStatusBadge extends StatelessWidget {
  const TrackingStatusBadge({required this.status, super.key});
  final PoseStatus? status;

  @override
  Widget build(BuildContext context) {
    final ready = status == PoseStatus.poseDetected;
    return Semantics(
      liveRegion: true,
      label: ready ? 'Full body detected' : 'Tracking not ready',
      child: Chip(
        avatar: Icon(
          ready ? Icons.accessibility_new : Icons.visibility_off_outlined,
          size: 18,
        ),
        label: Text(ready ? 'Full body detected' : _label(status)),
        backgroundColor: ready
            ? Colors.green.withValues(alpha: 0.85)
            : Colors.orange.withValues(alpha: 0.9),
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  String _label(PoseStatus? value) => switch (value) {
    PoseStatus.partialPose => 'Partial body',
    PoseStatus.poorVisibility => 'Low confidence',
    PoseStatus.noPose => 'No body detected',
    PoseStatus.paused => 'Paused',
    _ => 'Initializing',
  };
}
