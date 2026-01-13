"""Docstring для services.fastapi.app.routers.projects."""

from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session  # pylint: disable=wrong-import-order

from app.db.database import get_db
from app.db.models import TestappProject
from app.db.schemas import ProjectResponse

router = APIRouter(prefix="/api/v1")


# http://localhost:1338/fastapi/api/v1/projects
@router.get("/projects", response_model=list[ProjectResponse])  # noqa: FAST001
def get_projects(db: Annotated[Session, Depends(get_db)]) -> list[ProjectResponse]:
    """_summary_.

    :return: _description_
    :rtype: dict
    """
    return db.query(TestappProject).limit(100).all()


# http://localhost:1338/fastapi/api/v1/projects/1
@router.get("/projects/{project_id}")
def get_project(project_id: int) -> dict:
    """_summary_.

    :param user_id: _description_
    :type user_id: int
    :return: _description_
    :rtype: dict
    """
    return {"project_id": project_id}
