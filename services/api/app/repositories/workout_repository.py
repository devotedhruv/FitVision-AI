"""Ownership-scoped workout persistence queries."""

from datetime import datetime
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.exercise import ExerciseDefinition
from app.models.rep_event import RepEvent
from app.models.workout_session import WorkoutSession
from app.schemas.workout import WorkoutCreate


class WorkoutRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def find_idempotent(self, user_id: UUID, client_id: UUID) -> WorkoutSession | None:
        return await self.session.scalar(
            select(WorkoutSession)
            .options(selectinload(WorkoutSession.rep_events))
            .where(
                WorkoutSession.user_id == user_id,
                WorkoutSession.client_session_id == client_id,
            )
        )

    async def create(
        self, user_id: UUID, exercise: ExerciseDefinition, data: WorkoutCreate
    ) -> WorkoutSession:
        values = data.model_dump(exclude={"exercise_slug", "rep_events"})
        workout = WorkoutSession(user_id=user_id, exercise_id=exercise.id, **values)
        workout.rep_events = [RepEvent(**item.model_dump()) for item in data.rep_events]
        self.session.add(workout)
        await self.session.flush()
        return workout

    async def get_owned(self, user_id: UUID, workout_id: UUID) -> WorkoutSession | None:
        return await self.session.scalar(
            select(WorkoutSession)
            .options(selectinload(WorkoutSession.rep_events))
            .where(WorkoutSession.id == workout_id, WorkoutSession.user_id == user_id)
        )

    async def list_owned(
        self,
        user_id: UUID,
        *,
        limit: int,
        offset: int,
        start: datetime | None,
        end: datetime | None,
        exercise_slug: str | None,
    ) -> tuple[list[WorkoutSession], int]:
        filters = [WorkoutSession.user_id == user_id]
        if start:
            filters.append(WorkoutSession.started_at >= start)
        if end:
            filters.append(WorkoutSession.started_at <= end)
        statement = select(WorkoutSession).options(selectinload(WorkoutSession.rep_events))
        count_statement = select(func.count(WorkoutSession.id))
        if exercise_slug:
            statement = statement.join(WorkoutSession.exercise)
            count_statement = count_statement.join(WorkoutSession.exercise)
            filters.append(ExerciseDefinition.slug == exercise_slug)
        total = await self.session.scalar(count_statement.where(*filters))
        rows = await self.session.scalars(
            statement.where(*filters)
            .order_by(WorkoutSession.started_at.desc())
            .limit(limit)
            .offset(offset)
        )
        return list(rows), int(total or 0)

    async def delete(self, workout: WorkoutSession) -> None:
        await self.session.delete(workout)
        await self.session.flush()
