# Session lifecycle

The presentation lifecycle is `idle → starting → active ⇄ paused → ending →
completed`; local persistence failure from starting or ending produces failed.
Invalid transitions are rejected.

Countdown completion creates the UUID and active SQLite row before analysis
starts. Pause closes the active UTC segment before camera pause. Resume opens a
new segment before camera resume. End serializes outstanding rep writes,
finalizes Phase 5 incomplete movement, completes the local row, then navigates.

Active duration is `accumulatedActiveDuration + max(0, nowUtc -
currentActiveSegmentStartedAt)`. Timer ticks redraw this calculation; they are
not persisted. Paused time is therefore excluded and clock rollback cannot
produce a negative segment.
