# FitVision AI Mobile

Android-first Flutter client for FitVision AI. Phase 2 provides the visual
experience. Phase 3 adds Supabase registration, login, email-verification state,
logout, authenticated API requests, profile integration, and the backend
exercise catalogue without changing the sensing screens.

Phase 6 adds Drift SQLite workout/rep persistence, offline history and a
persistent idempotent sync queue. Required runtime variables remain
`APP_ENV`, `API_BASE_URL`, `SUPABASE_URL` and
`SUPABASE_PUBLISHABLE_KEY`; no private database key belongs in Flutter.

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

Regenerate typed Drift bindings after table changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

In debug database tooling, inspect `sync_queue_items` fields rather than logging
complete payloads. Manual retry is available from a failed Workout Result.

See the repository-level
[Phase 2 implementation guide](../../docs/phases/phase-02-core-mobile-experience/implementation-guide.md)
for routes, architecture, limitations, and the planned Phase 3 boundaries.
