# Native Architecture

```text
CameraX Preview + ImageAnalysis
  -> STRATEGY_KEEP_ONLY_LATEST
  -> single native analysis executor
  -> ImageProxy.toBitmap + sensor rotation
  -> MediaPipe MPImage
  -> PoseLandmarker.detectAsync (LIVE_STREAM, CPU)
  -> PoseLandmarkerResult mapper
  -> EventChannel structured map
  -> Riverpod LiveExerciseViewModel
  -> Flutter SkeletonPainter
```

`PoseCameraView` is an Android PlatformView containing `PreviewView`. It binds
`Preview` and `ImageAnalysis` to the hosting Flutter activity's lifecycle.
`FrameBusyGuard` admits only one inference submission at a time and counts
dropped busy frames. `ImageProxy` is closed in a `finally` block.

Core configuration, status classification, model-asset validation, timestamps,
close guarantees, resource lifecycle and plugin attachment state are separated
into pure Kotlin components. The production pipeline consumes these components,
and the focused native suite currently exercises 15 cases without requiring a
camera emulator.

Commands use `fitvision/pose_landmarker/commands`; results use
`fitvision/pose_landmarker/events`. Events contain no image bytes. Pigeon was
not introduced because the small command surface and a versioned, tested map
contract avoided generated-code churn; parsing is centralized in the plugin
rather than spread through application widgets.

Dependencies:

- CameraX `1.6.1`: core, camera2, lifecycle and view
- MediaPipe Tasks Vision `0.10.29`
- Kotlin `2.3.20` in the plugin build
- Android min SDK 24, compile SDK 36

CPU is the required/default delegate. No GPU delegate is enabled.
