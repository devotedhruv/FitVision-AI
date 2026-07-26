# Synchronization

Completed sessions use the existing single-flight Phase 6 queue. The current backend contract accepts one completed session with ordered accepted points atomically, so one queue job preserves the parent/child dependency. Stable run and point UUIDs plus database uniqueness make retries idempotent. Tokens and rejected points are excluded from payloads.
