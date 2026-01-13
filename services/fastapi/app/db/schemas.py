"""Docstring для services.fastapi.app.db.schemas."""

from datetime import datetime

from pydantic import BaseModel


class UserResponce(BaseModel):
    """_summary_.

    :param BaseModel: _description_
    :type BaseModel: _type_
    """

    id: int
    first_name: str
    last_name: str
    email: str


class CommentResponse(BaseModel):
    """_summary_.

    :param BaseModel: _description_
    :type BaseModel: _type_
    """

    id: int
    title: str
    description: str | None = None
    owner_id: int
    owner: UserResponce | None
    created_at: datetime

    class Config:
        """Docstring для Config."""

        from_attributes = True


class ProjectResponse(BaseModel):
    """_summary_.

    :param BaseModel: _description_
    :type BaseModel: _type_
    """

    id: int
    title: str
    description: str | None = None
    created_at: datetime
    owner: UserResponce | None
    testapp_comment: list[CommentResponse] = []

    class Config:  # pylint: disable=too-few-public-methods
        """Docstring для Config."""

        from_attributes = True  # вместо устаревшего orm_mode
