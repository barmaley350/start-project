#!/bin/sh
echo "-------------------------------"
echo "Hello and welcome"
echo "-------------------------------"

BASE_DIR="/home/home/my/RepoCode/empty_dummy_project/"
PATH_TO_BACKEND="services/backend"
PATH_TO_BACKEND_DOCS="services/backend/docs"

# Generate sphinx docs for backend/django
cd $BASE_DIR$PATH_TO_BACKEND_DOCS
pipenv run make html

if [ $? -ne 0 ]; then
    echo "Генерация документации Sphinx...Error "
    echo ""
    exit $?
fi

echo "Генерация документации Sphinx...OK "

# Ruff linter backend/django
cd $BASE_DIR$PATH_TO_BACKEND

pipenv run ruff check --fix

if [ $? -ne 0 ]; then
    echo "ruff check...Error "
    echo ""
    exit $?
fi
echo "ruff check...OK "

# Ruff formater backend/django
pipenv run ruff format

if [ $? -ne 0 ]; then
    echo "ruff format...Error "
    echo ""
    exit $?
fi
echo "ruff format...OK "

# pytest backend/django
docker exec -it empty_dummy_project-service.backend-1 pipenv run pytest

if [ $? -ne 0 ]; then
    echo "pytest...Error "
    echo ""
    exit $?
fi
echo "pytest...OK "

cd $BASE_DIR
git status