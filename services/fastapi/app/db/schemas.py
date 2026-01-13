"""Docstring для services.fastapi.app.db.schemas."""

from datetime import datetime

from pydantic import BaseModel


class ProjectResponse(BaseModel):
    """_summary_.

    :param BaseModel: _description_
    :type BaseModel: _type_
    """

    id: int
    title: str
    description: str | None = None
    created_at: datetime

    class Config:
        """Docstring для Config."""

        from_attributes = True  # вместо устаревшего orm_mode
