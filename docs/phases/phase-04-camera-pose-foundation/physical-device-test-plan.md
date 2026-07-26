# Physical Device Test Plan

Target device available for this repository: vivo 1915, Android 12/API 31,
arm64.

Required checks:

1. Install configured debug APK and keep FastAPI available through
   `adb reverse tcp:8000 tcp:8000`.
2. Revoke camera permission, open a pose-supported exercise and verify the
   first-request explanation/system prompt.
3. Deny once; verify retry and continued access to non-camera screens.
4. Deny permanently; verify `Open Settings`.
5. Grant; verify front preview, model ready event and 33-landmark result.
6. Check full body, partial body, no-pose and low-light guidance.
7. Compare skeleton alignment/mirroring while moving shoulders/wrists.
8. Switch to back camera while not active.
9. Run countdown, cancel, tracking-loss cancellation, pause/resume and end.
10. Background/foreground, reopen camera and rotate portrait/landscape.
11. Record processed FPS, inference latency, dropped frames and pose-frame
    percentage.
12. Run a ten-minute stability session and compare process memory before/after.
13. Confirm network logs contain no image/video/landmark upload.

Results belong in `performance-report.md` and `validation-report.md`. Emulator
results must not be substituted for this plan.

## 2026-07-26 partial execution

Passed/observed: configured APK installation, app launch, ADB reverse, API
catalogue access, front preview, on-device pose inference, visible skeleton,
partial/low-confidence guidance, and zero fabricated reps.

Pending after the phone locked: first permission request, denied and permanently
denied recovery, full-body alignment/mirroring comparison, back camera,
countdown and tracking-loss cancellation, pause/resume, back confirmation,
background/foreground, rotation, explicit end/reopen release, numeric
performance sampling, and the ten-minute stability run.
