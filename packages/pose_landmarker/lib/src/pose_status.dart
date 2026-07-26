enum PoseStatus {
  initializing,
  ready,
  detecting,
  poseDetected,
  noPose,
  partialPose,
  poorVisibility,
  paused,
  permissionDenied,
  modelError,
  cameraError,
  disposed;

  static PoseStatus fromWire(String? value) => values.firstWhere(
    (status) => status.name == value,
    orElse: () => PoseStatus.cameraError,
  );
}

enum CameraLensDirection {
  front,
  back;

  static CameraLensDirection fromWire(String? value) =>
      value == 'back' ? back : front;
}
