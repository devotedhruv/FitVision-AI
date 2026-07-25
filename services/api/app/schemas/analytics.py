"""Basic user-scoped analytics response."""

from pydantic import BaseModel, Field


class AnalyticsSummary(BaseModel):
    total_workout_sessions: int = Field(ge=0)
    total_reps: int = Field(ge=0)
    valid_reps: int = Field(ge=0)
    invalid_reps: int = Field(ge=0)
    average_form_score: float | None = Field(default=None, ge=0, le=100)
    total_running_sessions: int = Field(ge=0)
    total_running_distance: float = Field(ge=0)
    total_running_duration: int = Field(ge=0)
