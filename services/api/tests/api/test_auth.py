"""Authentication dependency and safe session response tests."""

from datetime import UTC, datetime, timedelta
from uuid import uuid4

import pytest
from httpx import ASGITransport, AsyncClient

from app.core.config import Settings
from app.core.exceptions import AuthenticationError
from app.main import create_app
from app.schemas.auth import CurrentUserClaims


class FakeVerifier:
    async def verify(self, token: str) -> CurrentUserClaims:
        if token != "valid-token":
            raise AuthenticationError("The access token is invalid or expired.")
        return CurrentUserClaims(
            user_id=uuid4(),
            email="athlete@example.com",
            role="authenticated",
            expires_at=datetime.now(UTC) + timedelta(minutes=5),
        )


@pytest.fixture
async def auth_client():
    app = create_app(Settings(APP_ENV="testing", CORS_ORIGINS=[]))
    app.state.jwt_verifier = FakeVerifier()
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://testserver"
    ) as client:
        yield client


@pytest.mark.asyncio
async def test_missing_bearer_token_returns_401(auth_client):
    response = await auth_client.get("/api/v1/auth/session")
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "AUTHENTICATION_REQUIRED"


@pytest.mark.asyncio
async def test_malformed_token_returns_401(auth_client):
    response = await auth_client.get(
        "/api/v1/auth/session", headers={"Authorization": "Bearer invalid"}
    )
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_safe_session_does_not_return_raw_token(auth_client):
    response = await auth_client.get(
        "/api/v1/auth/session", headers={"Authorization": "Bearer valid-token"}
    )
    assert response.status_code == 200
    assert response.json()["email"] == "athlete@example.com"
    assert "token" not in response.text
