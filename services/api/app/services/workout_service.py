"""Workout validation, idempotency, ownership, and transactions."""

from datetime import datetime
from uuid import UUID

from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ResourceNotFoundError
from app.repositories.exercise_repository import ExerciseRepository
from app.repositories.profile_repository import ProfileRepository
from app.repositories.workout_repository import WorkoutRepository
from app.schemas.auth import CurrentUserClaims
from app.schemas.workout import WorkoutCreate


class WorkoutService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.workouts = WorkoutRepository(session)
        self.exercises = ExerciseRepository(session)
        self.profiles = ProfileRepository(session)

    async def create(self, user: CurrentUserClaims, data: WorkoutCreate):
        try:
            async with self.session.begin():
                existing = await self.workouts.find_idempotent(user.user_id, data.client_session_id)
                if existing:
                    return existing
                exercise = await self.exercises.get_active_by_slug(data.exercise_slug)
                if exercise is None:
                    raise ResourceNotFoundError("The requested exercise was not found.")
                display = user.email.split("@")[0] if user.email else "FitVision User"
                await self.profiles.ensure(user.user_id, display[:100])
                return await self.workouts.create(user.user_id, exercise, data)
        except IntegrityError:
            # The database uniqueness constraint closes the race between two
            # concurrent retries using the same mobile-generated UUID.
            await self.session.rollback()
            existing = await self.workouts.find_idempotent(user.user_id, data.client_session_id)
            if existing:
                return existing
            raise

    async def list(
        self,
        user_id: UUID,
        limit: int,
        offset: int,
        start: datetime | None,
        end: datetime | None,
        exercise_slug: str | None,
    ):
        return await self.workouts.list_owned(
            user_id,
            limit=limit,
            offset=offset,
            start=start,
            end=end,
            exercise_slug=exercise_slug,
        )

    async def get(self, user_id: UUID, workout_id: UUID):
        workout = await self.workouts.get_owned(user_id, workout_id)
        if workout is None:
            raise ResourceNotFoundError()
        return workout

    async def delete(self, user_id: UUID, workout_id: UUID) -> None:
        async with self.session.begin():
            workout = await self.workouts.get_owned(user_id, workout_id)
            if workout is None:
                raise ResourceNotFoundError()
            await self.workouts.delete(workout)
