"""Docstring для services.fastapi.app.main."""

from dotenv import load_dotenv
from fastapi import FastAPI

from .routers.main import router as main_router
from .routers.projects import router as projects_router

load_dotenv()

app = FastAPI(
    title="FastAPI",
    version="1.0.0",
    root_path="/fastapi",
)

app.include_router(main_router)
app.include_router(projects_router)
