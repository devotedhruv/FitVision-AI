# Model Provenance

- Model: MediaPipe Pose Landmarker Lite
- File: `pose_landmarker_lite.task`
- Variant: `float16`
- Distribution selector: `latest` at retrieval time (2026-07-25)
- Source:
  `https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_lite/float16/latest/pose_landmarker_lite.task`
- Size: 5,777,746 bytes
- SHA-256:
  `59929e1d1ee95287735ddd833b19cf4ac46d29bc7afddbbf6753c459690d574a`
- Runtime: MediaPipe Tasks Vision Android `0.10.29`
- Source/license notes: downloaded directly from Google's official MediaPipe
  model bucket for use with MediaPipe Tasks. The plugin LICENSE retains the
  generated package's BSD notice; MediaPipe source/sample references are
  Apache-2.0. Review upstream model terms before redistribution outside this
  project.

Configuration is centralized in `PoseLandmarkerHelper`: one pose,
`LIVE_STREAM`, segmentation masks disabled, and detection/presence/tracking
thresholds supplied by the Flutter PlatformView configuration (defaults 0.5).
No model file was fabricated.
