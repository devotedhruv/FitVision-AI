"""Create Phase 3 profiles, catalogue, workout, and running tables."""

from alembic import op

from app import models  # noqa: F401
from app.db.base import Base

revision = "20260725_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    Base.metadata.create_all(bind=op.get_bind(), checkfirst=False)


def downgrade() -> None:
    for table in reversed(Base.metadata.sorted_tables):
        table.drop(bind=op.get_bind(), checkfirst=False)
