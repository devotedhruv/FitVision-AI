# Local database

Drift schema version: **1**. This is the first structured SQLite database in
the app, so no prior local tables require migration.

- `workout_sessions`: immutable local UUID, optional remote UUID, owner,
  lifecycle/timer segments, aggregates, summary, record version and sync state.
- `rep_events`: UUID, workout foreign key with cascade, unique sequence,
  completed/incomplete type, angles and typed feedback codes.
- `sync_queue_items`: unique entity/operation job, sanitized failure metadata,
  attempts and eligibility timestamps.

Indexes cover user/start time, workout status, workout sync state and queue
eligibility. `PRAGMA foreign_keys=ON` is applied before use. Future versions
must add explicit non-destructive upgrade steps in `database_migrations.dart`;
production has no destructive fallback.

During development, inspect jobs with:

```sql
SELECT id, entity_type, status, attempt_count, next_attempt_at
FROM sync_queue_items ORDER BY created_at;
```
