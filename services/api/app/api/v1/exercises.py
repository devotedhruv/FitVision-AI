"""Authenticated read-only exercise catalogue endpoints."""

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import get_current_user
from app.db.session import get_db_session
from app.schemas.auth import CurrentUserClaims
from app.schemas.exercise import ExerciseResponse
from app.services.exercise_service import ExerciseService

router = APIRouter(prefix="/exercises", tags=["exercises"])


@router.get("", response_model=list[ExerciseResponse])
async def list_exercises(
    mvp_only: bool = False,
    _user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await ExerciseService(session).list_active(mvp_only)


@router.get("/{slug}", response_model=ExerciseResponse)
async def get_exercise(
    slug: str,
    _user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await ExerciseService(session).get_active(slug)
