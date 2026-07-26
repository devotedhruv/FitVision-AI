# Phase 4 Validation Report

## Baseline

- Backend Ruff: passed.
- Backend Pytest: 28 passed, 1 isolated-database guard skipped.
- Flutter formatter found six pre-existing unformatted files and formatted
  them; this was recorded separately from Phase 4 implementation.
- Flutter analysis: no issues.
- Flutter tests: 27 passed.

## Implementation validation

- Official model download and SHA-256: passed.
- Plugin Dart analysis: passed.
- Plugin Dart tests: 3 passed.
- Native Kotlin main compilation: passed.
- Native focused unit tests: 15 passed.
- Flutter analysis: passed.
- Flutter tests: 46 passed.
- Android debug APK with model asset: built successfully.
- Backend final regression: Ruff passed; Pytest 28 passed, 1 isolated-database
  guard skipped.

The focused native command was:

```bash
cd apps/mobile/android
JAVA_HOME=/opt/android-studio/jbr \
  ./gradlew :pose_landmarker:testDebugUnitTest
```

Coverage now includes centralized pose configuration, 33-landmark payload
indices, no-pose/partial-pose/poor-visibility status mapping, typed missing-model
failure, monotonic timestamps, busy/drop behavior, guaranteed frame closing on
success and failure, lifecycle cleanup, and duplicate plugin attachment.

## Physical device evidence — partial

- Device: vivo 1915, Android 12/API 31, arm64, USB serial
  `GUFMAEGYDMAIV4IV`.
- Configured debug APK install/update and process launch: passed.
- ADB reverse to the local FastAPI service: passed; `/api/v1/exercises`
  returned HTTP 200 to the device.
- Front CameraX preview: visually observed.
- MediaPipe model initialization and live inference: observed through a live
  skeleton result.
- Normalized landmark overlay: observed on face/shoulder landmarks.
- Partial-body/poor-visibility guidance: observed as `Low confidence` and
  `Improve lighting and keep your body visible.`
- Phase boundary: stage remained `READY` and reps remained `0`.
- During the observed camera interval, backend access logs contained catalogue
  reads and no image, video, or landmark upload request. This is a short-run
  observation, not a packet-level ten-minute proof.

## Pending evidence

First-request/denied/permanently-denied permission flows, full-body alignment,
front mirroring motion comparison, countdown, pause/resume, back navigation,
background/foreground, camera reopen, rotation, back-camera switch, explicit
end-release observation, measured FPS/latency and ten-minute stability remain
pending. The instrumented APK was installed, but the phone locked before that
run could be repeated; no numeric performance value is claimed.

Phase 4 implementation is present, but the complete physical acceptance run is
not finished. Do not label Phase 4 fully complete yet.
