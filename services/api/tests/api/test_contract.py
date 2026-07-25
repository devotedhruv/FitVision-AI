"""Route registration and authentication boundary tests without a database."""

import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("method", "path"),
    [
        ("get", "/api/v1/users/me"),
        ("get", "/api/v1/exercises"),
        ("post", "/api/v1/workouts"),
        ("get", "/api/v1/workouts"),
        ("post", "/api/v1/runs"),
        ("get", "/api/v1/runs"),
        ("get", "/api/v1/analytics/summary"),
    ],
)
async def test_user_scoped_routes_require_authentication(
    client: AsyncClient, method: str, path: str
):
    response = await client.request(method, path)
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "AUTHENTICATION_REQUIRED"


@pytest.mark.asyncio
async def test_exercise_catalogue_has_no_write_route(client: AsyncClient):
    response = await client.post("/api/v1/exercises", json={})
    assert response.status_code == 405
