"""Add optional health and fitness profile fields.

Revision ID: 20260726_0005
Revises: 20260726_0004
"""

from alembic import op
import sqlalchemy as sa

revision = "20260726_0005"
down_revision = "20260726_0004"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("profiles", sa.Column("date_of_birth", sa.Date(), nullable=True))
    op.add_column("profiles", sa.Column("gender", sa.String(40), nullable=True))
    op.add_column("profiles", sa.Column("country", sa.String(80), nullable=True))
    op.add_column("profiles", sa.Column("timezone", sa.String(80), nullable=True))
    op.add_column("profiles", sa.Column("preferred_language", sa.String(16), nullable=True))
    op.add_column("profiles", sa.Column("height_cm", sa.Float(), nullable=True))
    op.add_column("profiles", sa.Column("weight_kg", sa.Float(), nullable=True))
    op.add_column("profiles", sa.Column("target_weight_kg", sa.Float(), nullable=True))
    op.add_column("profiles", sa.Column("fitness_level", sa.String(20), nullable=True))
    op.add_column("profiles", sa.Column("fitness_goal", sa.String(100), nullable=True))
    op.add_column("profiles", sa.Column("activity_level", sa.String(60), nullable=True))
    op.add_column("profiles", sa.Column("movement_limitations", sa.Text(), nullable=True))
    op.add_column(
        "profiles",
        sa.Column("medical_notice_acknowledged", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    op.create_table(
        "auth_identities",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("provider", sa.String(30), nullable=False),
        sa.Column("provider_subject", sa.String(255), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["profiles.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("provider", "provider_subject", name="uq_auth_identity_subject"),
    )
    op.create_index("ix_auth_identities_user_id", "auth_identities", ["user_id"])
    op.execute(
        "INSERT INTO auth_identities (id, user_id, provider, provider_subject, created_at, updated_at) "
        "SELECT gen_random_uuid(), id, 'supabase', id::text, now(), now() FROM profiles"
    )


def downgrade() -> None:
    op.drop_index("ix_auth_identities_user_id", table_name="auth_identities")
    op.drop_table("auth_identities")
    for column in (
        "medical_notice_acknowledged", "movement_limitations", "activity_level",
        "fitness_goal", "fitness_level", "target_weight_kg", "weight_kg", "height_cm",
        "preferred_language", "timezone", "country", "gender", "date_of_birth",
    ):
        op.drop_column("profiles", column)
