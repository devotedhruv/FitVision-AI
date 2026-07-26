# Architecture

The engine package has no Flutter or MediaPipe dependency. Its model boundary
contains timestamps, normalized coordinates, confidence, image metadata and
camera metadata. The adapter at
`apps/mobile/lib/features/exercise/data/mediapipe_pose_frame_adapter.dart`
applies residual rotation and preview mirroring while preserving MediaPipe's
anatomical left/right landmark IDs.

Analyzers share geometry, visibility filtering, smoothing, feedback throttling
and `RepStateMachine`. A rejected frame cannot transition the machine. Flutter
processes at most one result every 66 ms; CameraX continues to use
keep-only-latest backpressure, so frames cannot queue without bound.

The existing backend workout contract can represent complete rep events. Mobile
workout persistence is not yet implemented, so Phase 5 keeps `ExerciseResult`
independent and leaves a clean future mapper boundary.
