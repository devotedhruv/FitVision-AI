# Phase 7 — GPS running

Phase 7 adds an explicit, user-started outdoor run flow. Accepted GPS samples are filtered and written to the existing Drift database; local state drives the live screen, result and history. A native Android location foreground service keeps sampling while the activity is backgrounded or the screen is off under normal supported conditions.

The app never collects location before Start Run or after Finish. Completed runs synchronize through the Phase 6 queue using stable client UUIDs.

## Google Maps configuration

The route view uses `google_maps_flutter`; Android location sampling uses the
Google Play services fused high-accuracy provider. Enable Maps SDK for Android
and provide `MAPS_API_KEY` through `apps/mobile/android/local.properties` or the
build environment. Never commit the key. Restrict it to the Android package and
the release/debug signing certificate fingerprints used for the relevant
builds.

Only points accepted by the deterministic GPS filter appear on the map. A
zero-distance segment anchor identifies the first fix and every post-resume
fix, so the map starts a new polyline rather than connecting movement performed
while paused.
