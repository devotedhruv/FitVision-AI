# Architecture

```text
Android LocationManager foreground service → typed platform event → GpsFilter
→ Haversine/pace metrics → Drift transaction → Riverpod UI → Phase 6 queue
```

Domain models contain no Flutter, Drift, HTTP or map types. `LocationService` and `BackgroundTrackingService` isolate Android. `MapService` and `RouteMap` consume accepted domain points only.
