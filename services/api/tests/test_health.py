"""Public health contract tests."""

import pytest
from httpx import AsyncClient


@pytest.mark.anyio
async def test_health_returns_expected_response(client: AsyncClient) -> None:
    response = await client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "service": "fitvision-api",
        "version": "0.1.0",
        "environment": "testing",
    }


@pytest.mark.anyio
async def test_health_schema_has_only_public_fields(client: AsyncClient) -> None:
    payload = (await client.get("/api/v1/health")).json()
    assert set(payload) == {"status", "service", "version", "environment"}
    assert all(isinstance(payload[key], str) for key in payload)
