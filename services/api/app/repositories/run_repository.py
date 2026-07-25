"""Ownership-scoped running session persistence queries."""

from datetime import datetime
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.running_point import RunningPoint
from app.models.running_session import RunningSession
from app.schemas.run import RunCreate


class RunRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def find_idempotent(self, user_id: UUID, client_id: UUID) -> RunningSession | None:
        return await self.session.scalar(
            select(RunningSession)
            .options(selectinload(RunningSession.points))
            .where(
                RunningSession.user_id == user_id,
                RunningSession.client_session_id == client_id,
            )
        )

    async def create(self, user_id: UUID, data: RunCreate) -> RunningSession:
        run = RunningSession(user_id=user_id, **data.model_dump(exclude={"points"}))
        run.points = [RunningPoint(**item.model_dump()) for item in data.points]
        self.session.add(run)
        await self.session.flush()
        return run

    async def get_owned(self, user_id: UUID, run_id: UUID) -> RunningSession | None:
        return await self.session.scalar(
            select(RunningSession)
            .options(selectinload(RunningSession.points))
            .where(RunningSession.id == run_id, RunningSession.user_id == user_id)
        )

    async def list_owned(
        self,
        user_id: UUID,
        *,
        limit: int,
        offset: int,
        start: datetime | None,
        end: datetime | None,
    ) -> tuple[list[RunningSession], int]:
        filters = [RunningSession.user_id == user_id]
        if start:
            filters.append(RunningSession.started_at >= start)
        if end:
            filters.append(RunningSession.started_at <= end)
        total = await self.session.scalar(select(func.count(RunningSession.id)).where(*filters))
        rows = await self.session.scalars(
            select(RunningSession)
            .options(selectinload(RunningSession.points))
            .where(*filters)
            .order_by(RunningSession.started_at.desc())
            .limit(limit)
            .offset(offset)
        )
        return list(rows), int(total or 0)

    async def delete(self, run: RunningSession) -> None:
        await self.session.delete(run)
        await self.session.flush()
