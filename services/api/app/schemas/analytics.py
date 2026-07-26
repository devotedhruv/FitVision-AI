"""Deterministic private analytics contracts."""

from datetime import date
from enum import StrEnum

from pydantic import BaseModel, Field


class AnalyticsPeriodType(StrEnum):
    daily = "daily"
    weekly = "weekly"
    monthly = "monthly"


class ExerciseAnalytics(BaseModel):
    exercise_type: str
    session_count: int = Field(ge=0)
    completed_reps: int = Field(ge=0)
    incomplete_reps: int = Field(ge=0)
    valid_form_reps: int = Field(ge=0)
    valid_form_ratio: float | None = Field(default=None, ge=0, le=1)
    average_form_score: float | None = Field(default=None, ge=0, le=100)


class RunningAnalytics(BaseModel):
    run_count: int = Field(ge=0)
    total_distance_meters: float = Field(ge=0)
    total_active_duration_seconds: int = Field(ge=0)
    weighted_average_pace_seconds_per_km: float | None = Field(default=None, ge=0)


class AnalyticsInsight(BaseModel):
    code: str
    priority: int
    localization_key: str
    current_value: float | None = None
    previous_value: float | None = None


class AnalyticsSummary(BaseModel):
    period: AnalyticsPeriodType = AnalyticsPeriodType.weekly
    start_date: date | None = None
    end_date: date | None = None
    total_workout_sessions: int = Field(ge=0)
    total_reps: int = Field(ge=0)
    valid_reps: int = Field(ge=0)
    invalid_reps: int = Field(ge=0)
    average_form_score: float | None = Field(default=None, ge=0, le=100)
    total_running_sessions: int = Field(ge=0)
    total_running_distance: float = Field(ge=0)
    total_running_duration: int = Field(ge=0)
    weighted_average_pace_seconds_per_km: float | None = Field(default=None, ge=0)
    active_days: int = Field(default=0, ge=0)
    exercises: list[ExerciseAnalytics] = Field(default_factory=list)
    running: RunningAnalytics | None = None
    insights: list[AnalyticsInsight] = Field(default_factory=list)
