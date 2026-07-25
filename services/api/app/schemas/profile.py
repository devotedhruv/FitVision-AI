"""Profile create/update and response contracts."""

from datetime import datetime
from uuid import UUID

from pydantic import Field, HttpUrl

from app.models.profile import PreferredUnits
from app.schemas.common import ORMResponse, StrictSchema


class ProfileUpsert(StrictSchema):
    display_name: str = Field(min_length=1, max_length=100)
    avatar_url: HttpUrl | None = None
    preferred_units: PreferredUnits = PreferredUnits.METRIC


class ProfileUpdate(StrictSchema):
    display_name: str | None = Field(default=None, min_length=1, max_length=100)
    avatar_url: HttpUrl | None = None
    preferred_units: PreferredUnits | None = None


class ProfileResponse(ORMResponse):
    id: UUID
    display_name: str
    avatar_url: str | None
    preferred_units: PreferredUnits
    created_at: datetime
    updated_at: datetime
