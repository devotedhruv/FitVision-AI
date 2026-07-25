# FitVision AI API

Phase 3 FastAPI service with asymmetric Supabase JWT verification, asynchronous
PostgreSQL persistence, Alembic migrations, and user-scoped profile, exercise,
workout, run, and analytics APIs.

## Local development

From `services/api/`:

```bash
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv sync --all-groups
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run ruff check .
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run pytest
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Configure an ignored `.env` from the root `.env.example`. Apply Alembic only
after reviewing an explicit database target:

```bash
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run alembic upgrade head
```

The health endpoint is public. Resource endpoints require a verified Supabase
access token. Never commit credentials or expose the database URL, service-role
key, or JWT secret to Flutter.
