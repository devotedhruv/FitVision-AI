# FitVision AI API

Phase 1 FastAPI foundation. It exposes only a documentation redirect and the unauthenticated `GET /api/v1/health` endpoint. Authentication, databases, workout APIs, and analytics are intentionally deferred.

## Local development

From `services/api/`:

```bash
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv sync --all-groups
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run ruff check .
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run pytest
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Settings can be supplied through environment variables or a local `.env`, which is ignored by Git. Use the root `.env.example` as documentation; never commit real credentials.

