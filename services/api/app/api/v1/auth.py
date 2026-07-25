"""Safe authenticated session inspection endpoint."""

from fastapi import APIRouter, Depends

from app.api.dependencies import get_current_user
from app.schemas.auth import AuthSessionResponse, CurrentUserClaims

router = APIRouter(prefix="/auth", tags=["authentication"])


@router.get("/session", response_model=AuthSessionResponse)
async def get_session(
    user: CurrentUserClaims = Depends(get_current_user),
) -> AuthSessionResponse:
    return AuthSessionResponse.model_validate(user.model_dump())
