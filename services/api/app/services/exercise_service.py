"""Exercise catalogue business operations."""

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ResourceNotFoundError
from app.repositories.exercise_repository import ExerciseRepository


class ExerciseService:
    def __init__(self, session: AsyncSession):
        self.repository = ExerciseRepository(session)

    async def list_active(self, mvp_only: bool):
        return await self.repository.list_active(mvp_only)

    async def get_active(self, slug: str):
        exercise = await self.repository.get_active_by_slug(slug)
        if exercise is None:
            raise ResourceNotFoundError("The requested exercise was not found.")
        return exercise
