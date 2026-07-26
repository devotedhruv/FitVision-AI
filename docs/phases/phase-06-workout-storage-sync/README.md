# Phase 6 — Workout Storage and Sync

Phase 6 makes the mobile SQLite database the immediate source of truth for
workouts. Sessions start, pause, resume, record reps and finish without waiting
for a network request. Completed sessions are synchronized to the authenticated
FastAPI API through a persistent queue.

```text
Phase 5 RepResult → transactional Drift write → reactive local UI
                                      ↓
                              persistent sync queue
                                      ↓
                      authenticated idempotent FastAPI create
```

Only calculated session and rep results are stored. Camera images, video, pose
frames, access tokens and precise landmark coordinates are never persisted.
