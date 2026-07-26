# Limitations

- Sync is reliable while the app runs and on launch/foreground return; no
  WorkManager background worker is added, so Android may delay delivery.
- The existing backend accepts completed atomic workouts, not mutable drafts;
  active and paused sessions remain device-local until completion.
- Server-to-device history refresh/merge is not required for the local-first
  history path and is not implemented yet.
- Recovery resumes session totals and timer, but analyzer motion state cannot be
  reconstructed because raw pose frames are intentionally not stored.
- Device-local workout rows are not encrypted beyond Android application
  sandbox storage. Access tokens remain in Supabase's existing auth storage and
  never enter workout or queue rows.
- Explicit discard/delete UX is deferred; unfinished workouts are preserved.
