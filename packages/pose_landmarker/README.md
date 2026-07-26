# FitVision Pose Landmarker

Internal Android-only Flutter plugin providing a CameraX `PlatformView` and
MediaPipe Pose Landmarker live-stream events. It sends structured landmarks and
timing/status metadata to Dart; it never sends camera frames across Flutter
channels or to a backend.

See `docs/phases/phase-04-camera-pose-foundation/` in the repository root for
architecture, lifecycle, contract, model provenance and validation evidence.
