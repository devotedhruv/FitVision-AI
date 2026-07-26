# Performance Report

Engineering instrumentation is implemented in every result:

- per-result inference latency;
- processed FPS;
- busy/dropped frame count;
- frames with a detected pose;
- session detected-frame percentage and average inference latency.

The native debug stream also writes one metrics-only `FitVisionPose` log entry
per 30 processed results containing processed FPS, inference latency, dropped
frames and status. It does not log image bytes or landmark coordinates.

Targets:

- at least 15 processed pose FPS on a supported mid-range device;
- under 150 ms end-to-end visual feedback latency;
- stable ten-minute camera session;
- no unbounded queue or visible UI freeze.

Static evidence:

- CameraX uses `STRATEGY_KEEP_ONLY_LATEST`;
- native `FrameBusyGuard` permits one in-flight inference;
- analysis runs on one background executor;
- event payloads contain structured landmarks only;
- raw frames never cross Flutter channels or network boundaries.

## Vivo 1915 run

A short physical run verified that preview and live skeleton updates remained
responsive enough for visual tracking, but the run used the APK from before the
metrics-only logger was installed. The instrumented APK was subsequently
installed; the device locked before the camera route could be reopened.

Therefore average FPS, average inference latency, dropped-frame total, memory
trend and ten-minute stability remain **not measured**. No performance target is
claimed as met. To collect the values after unlocking:

```bash
adb logcat -c
adb logcat -s FitVisionPose:D
```

Open a pose camera session, keep one person in view, run for at least ten
minutes, then compute averages from the emitted metrics samples.
