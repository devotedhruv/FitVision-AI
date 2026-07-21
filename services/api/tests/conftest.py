"""Shared isolated application test fixtures."""

import pytest
from httpx import ASGITransport, AsyncClient

from app.core.config import Settings
from app.main import create_app


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture
def settings() -> Settings:
    return Settings(APP_ENV="testing", APP_VERSION="0.1.0", CORS_ORIGINS=[])


@pytest.fixture
async def client(settings: Settings) -> AsyncClient:
    transport = ASGITransport(app=create_app(settings))
    async with AsyncClient(transport=transport, base_url="http://testserver") as test_client:
        yield test_client
