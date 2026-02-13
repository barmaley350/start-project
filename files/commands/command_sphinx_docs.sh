#!/bin/bash

command_drf_gendoc() {
    generate_graph_models
    generate_sphinx_docs
    command_collectstatic
} 
generate_sphinx_docs() {
    # cd $SCRIPT_DIR$PATH_TO_BACKEND_DOCS
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    rm -rf apps/sphinx_docs/docs/_build/html
    # uv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html clean
    # uv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html html
    uv run sphinx-build -b html apps/sphinx_docs/docs apps/sphinx_docs/docs/_build/html

    check_command_run_status $? "Генерация документации"
}

generate_graph_models() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    print_text_white "Создаем graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png\n"
    uv run python3 manage.py graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png

    print_text_white "Создаем graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png\n"
    uv run python3 manage.py graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png

    print_text_white "Создаем graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png\n"
    uv run python3 manage.py graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png

    print_text_white "Создаем graph_models -o apps/sphinx_docs/docs/_static/all.png\n"
    uv run python3 manage.py graph_models -o apps/sphinx_docs/docs/_static/all.png

    check_command_run_status $? "Генерация graph_models"
}

command_collectstatic() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py collectstatic --noinput

    check_command_run_status $? "Выполнение collectstatic"
}