# Offline-first flow

Write flow: UI → validate lifecycle → SQLite transaction → local UI/history →
queue → opportunistic sync. Network failure never rolls back or deletes local
data.

Read flow: UI → user-scoped Drift query/stream. Remote identifiers and sync
state are written back into the same local row, so the UI never renders a
separate remote duplicate.

Logout preserves local rows, including unsynced data. Queries always filter by
the current authenticated user ID, preventing one account from seeing another
account's device-local history. Upload is deferred until a valid access token
exists.
