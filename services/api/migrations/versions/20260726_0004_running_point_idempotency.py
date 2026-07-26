"""Add stable client UUIDs for running points."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "20260726_0004"
down_revision: str | None = "20260726_0003"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column("running_points", sa.Column("client_point_id", sa.Uuid(), nullable=True))
    op.create_unique_constraint(
        "uq_point_run_client", "running_points", ["running_session_id", "client_point_id"]
    )


def downgrade() -> None:
    op.drop_constraint("uq_point_run_client", "running_points", type_="unique")
    op.drop_column("running_points", "client_point_id")
