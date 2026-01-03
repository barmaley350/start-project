# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim AS base

# Рабочая директория
ENV APP_ROOT=/app

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Переменная окружения для pipenv
# Указывает pipenv, что надо использовать эту директорию для
# сохранения файлов виртуального окружения
ENV WORKON_HOME=/venv

RUN apt-get update && apt-get install -y --no-install-recommends bash

# Обновление pip и установка pipenv
RUN pip install --upgrade pip --no-cache-dir
RUN pip install pipenv --no-cache-dir


# Промежуточный образ для сборки
# Примерная экономия в размере образа ~ 70Mb
FROM base AS build

WORKDIR ${APP_ROOT}

COPY ./services/fastapi/Pipfile ${APP_ROOT}
COPY ./services/fastapi/Pipfile.lock ${APP_ROOT}

RUN pipenv sync --dev
RUN pipenv --clear


# Итоговый образ
FROM base

COPY --from=build ${WORKON_HOME} ${WORKON_HOME}
WORKDIR ${APP_ROOT}

# Для продакшн
# COPY ./backend ${APP_ROOT}

# RUN pipenv run gunicorn 'hh.wsgi' --bind=0.0.0.0:8000