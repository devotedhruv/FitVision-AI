"""Schema metadata contains required ownership and idempotency protections."""

from app import models  # noqa: F401
from app.db.base import Base


def constraint_names(table_name: str) -> set[str]:
    return {
        constraint.name
        for constraint in Base.metadata.tables[table_name].constraints
        if constraint.name
    }


def test_idempotency_and_child_uniqueness_constraints_exist():
    assert "uq_workout_user_client" in constraint_names("workout_sessions")
    assert "uq_run_user_client" in constraint_names("running_sessions")
    assert "uq_rep_workout_number" in constraint_names("rep_events")
    assert "uq_point_run_sequence" in constraint_names("running_points")


def test_all_user_owned_foreign_keys_are_indexed():
    assert Base.metadata.tables["workout_sessions"].c.user_id.index
    assert Base.metadata.tables["running_sessions"].c.user_id.index
    assert Base.metadata.tables["rep_events"].c.workout_session_id.index
    assert Base.metadata.tables["running_points"].c.running_session_id.index
