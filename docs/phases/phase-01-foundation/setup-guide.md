# Phase 1 Setup Guide

All repository-level commands begin from `/home/dhruv/fitvision-ai` unless a section explicitly changes directory.

## Prerequisites

```bash
cd /home/dhruv/fitvision-ai
flutter --version
dart --version
uv --version
python3 --version
```

At validation time, `uv 0.11.29` and Python `3.14.6` were available. Flutter, Dart, ADB, and the Android toolchain were unavailable. Do not run the mobile commands below until a stable Flutter SDK and Android SDK are installed outside this repository by the developer/system administrator.

## Backend Dependencies

The project uses a local ignored environment. A writable cache path is shown because the current managed environment does not allow writing to the default user cache.

```bash
cd /home/dhruv/fitvision-ai/services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv sync --all-groups
```

On a normal workstation where the user cache is writable, `uv sync --all-groups` is sufficient.

## Run the Backend

```bash
cd /home/dhruv/fitvision-ai/services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Verify from another terminal:

```bash
curl http://127.0.0.1:8000/api/v1/health
```

## Backend Quality Checks

```bash
cd /home/dhruv/fitvision-ai/services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run ruff check .
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run pytest
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run python -c "from app.main import app; print(app.title, app.version)"
```

## Mobile Initialization Blocker

`apps/mobile/pubspec.yaml` does not exist because `flutter create` could not run. Once a stable Flutter SDK is available, the first command from the repository root is:

```bash
cd /home/dhruv/fitvision-ai
flutter create --project-name fitvision_ai --org com.fitvisionai --platforms android apps/mobile
```

After generation, the Phase 1 mobile source architecture and pinned dependencies must be implemented before `flutter pub get`, `flutter analyze`, `flutter test`, or `flutter run` are valid repository instructions. They are intentionally not presented here as currently runnable commands.

## Planned Development Networking After Mobile Completion

- Android Emulator: compile with `API_BASE_URL=http://10.0.2.2:8000` because `10.0.2.2` maps to the host loopback interface.
- Physical Android device: run `adb reverse tcp:8000 tcp:8000`, then compile with `API_BASE_URL=http://127.0.0.1:8000`.
- Never hardcode a personal LAN address.
- Debug-only Android configuration may allow local cleartext HTTP. Production must use HTTPS.

