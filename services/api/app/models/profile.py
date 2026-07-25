"""Profile model keyed by the Supabase Auth user UUID."""

from enum import StrEnum
from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import Enum, String, Uuid
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, TimestampMixin

if TYPE_CHECKING:
    from app.models.running_session import RunningSession
    from app.models.workout_session import WorkoutSession


class PreferredUnits(StrEnum):
    METRIC = "metric"
    IMPERIAL = "imperial"


class Profile(TimestampMixin, Base):
    __tablename__ = "profiles"

    id: Mapped[UUID] = mapped_column(Uuid, primary_key=True)
    display_name: Mapped[str] = mapped_column(String(100))
    avatar_url: Mapped[str | None] = mapped_column(String(2048))
    preferred_units: Mapped[PreferredUnits] = mapped_column(
        Enum(PreferredUnits, name="preferred_units", native_enum=False),
        default=PreferredUnits.METRIC,
    )
    workouts: Mapped[list["WorkoutSession"]] = relationship(back_populates="user")
    runs: Mapped[list["RunningSession"]] = relationship(back_populates="user")
