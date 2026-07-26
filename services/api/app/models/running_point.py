"""Ordered GPS point model for persisted run summaries."""

from datetime import datetime
from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import CheckConstraint, DateTime, Float, ForeignKey, Integer, UniqueConstraint, Uuid
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base, UUIDPrimaryKeyMixin

if TYPE_CHECKING:
    from app.models.running_session import RunningSession


class RunningPoint(UUIDPrimaryKeyMixin, Base):
    __tablename__ = "running_points"
    __table_args__ = (
        UniqueConstraint("running_session_id", "sequence_number", name="uq_point_run_sequence"),
        UniqueConstraint("running_session_id", "client_point_id", name="uq_point_run_client"),
        CheckConstraint("sequence_number >= 0", name="sequence_nonnegative"),
        CheckConstraint("latitude >= -90 AND latitude <= 90", name="latitude_range"),
        CheckConstraint("longitude >= -180 AND longitude <= 180", name="longitude_range"),
        CheckConstraint(
            "accuracy_meters IS NULL OR accuracy_meters >= 0", name="accuracy_nonnegative"
        ),
    )

    running_session_id: Mapped[UUID] = mapped_column(
        ForeignKey("running_sessions.id", ondelete="CASCADE"), index=True
    )
    sequence_number: Mapped[int] = mapped_column(Integer)
    client_point_id: Mapped[UUID | None] = mapped_column(Uuid, nullable=True)
    latitude: Mapped[float] = mapped_column(Float)
    longitude: Mapped[float] = mapped_column(Float)
    accuracy_meters: Mapped[float | None] = mapped_column(Float)
    recorded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    running_session: Mapped["RunningSession"] = relationship(back_populates="points")
