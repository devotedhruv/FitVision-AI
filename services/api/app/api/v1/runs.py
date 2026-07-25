"""Authenticated ownership-scoped running session endpoints."""

from datetime import datetime
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import Pagination, get_current_user, get_pagination
from app.core.exceptions import DomainValidationError
from app.db.session import get_db_session
from app.schemas.auth import CurrentUserClaims
from app.schemas.common import Page
from app.schemas.run import RunCreate, RunResponse
from app.services.run_service import RunService

router = APIRouter(prefix="/runs", tags=["runs"])


@router.post("", response_model=RunResponse, status_code=status.HTTP_201_CREATED)
async def create_run(
    data: RunCreate,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await RunService(session).create(user, data)


@router.get("", response_model=Page[RunResponse])
async def list_runs(
    user: CurrentUserClaims = Depends(get_current_user),
    pagination: Pagination = Depends(get_pagination),
    started_after: datetime | None = Query(default=None),
    started_before: datetime | None = Query(default=None),
    session: AsyncSession = Depends(get_db_session),
):
    if started_after and started_before and started_before < started_after:
        raise DomainValidationError("started_before must not precede started_after")
    items, total = await RunService(session).list(
        user.user_id,
        pagination.limit,
        pagination.offset,
        started_after,
        started_before,
    )
    return Page(items=items, total=total, limit=pagination.limit, offset=pagination.offset)


@router.get("/{run_id}", response_model=RunResponse)
async def get_run(
    run_id: UUID,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await RunService(session).get(user.user_id, run_id)


@router.delete("/{run_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_run(
    run_id: UUID,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
) -> Response:
    await RunService(session).delete(user.user_id, run_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)
