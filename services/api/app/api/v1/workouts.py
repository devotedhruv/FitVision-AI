"""Authenticated ownership-scoped workout endpoints."""

from datetime import datetime
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import Pagination, get_current_user, get_pagination
from app.core.exceptions import DomainValidationError
from app.db.session import get_db_session
from app.schemas.auth import CurrentUserClaims
from app.schemas.common import Page
from app.schemas.workout import WorkoutCreate, WorkoutResponse
from app.services.workout_service import WorkoutService

router = APIRouter(prefix="/workouts", tags=["workouts"])


@router.post("", response_model=WorkoutResponse, status_code=status.HTTP_201_CREATED)
async def create_workout(
    data: WorkoutCreate,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await WorkoutService(session).create(user, data)


@router.get("", response_model=Page[WorkoutResponse])
async def list_workouts(
    user: CurrentUserClaims = Depends(get_current_user),
    pagination: Pagination = Depends(get_pagination),
    started_after: datetime | None = Query(default=None),
    started_before: datetime | None = Query(default=None),
    exercise_slug: str | None = Query(default=None, max_length=80),
    session: AsyncSession = Depends(get_db_session),
):
    if started_after and started_before and started_before < started_after:
        raise DomainValidationError("started_before must not precede started_after")
    items, total = await WorkoutService(session).list(
        user.user_id,
        pagination.limit,
        pagination.offset,
        started_after,
        started_before,
        exercise_slug,
    )
    return Page(items=items, total=total, limit=pagination.limit, offset=pagination.offset)


@router.get("/{workout_id}", response_model=WorkoutResponse)
async def get_workout(
    workout_id: UUID,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await WorkoutService(session).get(user.user_id, workout_id)


@router.delete("/{workout_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_workout(
    workout_id: UUID,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
) -> Response:
    await WorkoutService(session).delete(user.user_id, workout_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)
