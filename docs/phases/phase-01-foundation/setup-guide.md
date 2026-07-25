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

At validation time, Flutter 3.44.7, Dart 3.12.2, ADB 37.0.0, `uv 0.11.29`, and Python 3.14.6 were available. Add these installed tool locations when they are not already in the shell profile:

```bash
export PATH=/home/dhruv/development/flutter/bin:/home/dhruv/Android/Sdk/platform-tools:$PATH
export ANDROID_HOME=/home/dhruv/Android/Sdk
export ANDROID_SDK_ROOT=/home/dhruv/Android/Sdk
```

`flutter doctor -v` currently reports missing Android command-line tools and unknown aggregate license status. Resolve those before relying on APK/device validation.

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

## Mobile Dependencies and Quality Checks

```bash
cd /home/dhruv/fitvision-ai/apps/mobile
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Run on an Android Emulator

Start the backend first, then from the mobile directory:

```bash
cd /home/dhruv/fitvision-ai/apps/mobile
flutter run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

`10.0.2.2` maps Android Emulator traffic to the host loopback interface.

## Run on a Physical Android Device

```bash
cd /home/dhruv/fitvision-ai
adb reverse tcp:8000 tcp:8000
cd apps/mobile
flutter run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## Development Networking Notes

- Android Emulator: compile with `API_BASE_URL=http://10.0.2.2:8000` because `10.0.2.2` maps to the host loopback interface.
- Physical Android device: run `adb reverse tcp:8000 tcp:8000`, then compile with `API_BASE_URL=http://127.0.0.1:8000`.
- Never hardcode a personal LAN address.
- Debug-only Android configuration allows local cleartext HTTP. Production must use HTTPS and is rejected by mobile configuration if an HTTP URL is supplied.

## Debug APK

After `flutter doctor -v` reports a usable Android toolchain:

```bash
cd /home/dhruv/fitvision-ai/apps/mobile
flutter build apk --debug --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:8000
```
