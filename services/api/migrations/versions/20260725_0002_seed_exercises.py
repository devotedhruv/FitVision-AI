"""Seed the five versioned Phase 3 exercise definitions."""

from datetime import UTC, datetime
from uuid import UUID

from alembic import op
from sqlalchemy import JSON, Boolean, DateTime, String, Uuid, column, table

revision = "20260725_0002"
down_revision = "20260725_0001"
branch_labels = None
depends_on = None

exercise_definitions = table(
    "exercise_definitions",
    column("id", Uuid),
    column("slug", String),
    column("name", String),
    column("description", String),
    column("category", String),
    column("supported_view", String),
    column("instructions", JSON),
    column("rule_version", String),
    column("is_active", Boolean),
    column("created_at", DateTime(timezone=True)),
    column("updated_at", DateTime(timezone=True)),
)

SEEDS = [
    (
        "00000000-0000-4000-8000-000000000001",
        "squat",
        "Squat",
        "Lower-body squat movement.",
        "strength",
        "side",
        True,
    ),
    (
        "00000000-0000-4000-8000-000000000002",
        "biceps-curl",
        "Biceps Curl",
        "Arm curl movement.",
        "strength",
        "side",
        True,
    ),
    (
        "00000000-0000-4000-8000-000000000003",
        "push-up",
        "Push-up",
        "Upper-body pushing movement.",
        "strength",
        "side",
        True,
    ),
    (
        "00000000-0000-4000-8000-000000000004",
        "lunge",
        "Lunge",
        "Split-stance lower-body movement.",
        "strength",
        "side",
        False,
    ),
    (
        "00000000-0000-4000-8000-000000000005",
        "plank",
        "Plank",
        "Static core stability hold.",
        "stability",
        "side",
        False,
    ),
]


def upgrade() -> None:
    now = datetime.now(UTC)
    op.bulk_insert(
        exercise_definitions,
        [
            {
                "id": UUID(identifier),
                "slug": slug,
                "name": name,
                "description": description,
                "category": category,
                "supported_view": view,
                "instructions": [
                    {
                        "step": "Follow in-app guidance and stop if unsafe.",
                        "mvp": _is_mvp,
                    }
                ],
                "rule_version": "1.0.0",
                "is_active": True,
                "created_at": now,
                "updated_at": now,
            }
            for identifier, slug, name, description, category, view, _is_mvp in SEEDS
        ],
    )


def downgrade() -> None:
    op.execute(
        exercise_definitions.delete().where(
            exercise_definitions.c.slug.in_([seed[1] for seed in SEEDS])
        )
    )
