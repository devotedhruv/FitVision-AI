"""Pure request validation tests for workout and running business invariants."""

from datetime import UTC, datetime, timedelta
from uuid import uuid4

import pytest
from pydantic import ValidationError

from app.schemas.profile import ProfileUpdate
from app.schemas.run import RunCreate
from app.schemas.workout import WorkoutCreate


def test_profile_rejects_ownership_fields():
    with pytest.raises(ValidationError):
        ProfileUpdate.model_validate({"id": str(uuid4()), "display_name": "Alex"})


def test_workout_validates_counts_timestamps_and_duplicate_reps():
    now = datetime.now(UTC)
    base = {
        "client_session_id": uuid4(),
        "exercise_slug": "squat",
        "started_at": now,
        "completed_at": now + timedelta(minutes=1),
        "duration_seconds": 60,
        "total_reps": 1,
        "valid_reps": 1,
        "invalid_reps": 0,
        "rule_version": "1.0",
        "rep_events": [
            {
                "rep_number": 1,
                "duration_ms": 1000,
                "is_valid": True,
                "recorded_at": now,
            }
        ],
    }
    assert WorkoutCreate.model_validate(base).total_reps == 1
    with pytest.raises(ValidationError):
        WorkoutCreate.model_validate({**base, "invalid_reps": 1})
    with pytest.raises(ValidationError):
        WorkoutCreate.model_validate({**base, "completed_at": now - timedelta(seconds=1)})


def test_run_rejects_invalid_coordinates_and_unordered_points():
    now = datetime.now(UTC)
    base = {
        "client_session_id": uuid4(),
        "started_at": now,
        "distance_meters": 10,
        "duration_seconds": 5,
        "points": [
            {
                "sequence_number": 1,
                "latitude": 27.7,
                "longitude": 85.3,
                "recorded_at": now,
            }
        ],
    }
    with pytest.raises(ValidationError):
        RunCreate.model_validate(base)
    base["points"][0]["sequence_number"] = 0
    base["points"][0]["latitude"] = 91
    with pytest.raises(ValidationError):
        RunCreate.model_validate(base)
