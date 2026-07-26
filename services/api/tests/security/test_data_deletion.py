import pytest
from httpx import AsyncClient


@pytest.mark.anyio
async def test_history_deletion_requires_authentication(client: AsyncClient) -> None:
    response = await client.delete("/api/v1/users/me/data")
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "AUTHENTICATION_REQUIRED"


@pytest.mark.anyio
async def test_repeated_unauthenticated_deletion_never_leaks_resource_state(
    client: AsyncClient,
) -> None:
    first = await client.delete("/api/v1/users/me/data")
    second = await client.delete("/api/v1/users/me/data")
    assert first.status_code == second.status_code == 401
    assert first.json() == second.json()
