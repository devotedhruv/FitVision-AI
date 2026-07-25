"""Authenticated basic analytics summary endpoint."""

from datetime import datetime

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import get_current_user
from app.core.exceptions import DomainValidationError
from app.db.session import get_db_session
from app.schemas.analytics import AnalyticsSummary
from app.schemas.auth import CurrentUserClaims
from app.services.analytics_service import AnalyticsService

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.get("/summary", response_model=AnalyticsSummary)
async def get_summary(
    started_after: datetime | None = Query(default=None),
    started_before: datetime | None = Query(default=None),
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
) -> AnalyticsSummary:
    if started_after and started_before and started_before < started_after:
        raise DomainValidationError("started_before must not precede started_after")
    return await AnalyticsService(session).summary(user.user_id, started_after, started_before)
