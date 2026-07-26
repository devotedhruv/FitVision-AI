# Phase 5 — Exercise Engine

Phase 5 adds deterministic on-device analysis for squats, biceps curls and
push-ups. `packages/exercise_engine` is pure Dart: it receives normalized pose
landmarks and returns immutable states, rep events, form flags and typed
feedback. Flutter owns MediaPipe adaptation, UI text, audio and haptics. Raw
frames and landmarks are not persisted or uploaded.

## Data flow

```text
MediaPipe event → app adapter → visibility gate → EMA smoother
→ exercise analyzer/state machine → Riverpod session state
→ live UI + debounced effects → workout result
```

To add an exercise, define its required landmarks, typed config, full state
cycle and analyzer tests, then register the analyzer in the mobile controller.
