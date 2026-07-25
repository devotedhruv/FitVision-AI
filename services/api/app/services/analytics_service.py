"""Analytics business formatting."""

from datetime import datetime
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.analytics_repository import AnalyticsRepository
from app.schemas.analytics import AnalyticsSummary


class AnalyticsService:
    def __init__(self, session: AsyncSession):
        self.repository = AnalyticsRepository(session)

    async def summary(
        self, user_id: UUID, start: datetime | None, end: datetime | None
    ) -> AnalyticsSummary:
        workout, run = await self.repository.summary(user_id, start, end)
        return AnalyticsSummary(
            total_workout_sessions=workout[0],
            total_reps=workout[1],
            valid_reps=workout[2],
            invalid_reps=workout[3],
            average_form_score=round(float(workout[4]), 2) if workout[4] is not None else None,
            total_running_sessions=run[0],
            total_running_distance=float(run[1]),
            total_running_duration=run[2],
        )
