# Migration Guide

Never run migrations until the target has been reviewed.

```bash
cd services/api
export DATABASE_URL='postgresql+asyncpg://...'
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run alembic heads
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run alembic upgrade head
```

Revision `20260725_0001` creates tables, constraints, and indexes. Revision
`20260725_0002` seeds the five exercise definitions. No extension migration is
needed because UUIDs are application-generated.

After applying Alembic to Supabase, review and execute
`migrations/supabase/001_enable_rls_and_policies.sql` in the Supabase SQL editor.
The RLS file is separate because plain PostgreSQL test databases do not contain
the `auth.uid()` function.

Use a direct Supabase connection where IPv6 is available or Supavisor session
mode for an IPv4-only persistent API. Transaction mode can conflict with
prepared statements; do not select it without disabling/configuring asyncpg
statement caching and validating the workload.

Tests require a distinct `TEST_DATABASE_URL` whose database name contains
`test`. The guard skips when absent and fails if it equals `DATABASE_URL`.
