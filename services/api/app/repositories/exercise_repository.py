"""Read-only exercise catalogue queries."""

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.exercise import ExerciseDefinition


class ExerciseRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def list_active(self, mvp_only: bool = False) -> list[ExerciseDefinition]:
        statement = select(ExerciseDefinition).where(ExerciseDefinition.is_active.is_(True))
        if mvp_only:
            statement = statement.where(
                ExerciseDefinition.slug.in_(["squat", "biceps-curl", "push-up"])
            )
        result = await self.session.scalars(statement.order_by(ExerciseDefinition.name))
        return list(result)

    async def get_active_by_slug(self, slug: str) -> ExerciseDefinition | None:
        return await self.session.scalar(
            select(ExerciseDefinition).where(
                ExerciseDefinition.slug == slug,
                ExerciseDefinition.is_active.is_(True),
            )
        )
