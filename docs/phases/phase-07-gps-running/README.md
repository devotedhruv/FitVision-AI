# Phase 7 — GPS running

Phase 7 adds an explicit, user-started outdoor run flow. Accepted GPS samples are filtered and written to the existing Drift database; local state drives the live screen, result and history. A native Android location foreground service keeps sampling while the activity is backgrounded or the screen is off under normal supported conditions.

The app never collects location before Start Run or after Finish. Completed runs synchronize through the Phase 6 queue using stable client UUIDs.

## Map configuration

The route view uses `flutter_map` with OpenStreetMap tiles. Android location
sampling continues to use the Google Play services fused high-accuracy
provider; this is independent of the map renderer. No Google Maps API key or
billing account is required. The map includes OpenStreetMap attribution. For
production traffic, use an approved tile provider or self-hosted tiles and
follow the [OpenStreetMap tile usage policy](https://operations.osmfoundation.org/policies/tiles/).

Only points accepted by the deterministic GPS filter appear on the map. A
zero-distance segment anchor identifies the first fix and every post-resume
fix, so the map starts a new polyline rather than connecting movement performed
while paused.
