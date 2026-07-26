from pathlib import Path

RLS_SQL = (
    (
        Path(__file__).resolve().parents[2]
        / "migrations"
        / "supabase"
        / "001_enable_rls_and_policies.sql"
    )
    .read_text()
    .lower()
)


def test_every_user_owned_table_has_rls_enabled():
    for table in (
        "profiles",
        "workout_sessions",
        "rep_events",
        "running_sessions",
        "running_points",
    ):
        assert f"alter table public.{table} enable row level security" in RLS_SQL


def test_parent_and_child_ownership_policies_cover_all_operations():
    for prefix in ("workouts", "runs"):
        for operation in ("select", "insert", "update", "delete"):
            assert f'create policy "{prefix}_{operation}_own"' in RLS_SQL
    for prefix in ("rep_events", "running_points"):
        for operation in ("select", "insert", "update", "delete"):
            assert f'create policy "{prefix}_{operation}_owned"' in RLS_SQL
    assert "auth.uid()" in RLS_SQL
    assert " to anon" not in RLS_SQL
