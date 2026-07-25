"""Lazy async SQLAlchemy engine and request-scoped session lifecycle."""

from collections.abc import AsyncIterator

from fastapi import Request
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from app.core.config import Settings


def create_engine(settings: Settings) -> AsyncEngine:
    if not settings.DATABASE_URL:
        raise RuntimeError("DATABASE_URL is required for database-backed endpoints")
    return create_async_engine(
        settings.DATABASE_URL,
        pool_pre_ping=True,
        pool_size=settings.DB_POOL_SIZE,
        max_overflow=settings.DB_MAX_OVERFLOW,
        pool_timeout=settings.DB_POOL_TIMEOUT,
        echo=settings.DB_ECHO,
    )


def get_engine(request: Request) -> AsyncEngine:
    engine = getattr(request.app.state, "db_engine", None)
    if engine is None:
        engine = create_engine(request.app.state.settings)
        request.app.state.db_engine = engine
    return engine


async def get_db_session(request: Request) -> AsyncIterator[AsyncSession]:
    factory = async_sessionmaker(get_engine(request), expire_on_commit=False)
    async with factory() as session:
        try:
            yield session
        except Exception:
            await session.rollback()
            raise


async def dispose_engine(app) -> None:
    engine = getattr(app.state, "db_engine", None)
    if engine is not None:
        await engine.dispose()
