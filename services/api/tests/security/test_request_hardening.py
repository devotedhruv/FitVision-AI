import pytest
from httpx import ASGITransport, AsyncClient

from app.core.config import Settings
from app.main import create_app


async def request(settings: Settings, headers=None):
    app = create_app(settings)
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        return await client.get("/api/v1/health", headers=headers)


@pytest.mark.anyio
async def test_request_id_is_generated_and_untrusted_value_is_replaced():
    response = await request(
        Settings(APP_ENV="testing", RATE_LIMIT_ENABLED=False),
        {"X-Request-ID": "bad value/token"},
    )
    assert response.status_code == 200
    assert response.headers["X-Request-ID"] != "bad value/token"
    assert len(response.headers["X-Request-ID"]) <= 64


@pytest.mark.anyio
async def test_valid_correlation_id_is_preserved():
    response = await request(
        Settings(APP_ENV="testing", RATE_LIMIT_ENABLED=False),
        {"X-Request-ID": "test-request-42"},
    )
    assert response.headers["X-Request-ID"] == "test-request-42"


@pytest.mark.anyio
async def test_rate_limit_returns_429_and_retry_after():
    app = create_app(
        Settings(APP_ENV="testing", RATE_LIMIT_REQUESTS=1, RATE_LIMIT_WINDOW_SECONDS=30)
    )
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        assert (await client.get("/api/v1/health")).status_code == 200
        response = await client.get("/api/v1/health")
    assert response.status_code == 429
    assert response.headers["Retry-After"] == "30"
    assert response.json()["error"]["code"] == "RATE_LIMITED"
