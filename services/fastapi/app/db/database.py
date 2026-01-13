"""Docstring для services.fastapi.app.db.database."""

import os
from collections.abc import Generator
from typing import Any

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

POSTGRES_DB = os.getenv("POSTGRES_DB")
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_HOST = os.getenv("POSTGRES_HOST")
POSTGRES_PORT = os.getenv("POSTGRES_PORT")

DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"  # pylint: disable=line-too-long
engine = create_engine(
    DATABASE_URL,
    pool_size=100,  # максимум активных соединений
    max_overflow=140,  # максимум временных соединений сверх лимита
    pool_timeout=30.0,  # ожидание в очереди (сек)
    pool_recycle=3600,  # пересоздание соединений каждые час
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)  # pylint: disable=invalid-name


def get_db() -> Generator[Session, Any, None]:
    """_summary_.

    :yield: _description_
    :rtype: Generator[Session, Any, None]
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
