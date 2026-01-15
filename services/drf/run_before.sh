#!/bin/sh
echo "Start RUN_BEFORE"
uv run python3 run_before.py
uv run python3 manage.py collectstatic --noinput
uv run python3 manage.py makemigrations
uv run python3 manage.py migrate
echo "End RUN_BEFORE"