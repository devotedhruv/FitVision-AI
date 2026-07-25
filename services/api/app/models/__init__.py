"""Import all ORM models so Alembic can discover metadata."""

from app.models.exercise import ExerciseDefinition
from app.models.profile import PreferredUnits, Profile
from app.models.rep_event import RepEvent
from app.models.running_point import RunningPoint
from app.models.running_session import RunningSession
from app.models.workout_session import WorkoutSession

__all__ = [
    "ExerciseDefinition",
    "PreferredUnits",
    "Profile",
    "RepEvent",
    "RunningPoint",
    "RunningSession",
    "WorkoutSession",
]
