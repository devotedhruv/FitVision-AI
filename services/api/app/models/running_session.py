"""User-owned running session summary model."""

from datetime import datetime
from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    Float,
    ForeignKey,
    Index,
    Integer,
    UniqueConstraint,
    Uuid,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, TimestampMixin, UUIDPrimaryKeyMixin

if TYPE_CHECKING:
    from app.models.profile import Profile
    from app.models.running_point import RunningPoint


class RunningSession(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "running_sessions"
    __table_args__ = (
        UniqueConstraint("user_id", "client_session_id", name="uq_run_user_client"),
        CheckConstraint("distance_meters >= 0", name="distance_nonnegative"),
        CheckConstraint("duration_seconds >= 0", name="duration_nonnegative"),
        CheckConstraint(
            "completed_at IS NULL OR completed_at >= started_at", name="completion_order"
        ),
        Index("ix_run_user_started", "user_id", "started_at"),
    )

    client_session_id: Mapped[UUID] = mapped_column(Uuid)
    user_id: Mapped[UUID] = mapped_column(ForeignKey("profiles.id", ondelete="CASCADE"), index=True)
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    distance_meters: Mapped[float] = mapped_column(Float)
    duration_seconds: Mapped[int] = mapped_column(Integer)
    average_pace_seconds_per_km: Mapped[float | None] = mapped_column(Float)
    maximum_speed_mps: Mapped[float | None] = mapped_column(Float)
    user: Mapped["Profile"] = relationship(back_populates="runs")
    points: Mapped[list["RunningPoint"]] = relationship(
        back_populates="running_session",
        cascade="all, delete-orphan",
        order_by="RunningPoint.sequence_number",
        lazy="selectin",
    )
