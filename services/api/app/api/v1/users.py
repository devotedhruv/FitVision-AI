"""Current-user profile endpoints."""

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import get_current_user
from app.db.session import get_db_session
from app.schemas.auth import CurrentUserClaims
from app.schemas.profile import ProfileResponse, ProfileUpdate
from app.services.profile_service import ProfileService

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me", response_model=ProfileResponse)
async def get_me(
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await ProfileService(session).get_or_create(user)


@router.patch("/me", response_model=ProfileResponse)
async def update_me(
    data: ProfileUpdate,
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await ProfileService(session).update(user, data)


@router.delete("/me/data", status_code=status.HTTP_204_NO_CONTENT)
async def delete_my_data(
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
) -> None:
    """Idempotently delete API-owned history; auth identity deletion is separate."""
    await ProfileService(session).delete_owned_data(user)
