"""Database component settings safely derive an asyncpg URL."""

from app.core.config import Settings


def test_database_components_derive_encoded_asyncpg_url():
    settings = Settings(
        APP_ENV="testing",
        DATABASE_URL=None,
        DB_HOST="pooler.example.com",
        DB_USER="postgres.project",
        DB_PASSWORD="p@ss:word",
    )
    assert settings.DATABASE_URL == (
        "postgresql+asyncpg://postgres.project:p%40ss%3Aword@pooler.example.com:5432/postgres"
    )
