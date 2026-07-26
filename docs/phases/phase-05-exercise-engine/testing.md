# Testing

Tests construct normalized landmarks at realistic 100 ms intervals and do not
need Flutter, MediaPipe, a camera or an emulator. They cover safe angles,
smoothing/reset, missing confidence, state stability, complete/partial cycles,
holds, pause/resume, side selection and alignment feedback.

```bash
dart test packages/exercise_engine
cd apps/mobile
flutter test
```

New analyzers should include full cycles, partial cycles, long holds, threshold
noise, low confidence, tracking loss and pause/resume cases.
