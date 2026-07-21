"""Unauthenticated service health contract."""

from typing import Literal

from fastapi import APIRouter, Request
from pydantic import BaseModel, ConfigDict

from app.core.config import Settings

router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    """Public liveness response without internal infrastructure details."""

    model_config = ConfigDict(extra="forbid")

    status: Literal["ok"]
    service: Literal["fitvision-api"]
    version: str
    environment: str


@router.get("/health", response_model=HealthResponse, summary="Service health")
async def health(request: Request) -> HealthResponse:
    settings: Settings = request.app.state.settings
    return HealthResponse(
        status="ok",
        service="fitvision-api",
        version=settings.APP_VERSION,
        environment=settings.APP_ENV,
    )
