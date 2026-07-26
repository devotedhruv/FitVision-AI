"""Workout session request and response contracts."""

from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import Field, field_validator, model_validator

from app.schemas.common import ORMResponse, StrictSchema, require_timezone


class RepEventCreate(StrictSchema):
    client_event_id: UUID | None = None
    rep_number: int = Field(gt=0)
    duration_ms: int = Field(ge=0)
    minimum_angle: float | None = Field(default=None, ge=0, le=360)
    maximum_angle: float | None = Field(default=None, ge=0, le=360)
    is_valid: bool
    form_issues: list[dict[str, Any]] = Field(default_factory=list, max_length=20)
    recorded_at: datetime

    _timezone = field_validator("recorded_at")(require_timezone)


class WorkoutCreate(StrictSchema):
    client_session_id: UUID
    exercise_slug: str = Field(min_length=1, max_length=80)
    started_at: datetime
    completed_at: datetime | None = None
    duration_seconds: int = Field(ge=0)
    total_reps: int = Field(ge=0)
    valid_reps: int = Field(ge=0)
    invalid_reps: int = Field(ge=0)
    form_score: float | None = Field(default=None, ge=0, le=100)
    average_rep_duration_ms: int | None = Field(default=None, ge=0)
    rule_version: str = Field(min_length=1, max_length=40)
    device_id: str | None = Field(default=None, max_length=200)
    rep_events: list[RepEventCreate] = Field(default_factory=list, max_length=500)

    _timezone = field_validator("started_at", "completed_at")(require_timezone)

    @model_validator(mode="after")
    def validate_session(self) -> "WorkoutCreate":
        if self.completed_at and self.completed_at < self.started_at:
            raise ValueError("completed_at must not be earlier than started_at")
        if self.valid_reps + self.invalid_reps != self.total_reps:
            raise ValueError("valid_reps plus invalid_reps must equal total_reps")
        numbers = [event.rep_number for event in self.rep_events]
        if len(numbers) != len(set(numbers)):
            raise ValueError("rep_number values must be unique")
        if len(self.rep_events) != self.total_reps:
            raise ValueError("rep_events count must equal total_reps")
        return self


class RepEventResponse(ORMResponse):
    id: UUID
    client_event_id: UUID | None
    rep_number: int
    duration_ms: int
    minimum_angle: float | None
    maximum_angle: float | None
    is_valid: bool
    form_issues: list[dict[str, Any]]
    recorded_at: datetime
    created_at: datetime


class WorkoutResponse(ORMResponse):
    id: UUID
    client_session_id: UUID
    exercise_id: UUID
    started_at: datetime
    completed_at: datetime | None
    duration_seconds: int
    total_reps: int
    valid_reps: int
    invalid_reps: int
    form_score: float | None
    average_rep_duration_ms: int | None
    rule_version: str
    device_id: str | None
    created_at: datetime
    updated_at: datetime
    rep_events: list[RepEventResponse]
