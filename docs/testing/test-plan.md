# Phase 9 test plan

The pyramid is: pure unit tests; repository/database tests; widget tests; isolated API integration tests; controlled mobile integration tests; then physical-device checks. Mocks do not substitute for camera, MediaPipe, GPS, screen-off, thermal, or battery verification.

All automated tests use synthetic inputs, fixed timestamps and isolated storage. Production Supabase/PostgreSQL is never a test target. Release blockers include cross-user access, invalid JWT acceptance, duplicate creation, normal offline data loss, background GPS after finish, unexpected media persistence/upload, destructive migration, and hold-triggered duplicate reps.
