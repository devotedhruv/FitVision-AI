# Phase 3 Setup Guide

Copy `.env.example` to ignored `services/api/.env` and replace placeholders.
Backend requirements are `DATABASE_URL`, `SUPABASE_URL`,
`SUPABASE_PUBLISHABLE_KEY`, and derived or explicit JWT issuer/JWKS values.

```bash
cd services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv sync --all-groups
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Android emulator:

```bash
cd apps/mobile
flutter run -d emulator-5554 --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=SUPABASE_URL=https://PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=PUBLIC_KEY
```

Physical Android device: first run `adb reverse tcp:8000 tcp:8000`, then use
`API_BASE_URL=http://127.0.0.1:8000`. Do not put backend database values in
`--dart-define`.

Supabase must use asymmetric JWT signing, have email authentication enabled,
and include the Android deep-link/redirect configuration appropriate to the
final package before production release.
