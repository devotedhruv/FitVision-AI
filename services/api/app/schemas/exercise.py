"""Exercise catalogue responses."""

from datetime import datetime
from typing import Any
from uuid import UUID

from app.schemas.common import ORMResponse


class ExerciseResponse(ORMResponse):
    id: UUID
    slug: str
    name: str
    description: str
    category: str
    supported_view: str
    instructions: list[dict[str, Any]]
    rule_version: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
