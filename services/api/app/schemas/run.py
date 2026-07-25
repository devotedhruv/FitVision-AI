"""Running session request and response contracts."""

from datetime import datetime
from uuid import UUID

from pydantic import Field, field_validator, model_validator

from app.schemas.common import ORMResponse, StrictSchema, require_timezone


class RunningPointCreate(StrictSchema):
    sequence_number: int = Field(ge=0)
    latitude: float = Field(ge=-90, le=90)
    longitude: float = Field(ge=-180, le=180)
    accuracy_meters: float | None = Field(default=None, ge=0)
    recorded_at: datetime

    _timezone = field_validator("recorded_at")(require_timezone)


class RunCreate(StrictSchema):
    client_session_id: UUID
    started_at: datetime
    completed_at: datetime | None = None
    distance_meters: float = Field(ge=0)
    duration_seconds: int = Field(ge=0)
    average_pace_seconds_per_km: float | None = Field(default=None, ge=0)
    maximum_speed_mps: float | None = Field(default=None, ge=0)
    points: list[RunningPointCreate] = Field(default_factory=list, max_length=5000)

    _timezone = field_validator("started_at", "completed_at")(require_timezone)

    @model_validator(mode="after")
    def validate_run(self) -> "RunCreate":
        if self.completed_at and self.completed_at < self.started_at:
            raise ValueError("completed_at must not be earlier than started_at")
        sequences = [point.sequence_number for point in self.points]
        if sequences != list(range(len(sequences))):
            raise ValueError("point sequence numbers must be contiguous and start at zero")
        return self


class RunningPointResponse(ORMResponse):
    id: UUID
    sequence_number: int
    latitude: float
    longitude: float
    accuracy_meters: float | None
    recorded_at: datetime


class RunResponse(ORMResponse):
    id: UUID
    client_session_id: UUID
    started_at: datetime
    completed_at: datetime | None
    distance_meters: float
    duration_seconds: int
    average_pace_seconds_per_km: float | None
    maximum_speed_mps: float | None
    created_at: datetime
    updated_at: datetime
    points: list[RunningPointResponse]
