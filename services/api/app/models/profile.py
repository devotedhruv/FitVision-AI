"""Profile model keyed by the Supabase Auth user UUID."""

from datetime import date
from enum import StrEnum
from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import Boolean, Date, Enum, Float, String, Text, Uuid
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, TimestampMixin

if TYPE_CHECKING:
    from app.models.running_session import RunningSession
    from app.models.workout_session import WorkoutSession


class PreferredUnits(StrEnum):
    METRIC = "metric"
    IMPERIAL = "imperial"


class FitnessLevel(StrEnum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"


class Profile(TimestampMixin, Base):
    __tablename__ = "profiles"

    id: Mapped[UUID] = mapped_column(Uuid, primary_key=True)
    display_name: Mapped[str] = mapped_column(String(100))
    avatar_url: Mapped[str | None] = mapped_column(String(2048))
    date_of_birth: Mapped[date | None] = mapped_column(Date)
    gender: Mapped[str | None] = mapped_column(String(40))
    country: Mapped[str | None] = mapped_column(String(80))
    timezone: Mapped[str | None] = mapped_column(String(80))
    preferred_language: Mapped[str | None] = mapped_column(String(16))
    height_cm: Mapped[float | None] = mapped_column(Float)
    weight_kg: Mapped[float | None] = mapped_column(Float)
    target_weight_kg: Mapped[float | None] = mapped_column(Float)
    fitness_level: Mapped[FitnessLevel | None] = mapped_column(
        Enum(FitnessLevel, name="fitness_level", native_enum=False)
    )
    fitness_goal: Mapped[str | None] = mapped_column(String(100))
    activity_level: Mapped[str | None] = mapped_column(String(60))
    movement_limitations: Mapped[str | None] = mapped_column(Text)
    medical_notice_acknowledged: Mapped[bool] = mapped_column(Boolean, default=False)
    preferred_units: Mapped[PreferredUnits] = mapped_column(
        Enum(PreferredUnits, name="preferred_units", native_enum=False),
        default=PreferredUnits.METRIC,
    )
    workouts: Mapped[list["WorkoutSession"]] = relationship(back_populates="user")
    runs: Mapped[list["RunningSession"]] = relationship(back_populates="user")
