"""Authenticated basic analytics summary endpoint."""

from datetime import datetime, timedelta
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import get_current_user
from app.core.exceptions import DomainValidationError
from app.db.session import get_db_session
from app.schemas.analytics import AnalyticsPeriodType, AnalyticsSummary
from app.schemas.auth import CurrentUserClaims
from app.services.analytics_service import AnalyticsService

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.get("/summary", response_model=AnalyticsSummary)
async def get_summary(
    period: AnalyticsPeriodType = Query(default=AnalyticsPeriodType.weekly),
    timezone_name: str = Query(default="UTC", alias="timezone", max_length=100),
    started_after: datetime | None = Query(default=None),
    started_before: datetime | None = Query(default=None),
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
) -> AnalyticsSummary:
    if started_after and started_before and started_before < started_after:
        raise DomainValidationError("started_before must not precede started_after")
    try:
        ZoneInfo(timezone_name)
    except ZoneInfoNotFoundError as error:
        raise DomainValidationError("Unsupported timezone") from error
    if started_after and started_before and started_before - started_after > timedelta(days=366):
        raise DomainValidationError("Analytics range cannot exceed 366 days")
    return await AnalyticsService(session).summary(
        user.user_id, started_after, started_before, period
    )


@router.get("/running", response_model=AnalyticsSummary)
async def get_running(
    period: AnalyticsPeriodType = Query(default=AnalyticsPeriodType.weekly),
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await AnalyticsService(session).summary(user.user_id, None, None, period)


@router.get("/exercises", response_model=AnalyticsSummary)
async def get_exercises(
    period: AnalyticsPeriodType = Query(default=AnalyticsPeriodType.weekly),
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await AnalyticsService(session).summary(user.user_id, None, None, period)


@router.get("/insights", response_model=AnalyticsSummary)
async def get_insights(
    period: AnalyticsPeriodType = Query(default=AnalyticsPeriodType.weekly),
    user: CurrentUserClaims = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    return await AnalyticsService(session).summary(user.user_id, None, None, period)
