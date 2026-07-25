"""Aggregated ownership-scoped analytics SQL."""

from datetime import datetime
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.running_session import RunningSession
from app.models.workout_session import WorkoutSession


class AnalyticsRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def summary(
        self, user_id: UUID, start: datetime | None, end: datetime | None
    ) -> tuple[object, object]:
        workout_filters = [WorkoutSession.user_id == user_id]
        run_filters = [RunningSession.user_id == user_id]
        if start:
            workout_filters.append(WorkoutSession.started_at >= start)
            run_filters.append(RunningSession.started_at >= start)
        if end:
            workout_filters.append(WorkoutSession.started_at <= end)
            run_filters.append(RunningSession.started_at <= end)
        workout = (
            await self.session.execute(
                select(
                    func.count(WorkoutSession.id),
                    func.coalesce(func.sum(WorkoutSession.total_reps), 0),
                    func.coalesce(func.sum(WorkoutSession.valid_reps), 0),
                    func.coalesce(func.sum(WorkoutSession.invalid_reps), 0),
                    func.avg(WorkoutSession.form_score),
                ).where(*workout_filters)
            )
        ).one()
        run = (
            await self.session.execute(
                select(
                    func.count(RunningSession.id),
                    func.coalesce(func.sum(RunningSession.distance_meters), 0.0),
                    func.coalesce(func.sum(RunningSession.duration_seconds), 0),
                ).where(*run_filters)
            )
        ).one()
        return workout, run
