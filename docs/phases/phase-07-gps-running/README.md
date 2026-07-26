# Phase 7 — GPS running

Phase 7 adds an explicit, user-started outdoor run flow. Accepted GPS samples are filtered and written to the existing Drift database; local state drives the live screen, result and history. A native Android location foreground service keeps sampling while the activity is backgrounded or the screen is off under normal supported conditions.

The app never collects location before Start Run or after Finish. Completed runs synchronize through the Phase 6 queue using stable client UUIDs.
