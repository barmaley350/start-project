"""Docstring для services.fastapi.db.main."""

from fastapi import FastAPI
from models import (  # noqa: F401
    Base,
    # TestappComment,
    # TestappProject,
    # TestappProjectTags,
    # TestappTag,
)
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Строка подключения к SQLite
SQLALCHEMY_DATABASE_URL = "sqlite:///./database.db"

# Создаём движок
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},  # Только для SQLite
)

# Фабрика сессий
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


# Функция для получения сессии БД
def get_db() -> None:  # pyright: ignore[reportInvalidTypeForm]
    """Docstring для get_db."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Инициализация приложения
app = FastAPI()


Base.metadata.create_all(bind=engine)
