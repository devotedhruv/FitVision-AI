"""Running-session validation, idempotency, ownership, and transactions."""

from datetime import datetime
from uuid import UUID

from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ResourceNotFoundError
from app.repositories.profile_repository import ProfileRepository
from app.repositories.run_repository import RunRepository
from app.schemas.auth import CurrentUserClaims
from app.schemas.run import RunCreate


class RunService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.runs = RunRepository(session)
        self.profiles = ProfileRepository(session)

    async def create(self, user: CurrentUserClaims, data: RunCreate):
        try:
            async with self.session.begin():
                existing = await self.runs.find_idempotent(user.user_id, data.client_session_id)
                if existing:
                    return existing
                display = user.email.split("@")[0] if user.email else "FitVision User"
                await self.profiles.ensure(user.user_id, display[:100])
                return await self.runs.create(user.user_id, data)
        except IntegrityError:
            await self.session.rollback()
            existing = await self.runs.find_idempotent(user.user_id, data.client_session_id)
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
    ):
        return await self.runs.list_owned(user_id, limit=limit, offset=offset, start=start, end=end)

    async def get(self, user_id: UUID, run_id: UUID):
        run = await self.runs.get_owned(user_id, run_id)
        if run is None:
            raise ResourceNotFoundError()
        return run

    async def delete(self, user_id: UUID, run_id: UUID) -> None:
        async with self.session.begin():
            run = await self.runs.get_owned(user_id, run_id)
            if run is None:
                raise ResourceNotFoundError()
            await self.runs.delete(run)
