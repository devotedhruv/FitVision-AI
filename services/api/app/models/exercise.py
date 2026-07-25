"""Versioned exercise catalogue definitions."""

from typing import TYPE_CHECKING, Any

from sqlalchemy import JSON, Boolean, Index, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, TimestampMixin, UUIDPrimaryKeyMixin

if TYPE_CHECKING:
    from app.models.workout_session import WorkoutSession


class ExerciseDefinition(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "exercise_definitions"
    __table_args__ = (Index("ix_exercise_definitions_slug", "slug", unique=True),)

    slug: Mapped[str] = mapped_column(String(80), unique=True)
    name: Mapped[str] = mapped_column(String(120))
    description: Mapped[str] = mapped_column(Text)
    category: Mapped[str] = mapped_column(String(80))
    supported_view: Mapped[str] = mapped_column(String(80))
    instructions: Mapped[list[dict[str, Any]]] = mapped_column(JSON, default=list)
    rule_version: Mapped[str] = mapped_column(String(40))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, index=True)
    workouts: Mapped[list["WorkoutSession"]] = relationship(back_populates="exercise")
