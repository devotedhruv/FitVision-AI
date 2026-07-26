"""Explicit FastAPI dependencies for authentication, database, and pagination."""

from dataclasses import dataclass

from fastapi import Depends, Query, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import AuthenticationError
from app.core.security import ClerkJWTVerifier, SupabaseJWTVerifier
from app.db.session import get_db_session
from app.schemas.auth import CurrentUserClaims

bearer_scheme = HTTPBearer(auto_error=False)


@dataclass(frozen=True)
class Pagination:
    limit: int
    offset: int


def get_pagination(
    limit: int = Query(default=20, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
) -> Pagination:
    return Pagination(limit=limit, offset=offset)


def get_jwt_verifier(request: Request) -> ClerkJWTVerifier | SupabaseJWTVerifier:
    verifier = getattr(request.app.state, "jwt_verifier", None)
    if verifier is None:
        settings = request.app.state.settings
        verifier = (
            ClerkJWTVerifier(settings)
            if settings.AUTH_PROVIDER == "clerk"
            else SupabaseJWTVerifier(settings)
        )
        request.app.state.jwt_verifier = verifier
    return verifier


async def get_current_user(
    request: Request,
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
) -> CurrentUserClaims:
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise AuthenticationError()
    verifier = get_jwt_verifier(request)
    return await verifier.verify(credentials.credentials)


DatabaseSession = Depends(get_db_session)
CurrentUser = Depends(get_current_user)


async def current_user_dependency(
    user: CurrentUserClaims = Depends(get_current_user),
) -> CurrentUserClaims:
    return user


async def database_session_dependency(
    session: AsyncSession = Depends(get_db_session),
) -> AsyncSession:
    return session
