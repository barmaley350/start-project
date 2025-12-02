"""Docstring for services.backend.gunicorn."""

import os

bind = "0.0.0.0:" + os.environ.get("PORT", "8000")
reload = True
