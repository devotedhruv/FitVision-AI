# FitVision AI Mobile

Android-first Flutter client for FitVision AI. Phase 2 provides a complete
mock-data mobile experience without camera, GPS, authentication, or backend
business integration.

## Run

```bash
flutter pub get
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

The Phase 2 screens do not require the API to be running. The API configuration
and diagnostic foundation from Phase 1 remain available in the codebase.

## Verify

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

See the repository-level
[Phase 2 implementation guide](../../docs/phases/phase-02-core-mobile-experience/implementation-guide.md)
for routes, architecture, limitations, and the planned Phase 3 boundaries.
