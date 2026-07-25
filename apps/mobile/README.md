# FitVision AI Mobile

Android-first Flutter client for FitVision AI. Phase 2 provides the visual
experience. Phase 3 adds Supabase registration, login, email-verification state,
logout, authenticated API requests, profile integration, and the backend
exercise catalogue without changing the sensing screens.

## Run

```bash
flutter pub get
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000 \
  --dart-define=SUPABASE_URL=https://PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=PUBLIC_KEY
```

Only public Supabase values belong in Flutter. The database URL, service-role
key, and JWT signing material must never be passed to the app.

## Verify

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

See the repository-level
[Phase 2 implementation guide](../../docs/phases/phase-02-core-mobile-experience/implementation-guide.md)
for routes, architecture, limitations, and the planned Phase 3 boundaries.
