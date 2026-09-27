"""Add owner_name source accuracy to Mine model

Revision ID: 88840871aa26
Revises: 95213334dc11
Create Date: 2026-09-27 15:36:31.250731

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '88840871aa26'
down_revision: Union[str, Sequence[str], None] = '95213334dc11'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column('mines', sa.Column('owner_name', sa.String(), nullable=True))
    op.add_column('mines', sa.Column('coordinate_accuracy', sa.String(), nullable=True))
    op.add_column('mines', sa.Column('source', sa.String(), nullable=True))


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_column('mines', 'source')
    op.drop_column('mines', 'coordinate_accuracy')
    op.drop_column('mines', 'owner_name')
