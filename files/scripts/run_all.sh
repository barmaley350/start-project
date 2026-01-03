#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


SCRIPT_DIR="$(dirname "$0")"
cd $SCRIPT_DIR
cd ../../
BASE_DIR=$(pwd)

. $BASE_DIR/.env

PATH_TO_BACKEND="/services/drf"
PATH_TO_BACKEND_DOCS="/services/drf/docs"

print_text_success() {
    echo -e "${GREEN} \u2714 $1${NC}"
}

print_text_error() {
    echo -e "${RED} \u2718 $1${NC}"
}

line_output() {
    for i in {1..70}; do echo -en "\u2501"; done
    echo -e ""
}

print_text_block() {
    case $1 in
        success)
            line_output
            print_text_success "$2"
            line_output
            ;;
        error)
            line_output
            print_text_error "$2"
            line_output
            ;;
    esac
}

# Generate sphinx docs for backend/django
generate_sphinx_docs() {
    cd $BASE_DIR$PATH_TO_BACKEND_DOCS
    pipenv run make clean
    pipenv run make html

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка при создании документации Sphinx"  
        exit $?
    fi

    print_text_block success "Генерация документации Sphinx прошла успешно"
    return 0
}


# Generate sphinx docs for backend/django
generate_graph_models() {
    cd $BASE_DIR$PATH_TO_BACKEND
    pipenv run python3 manage.py graph_models testapp -o docs/_static/testapp.png
    pipenv run python3 manage.py graph_models sphinx_docs -o docs/_static/sphinx_docs.png
    pipenv run python3 manage.py graph_models -o docs/_static/all.png

    if [ $? -ne 0 ]; then
        print_text_block error "Генерация картинки структуры DB...Error "
        exit $?
    fi
    cp docs/_static/* $BASE_DIR/files/img/graph_models

    print_text_block success "Генерация картинки структуры DB...OK "
    return 0
}

start_ruff_check() {
    cd $BASE_DIR$PATH_TO_BACKEND

    pipenv run ruff check --fix

    if [ $? -ne 0 ]; then
        print_text_block error "ruff check...Error "
        exit $?
    fi
    print_text_block success "ruff check...OK "
    return 0
}

start_ruff_format() {
    # Ruff formater backend/django
    pipenv run ruff format

    if [ $? -ne 0 ]; then
        print_text_block error "ruff format...Error "
        exit $?
    fi
    print_text_block success "ruff format...OK "
}


start_tests() {
    # pytest backend/django
    docker exec -it ${PROJECT_NAME}-service.drf-1 pipenv run pytest

    if [ $? -ne 0 ]; then
        print_text_block error "pytest...Error "
        exit $?
    fi
    print_text_block success "pytest...OK "
}

start_git() {
    cd $BASE_DIR
    git status 
}



main() {
    generate_graph_models
    generate_sphinx_docs
    start_ruff_check
    start_ruff_format
    start_tests
    start_git
}

main "$@"