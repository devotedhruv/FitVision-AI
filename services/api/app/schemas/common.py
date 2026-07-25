"""Shared API response and validation primitives."""

from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field, model_validator


class StrictSchema(BaseModel):
    model_config = ConfigDict(extra="forbid")


class ORMResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)


class Page[T](ORMResponse):
    items: list[T]
    total: int = Field(ge=0)
    limit: int = Field(ge=1)
    offset: int = Field(ge=0)


class DateRange(StrictSchema):
    start_date: date | None = None
    end_date: date | None = None

    @model_validator(mode="after")
    def validate_order(self) -> "DateRange":
        if self.start_date and self.end_date and self.end_date < self.start_date:
            raise ValueError("end_date must not be earlier than start_date")
        return self


def require_timezone(value: datetime | None) -> datetime | None:
    if value is not None and value.tzinfo is None:
        raise ValueError("Timestamp must include a timezone")
    return value


class ErrorDetail(BaseModel):
    code: str
    message: str
    details: list[dict[str, object]] | None = None


class ErrorResponse(BaseModel):
    error: ErrorDetail
