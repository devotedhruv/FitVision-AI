"""Analytics formulas shared with the written Phase 8 specification."""

from datetime import datetime
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.analytics_repository import AnalyticsRepository
from app.schemas.analytics import AnalyticsPeriodType, AnalyticsSummary, RunningAnalytics


class AnalyticsService:
    def __init__(self, session: AsyncSession):
        self.repository = AnalyticsRepository(session)

    async def summary(
        self,
        user_id: UUID,
        start: datetime | None,
        end: datetime | None,
        period: AnalyticsPeriodType = AnalyticsPeriodType.weekly,
    ) -> AnalyticsSummary:
        workout, run = await self.repository.summary(user_id, start, end)
        distance = float(run[1])
        duration = int(run[2])
        pace = duration / (distance / 1000) if distance > 0 and duration > 0 else None
        dates = await self.repository.active_dates(user_id, start, end) if start and end else []
        return AnalyticsSummary(
            period=period,
            start_date=start.date() if start else None,
            end_date=end.date() if end else None,
            total_workout_sessions=workout[0],
            total_reps=workout[1],
            valid_reps=workout[2],
            invalid_reps=workout[3],
            average_form_score=round(float(workout[4]), 2) if workout[4] is not None else None,
            total_running_sessions=run[0],
            total_running_distance=distance,
            total_running_duration=duration,
            weighted_average_pace_seconds_per_km=pace,
            active_days=len({d.date() for d in dates}),
            running=RunningAnalytics(
                run_count=run[0],
                total_distance_meters=distance,
                total_active_duration_seconds=duration,
                weighted_average_pace_seconds_per_km=pace,
            ),
        )
