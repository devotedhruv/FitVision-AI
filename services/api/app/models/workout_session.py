"""User-owned workout summary model."""

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
    String,
    UniqueConstraint,
    Uuid,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, TimestampMixin, UUIDPrimaryKeyMixin

if TYPE_CHECKING:
    from app.models.exercise import ExerciseDefinition
    from app.models.profile import Profile
    from app.models.rep_event import RepEvent


class WorkoutSession(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "workout_sessions"
    __table_args__ = (
        UniqueConstraint("user_id", "client_session_id", name="uq_workout_user_client"),
        CheckConstraint("duration_seconds >= 0", name="duration_nonnegative"),
        CheckConstraint(
            "total_reps >= 0 AND valid_reps >= 0 AND invalid_reps >= 0", name="reps_nonnegative"
        ),
        CheckConstraint("valid_reps + invalid_reps = total_reps", name="rep_counts_consistent"),
        CheckConstraint(
            "form_score IS NULL OR (form_score >= 0 AND form_score <= 100)", name="form_score_range"
        ),
        CheckConstraint(
            "completed_at IS NULL OR completed_at >= started_at", name="completion_order"
        ),
        Index("ix_workout_user_started", "user_id", "started_at"),
    )

    client_session_id: Mapped[UUID] = mapped_column(Uuid)
    user_id: Mapped[UUID] = mapped_column(ForeignKey("profiles.id", ondelete="CASCADE"), index=True)
    exercise_id: Mapped[UUID] = mapped_column(
        ForeignKey("exercise_definitions.id", ondelete="RESTRICT"), index=True
    )
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    duration_seconds: Mapped[int] = mapped_column(Integer)
    total_reps: Mapped[int] = mapped_column(Integer)
    valid_reps: Mapped[int] = mapped_column(Integer)
    invalid_reps: Mapped[int] = mapped_column(Integer)
    form_score: Mapped[float | None] = mapped_column(Float)
    average_rep_duration_ms: Mapped[int | None] = mapped_column(Integer)
    rule_version: Mapped[str] = mapped_column(String(40))
    device_id: Mapped[str | None] = mapped_column(String(200))
    user: Mapped["Profile"] = relationship(back_populates="workouts")
    exercise: Mapped["ExerciseDefinition"] = relationship(back_populates="workouts")
    rep_events: Mapped[list["RepEvent"]] = relationship(
        back_populates="workout_session",
        cascade="all, delete-orphan",
        order_by="RepEvent.rep_number",
        lazy="selectin",
    )
