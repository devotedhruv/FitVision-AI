# Testing

In-memory Drift tests cover creation, UUID persistence, active-session
uniqueness, pause/resume timing, transactional rep aggregates, duplicate rep
events, foreign-key cascade, queue eligibility, completion and recovery. Sync
tests cover backoff, retry persistence, remote-ID storage and single-flight
delivery. Existing camera, engine, auth and widget tests remain enabled.

```bash
cd apps/mobile
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test

cd ../../services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run ruff check .
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run pytest
```
