"""Per-repetition workout event model."""

from datetime import datetime
from typing import TYPE_CHECKING, Any
from uuid import UUID

from sqlalchemy import (
    JSON,
    Boolean,
    CheckConstraint,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, UUIDPrimaryKeyMixin, utc_now

if TYPE_CHECKING:
    from app.models.workout_session import WorkoutSession


class RepEvent(UUIDPrimaryKeyMixin, Base):
    __tablename__ = "rep_events"
    __table_args__ = (
        UniqueConstraint("workout_session_id", "rep_number", name="uq_rep_workout_number"),
        CheckConstraint("rep_number > 0", name="rep_number_positive"),
        CheckConstraint("duration_ms >= 0", name="duration_nonnegative"),
    )

    workout_session_id: Mapped[UUID] = mapped_column(
        ForeignKey("workout_sessions.id", ondelete="CASCADE"), index=True
    )
    rep_number: Mapped[int] = mapped_column(Integer)
    duration_ms: Mapped[int] = mapped_column(Integer)
    minimum_angle: Mapped[float | None] = mapped_column(Float)
    maximum_angle: Mapped[float | None] = mapped_column(Float)
    is_valid: Mapped[bool] = mapped_column(Boolean)
    form_issues: Mapped[list[dict[str, Any]]] = mapped_column(JSON, default=list)
    recorded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)
    workout_session: Mapped["WorkoutSession"] = relationship(back_populates="rep_events")
