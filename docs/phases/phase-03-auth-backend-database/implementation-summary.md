# Phase 3 Implementation Summary

Phase 3 adds Supabase email authentication to Flutter and a user-scoped
FastAPI/PostgreSQL persistence API. Phase 2 screens and mock workout/running
experiences remain intact; sensing and live tracking remain Phase 4+ work.

Implemented components:

- Supabase registration, login, verification-state routing, token refresh
  delegation, and logout in Flutter.
- Bearer-token injection into Dio without token logging or manual refresh-token
  storage.
- Asymmetric Supabase JWT verification using cached JWKS, an algorithm allowlist,
  issuer, audience, signature, expiry, `kid`, and required-claim checks.
- Typed asynchronous SQLAlchemy models, repositories, services, and user-scoped
  profile, exercise, workout, run, and analytics endpoints.
- Alembic schema and catalogue seed revisions plus separate Supabase RLS SQL.
- Backend and Flutter unit/API tests, safe integration-test guards, and a
  non-root production Dockerfile.

No passwords are stored by FastAPI. No service-role key, JWT signing secret, or
database credential is included in Flutter.
