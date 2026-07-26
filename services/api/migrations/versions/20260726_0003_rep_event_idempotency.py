"""Add optional mobile-generated rep-event idempotency keys."""

import sqlalchemy as sa
from alembic import op

revision = "20260726_0003"
down_revision = "20260725_0002"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("rep_events", sa.Column("client_event_id", sa.Uuid(), nullable=True))
    op.create_unique_constraint(
        "uq_rep_workout_client_event",
        "rep_events",
        ["workout_session_id", "client_event_id"],
    )


def downgrade() -> None:
    op.drop_constraint("uq_rep_workout_client_event", "rep_events", type_="unique")
    op.drop_column("rep_events", "client_event_id")
