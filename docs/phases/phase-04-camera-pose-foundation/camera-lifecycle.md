# Camera Lifecycle

1. The camera guide explains placement/privacy without requesting permission.
2. `Enable camera` requests `CAMERA`.
3. After grant, the PlatformView creates the model and binds CameraX preview
   and analysis to the activity lifecycle.
4. Backgrounding is handled by CameraX lifecycle binding.
5. Pause clears the analyzer and unbinds use cases; the Dart timer also stops.
6. Resume rebinds preview/analysis and requires tracking readiness before the
   session resumes.
7. Camera switch is disabled during countdown/active timing, then unbinds and
   rebinds with the other selector.
8. End/back confirmation cancels timers, disposes the event subscription,
   unbinds CameraX, closes MediaPipe and shuts down the analysis executor.

The analyzer uses keep-only-latest backpressure plus an atomic busy guard, so
there is no unbounded frame queue. Each `ImageProxy` closes in `finally`.
Missing activity lifecycle, camera hardware, selected lens or model produces a
typed status rather than a native crash.
