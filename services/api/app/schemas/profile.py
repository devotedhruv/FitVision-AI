"""Profile create/update and response contracts."""

from datetime import date, datetime
from uuid import UUID

from pydantic import Field, HttpUrl, field_validator

from app.models.profile import FitnessLevel, PreferredUnits
from app.schemas.common import ORMResponse, StrictSchema


class ProfileUpsert(StrictSchema):
    display_name: str = Field(min_length=1, max_length=100)
    avatar_url: HttpUrl | None = None
    preferred_units: PreferredUnits = PreferredUnits.METRIC


class ProfileUpdate(StrictSchema):
    display_name: str | None = Field(default=None, min_length=1, max_length=100)
    avatar_url: HttpUrl | None = None
    preferred_units: PreferredUnits | None = None
    date_of_birth: date | None = None
    gender: str | None = Field(default=None, max_length=40)
    country: str | None = Field(default=None, max_length=80)
    timezone: str | None = Field(default=None, max_length=80)
    preferred_language: str | None = Field(default=None, max_length=16)
    height_cm: float | None = Field(default=None, ge=80, le=260)
    weight_kg: float | None = Field(default=None, ge=25, le=400)
    target_weight_kg: float | None = Field(default=None, ge=25, le=400)
    fitness_level: FitnessLevel | None = None
    fitness_goal: str | None = Field(default=None, max_length=100)
    activity_level: str | None = Field(default=None, max_length=60)
    movement_limitations: str | None = Field(default=None, max_length=1000)
    medical_notice_acknowledged: bool | None = None

    @field_validator("date_of_birth")
    @classmethod
    def birth_date_must_not_be_future(cls, value: date | None) -> date | None:
        if value is not None and value > date.today():
            raise ValueError("Date of birth cannot be in the future")
        return value


class ProfileResponse(ORMResponse):
    id: UUID
    display_name: str
    avatar_url: str | None
    preferred_units: PreferredUnits
    date_of_birth: date | None
    gender: str | None
    country: str | None
    timezone: str | None
    preferred_language: str | None
    height_cm: float | None
    weight_kg: float | None
    target_weight_kg: float | None
    fitness_level: FitnessLevel | None
    fitness_goal: str | None
    activity_level: str | None
    movement_limitations: str | None
    medical_notice_acknowledged: bool
    created_at: datetime
    updated_at: datetime
