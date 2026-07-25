# Phase 3 Validation Report

Pre-change baseline:

- Backend Ruff: passed.
- Backend tests: 5 passed.
- Flutter formatting: 50 files unchanged.
- Flutter analysis: no issues.
- Flutter tests: 19 passed.

Final results:

- Backend Ruff format/check: passed, 61 files.
- Backend Pytest: 27 passed, 1 integration guard skipped.
- Application import: `FitVision AI API 0.3.0`.
- Alembic: `20260725_0002` is the single head; history contains schema then seed.
- Alembic `check` and upgrade execution: not run because neither an isolated
  `TEST_DATABASE_URL` nor an authorized database target was configured.
- Uvicorn: startup and shutdown succeeded. Direct loopback `curl` was blocked by
  the execution sandbox's socket isolation; equivalent ASGI health, 401, route,
  and error-envelope tests passed.
- Flutter formatter/analyzer: passed with no issues.
- Flutter tests: 27 passed.
- Android debug APK: Gradle remained in `assembleDebug` for 374.4 seconds and
  was stopped; no APK success is claimed. It emitted a warning that Kotlin
  2.2.10 should later be upgraded to at least 2.2.20.
- Docker: `fitvision-api:phase3` built successfully with Docker 29.6.2.

PostgreSQL integration migrations were not executed because no safely isolated
database was supplied. Remote Supabase migrations were never attempted.

The first Flutter baseline invocation was denied write access to the SDK cache
by the workspace sandbox; the exact checks passed when rerun with permission to
use the installed SDK. This was environmental, not a project failure.

No real Supabase credentials were present, so real registration, confirmation,
token refresh, and database-backed endpoint flows remain environment validation
items. Unit/API tests use fakes and local signing keys and never contact
Supabase.

## Live environment closure validation — 2026-07-25

The project owner subsequently supplied an authorized Supabase development
project and a physical Android device. The previously deferred environment
checks were repeated with the following results:

- The live Supabase database is at Alembic revision `20260725_0002 (head)`.
  `alembic check` reports no new upgrade operations.
- All six application tables have PostgreSQL row-level security enabled.
  The expected 21 ownership and exercise-catalogue policies are present.
- A disposable local PostgreSQL 17 database accepted both Alembic migrations
  from an empty state, including the exercise seed revision.
- Backend format and lint checks passed. The full backend suite passed with
  `29 passed` when supplied an explicitly isolated test target.
- Flutter analysis passed with no issues and all 27 Flutter tests passed.
- The configured Android debug APK built successfully and was installed on the
  physical Android 12 device.
- A real email-authenticated Supabase session successfully loaded the Profile
  and Exercises screens on the connected Android 12 device through FastAPI.
- The live profile response returned the authenticated user's profile, and the
  exercise catalogue returned the seeded exercise definitions.
- A real Supabase refresh-token exchange issued a new ES256 access token. The
  FastAPI `/api/v1/auth/session` endpoint accepted that refreshed token and
  returned the expected authenticated email, role, and expiry without exposing
  either token.
- Real logout cleared the mobile session and routed the application back to
  the Sign in screen.
- The user then signed in again on-device without exposing credentials. The
  application restored the authenticated route, reloaded all five seeded
  exercises, and reloaded the same user-scoped profile successfully.

The Android device used `adb reverse tcp:8000 tcp:8000`; therefore these live
API checks require the development backend and USB reverse tunnel. This is a
development topology constraint, not a standalone production deployment.

With the live closure checks above, the Phase 3 authentication, backend,
database, migration, RLS, integration, refresh, logout, and physical-device
acceptance scope is complete.
