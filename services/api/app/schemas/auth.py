"""Verified Supabase token claims and safe session response."""

from datetime import UTC, datetime
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field, field_validator


class CurrentUserClaims(BaseModel):
    user_id: UUID
    email: EmailStr | None = None
    role: str = Field(default="authenticated", max_length=80)
    expires_at: datetime
    identity_provider: str = "supabase"
    provider_subject: str | None = None

    @field_validator("expires_at")
    @classmethod
    def make_expiration_aware(cls, value: datetime) -> datetime:
        return value.replace(tzinfo=UTC) if value.tzinfo is None else value


class AuthSessionResponse(CurrentUserClaims):
    pass
