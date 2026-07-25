FROM python:3.13-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

RUN python -m venv /opt/venv \
    && pip install --no-cache-dir \
      "fastapi==0.139.2" \
      "uvicorn[standard]==0.51.0" \
      "pydantic==2.12.5" \
      "pydantic-settings==2.14.2" \
      "sqlalchemy==2.0.51" \
      "asyncpg==0.31.0" \
      "alembic==1.18.5" \
      "PyJWT[crypto]==2.13.0" \
      "httpx==0.28.1" \
      "email-validator==2.3.0"

RUN addgroup --system fitvision && adduser --system --ingroup fitvision fitvision
WORKDIR /app
COPY --chown=fitvision:fitvision alembic.ini ./
COPY --chown=fitvision:fitvision migrations ./migrations
COPY --chown=fitvision:fitvision app ./app
USER fitvision

EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/api/v1/health', timeout=2)"

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
