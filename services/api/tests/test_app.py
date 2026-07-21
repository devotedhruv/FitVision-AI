"""Application composition tests."""

import importlib

import pytest
from httpx import AsyncClient


@pytest.mark.anyio
async def test_root_redirects_to_documentation(client: AsyncClient) -> None:
    response = await client.get("/", follow_redirects=False)
    assert response.status_code == 307
    assert response.headers["location"] == "/docs"


@pytest.mark.anyio
async def test_unknown_route_returns_not_found(client: AsyncClient) -> None:
    response = await client.get("/not-a-route")
    assert response.status_code == 404
    assert response.json() == {"detail": "Not Found"}


def test_application_import_does_not_start_server() -> None:
    module = importlib.import_module("app.main")
    assert module.app.title == "FitVision AI API"
